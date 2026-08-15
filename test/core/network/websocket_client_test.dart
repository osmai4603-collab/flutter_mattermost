import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 30));

void main() {
  late WebSocketClientManager client;
  late List<TypedWebSocketEvent> events;
  late List<WebSocketStatus> statuses;

  setUp(() {
    client = WebSocketClientManager(SecureStorageService());
    events = [];
    statuses = [];
    client.eventStream.listen(events.add);
    client.statusStream.listen(statuses.add);
  });

  tearDown(() async {
    // يُلغي أي مؤقت إعادة اتصال معلّق ثم يُغلق القنوات.
    client.dispose();
    await _settle();
  });

  Map<String, dynamic> helloMessage({
    String connectionId = 'conn-1',
    String serverVersion = '11.11.0',
    int seq = 0,
  }) {
    return {
      'seq': seq,
      'event': 'hello',
      'data': {
        'connection_id': connectionId,
        'server_version': serverVersion,
        'server_hostname': '192.168.137.1',
      },
    };
  }

  group('WebSocketClientManager parsing', () {
    test('hello emits HelloEvent with connection details', () async {
      client.handleIncomingMessage(
        jsonEncode(
          helloMessage(connectionId: 'conn-abc', serverVersion: '11.11.0'),
        ),
      );
      await _settle();

      final hello = events.whereType<HelloEvent>();
      expect(hello, hasLength(1));
      expect(hello.first.connectionId, 'conn-abc');
      expect(hello.first.serverVersion, '11.11.0');
      expect(hello.first.serverHostname, '192.168.137.1');
      expect(statuses, isEmpty);
    });

    test('sequence advances across consecutive events', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"posted","data":{"post":"{\\"id\\":\\"p1\\",\\"channel_id\\":\\"c1\\",\\"create_at\\":1000}","channel_id":"c1"}}',
      );
      client.handleIncomingMessage(
        '{"seq":2,"event":"posted","data":{"post":"{\\"id\\":\\"p2\\",\\"channel_id\\":\\"c1\\",\\"create_at\\":2000}","channel_id":"c1"}}',
      );
      await _settle();

      expect(events.whereType<PostCreatedEvent>(), hasLength(2));
      // لا إعادة اتصال — التسلسل مستمر.
      expect(statuses, isEmpty);
    });

    test('sequence mismatch triggers reconnect (disconnected status)', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      // قفزة في السبك من 0 إلى 5 → فجوة → إعادة اتصال.
      client.handleIncomingMessage(
        '{"seq":5,"event":"posted","data":{"post":"{\\"id\\":\\"p1\\",\\"channel_id\\":\\"c1\\"}"}}',
      );
      await _settle();

      expect(statuses, contains(WebSocketStatus.disconnected));
      // لا يُمرَّر الحدث عند الفجوة.
      expect(events.whereType<PostCreatedEvent>(), isEmpty);
    });

    test('changed connection_id in hello triggers full resync event', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage(connectionId: 'conn-old')));
      await _settle();

      client.handleIncomingMessage(
        jsonEncode(helloMessage(connectionId: 'conn-new', seq: 0)),
      );
      await _settle();

      final reconnects = events.whereType<WebSocketReconnectedEvent>();
      expect(reconnects, hasLength(1));
      expect(reconnects.first.fullResync, isTrue);
    });

    test('same connection_id on re-hello does NOT trigger full resync', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage(connectionId: 'conn-1')));
      await _settle();

      client.handleIncomingMessage(
        jsonEncode(helloMessage(connectionId: 'conn-1', seq: 0)),
      );
      await _settle();

      expect(events.whereType<WebSocketReconnectedEvent>(), isEmpty);
    });

    test('auth FAIL response emits WebSocketAuthFailedEvent', () async {
      client.handleIncomingMessage(
        '{"status":"FAIL","data":{"error":"invalid token"},"seq_reply":1}',
      );
      await _settle();

      final failed = events.whereType<WebSocketAuthFailedEvent>();
      expect(failed, hasLength(1));
      expect(failed.first.error, contains('invalid token'));
      expect(statuses, isEmpty);
    });

    test('response (seq_reply) does not emit typed events or disconnect', () async {
      client.handleIncomingMessage(
        '{"status":"OK","data":{"text":"pong"},"seq_reply":1}',
      );
      await _settle();

      expect(events, isEmpty);
      expect(statuses, isEmpty);
    });

    test('status_change maps to UserPresenceEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"status_change","data":{"user_id":"u1","status":"online"}}',
      );
      await _settle();

      final presence = events.whereType<UserPresenceEvent>();
      expect(presence, hasLength(1));
      expect(presence.first.userId, 'u1');
      expect(presence.first.status, UserStatus.online);
    });

    test('post_unread maps to PostUnreadEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"post_unread","data":{"channel_id":"c1","msg_count":5,"mention_count":2,"last_viewed_at":"123"}}',
      );
      await _settle();

      final unread = events.whereType<PostUnreadEvent>();
      expect(unread, hasLength(1));
      expect(unread.first.channelId, 'c1');
      expect(unread.first.msgCount, 5);
      expect(unread.first.mentionCount, 2);
    });

    test('calls_call_start maps to CallStartedEvent (id/channelID keys)', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_start",'
        '"data":{"id":"call-1","channelID":"c1","thread_id":"t1","host_id":"u1"}}',
      );
      await _settle();

      final calls = events.whereType<CallStartedEvent>();
      expect(calls, hasLength(1));
      expect(calls.first.callId, 'call-1');
      expect(calls.first.channelId, 'c1');
      expect(calls.first.threadId, 't1');
    });

    test('calls_call_end maps to CallEndedEvent with channelId from broadcast',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_end",'
        '"data":{},"broadcast":{"channel_id":"c1"}}',
      );
      await _settle();

      final ended = events.whereType<CallEndedEvent>();
      expect(ended, hasLength(1));
      expect(ended.first.channelId, 'c1');
    });

    test('calls_user_joined maps to CallUserJoinedEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_user_joined",'
        '"data":{"user_id":"u1","session_id":"s1"},'
        '"broadcast":{"channel_id":"c1"}}',
      );
      await _settle();

      final joined = events.whereType<CallUserJoinedEvent>();
      expect(joined, hasLength(1));
      expect(joined.first.userId, 'u1');
      expect(joined.first.sessionId, 's1');
      expect(joined.first.channelId, 'c1');
    });

    test('calls_user_left maps to CallUserLeftEvent (userID camelCase + data channelID)',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_user_left",'
        '"data":{"user_id":"u1","session_id":"s1","channelID":"c1"}}',
      );
      await _settle();

      final left = events.whereType<CallUserLeftEvent>();
      expect(left, hasLength(1));
      expect(left.first.userId, 'u1');
      expect(left.first.sessionId, 's1');
      expect(left.first.channelId, 'c1');
    });

    test('calls_user_muted/unmuted map to CallUserMuteEvent with muted flag',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_user_muted",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      client.handleIncomingMessage(
        '{"seq":2,"event":"custom_com.mattermost.calls_user_unmuted",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      await _settle();

      final mutes = events.whereType<CallUserMuteEvent>().toList();
      expect(mutes, hasLength(2));
      expect(mutes[0].muted, isTrue);
      expect(mutes[1].muted, isFalse);
      expect(mutes[0].userId, 'u1');
    });

    test('calls_user_voice/screen/raise_hand/video map to their typed events',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_user_voice_on",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      client.handleIncomingMessage(
        '{"seq":2,"event":"custom_com.mattermost.calls_user_screen_off",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      client.handleIncomingMessage(
        '{"seq":3,"event":"custom_com.mattermost.calls_user_raise_hand",'
        '"data":{"userID":"u1","session_id":"s1","raised_hand":1710000000000}}',
      );
      client.handleIncomingMessage(
        '{"seq":4,"event":"custom_com.mattermost.calls_user_video_on",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      await _settle();

      expect(events.whereType<CallUserVoiceEvent>().single.voiceActive, isTrue);
      expect(
        events.whereType<CallScreenShareEvent>().single.sharing,
        isFalse,
      );
      expect(events.whereType<CallRaiseHandEvent>().single.raised, isTrue);
      expect(events.whereType<CallUserVideoEvent>().single.videoOn, isTrue);
      expect(events.whereType<CallUserMuteEvent>(), isEmpty);
    });

    test('calls_user_reacted maps to CallUserReactedEvent with emoji name',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_user_reacted",'
        '"data":{"user_id":"u1","session_id":"s1",'
        '"emoji":{"name":"grinning"},"timestamp":1710000000000}}',
      );
      await _settle();

      final reacted = events.whereType<CallUserReactedEvent>();
      expect(reacted, hasLength(1));
      expect(reacted.first.userId, 'u1');
      expect(reacted.first.emojiName, 'grinning');
      expect(reacted.first.timestamp, 1710000000000);
      expect(reacted.first.reacted, isTrue);
    });

    test('calls_call_host_changed maps to CallHostChangedEvent (hostID/call_id)',
        () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_host_changed",'
        '"data":{"hostID":"u2","call_id":"call-1"},'
        '"broadcast":{"channel_id":"c1"}}',
      );
      await _settle();

      final hostChanged = events.whereType<CallHostChangedEvent>();
      expect(hostChanged, hasLength(1));
      expect(hostChanged.first.hostId, 'u2');
      expect(hostChanged.first.callId, 'call-1');
      expect(hostChanged.first.channelId, 'c1');
    });

    test('calls_call_job_state maps to CallJobStateEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_job_state",'
        '"data":{"callID":"call-1",'
        '"jobState":{"job_type":"recording","job_state":"start_requested"}}}',
      );
      await _settle();

      final jobs = events.whereType<CallJobStateEvent>();
      expect(jobs, hasLength(1));
      expect(jobs.first.callId, 'call-1');
      expect(jobs.first.jobState['job_state'], 'start_requested');
    });

    test('calls_caption maps to CallCaptionEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_caption",'
        '"data":{"channel_id":"c1","user_id":"u1","session_id":"s1",'
        '"text":"hello"}}',
      );
      await _settle();

      final captions = events.whereType<CallCaptionEvent>();
      expect(captions, hasLength(1));
      expect(captions.first.text, 'hello');
      expect(captions.first.channelId, 'c1');
    });

    test('host_* and call_state fall through to generic CallStateEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_host_mute",'
        '"data":{"userID":"u1","session_id":"s1"}}',
      );
      client.handleIncomingMessage(
        '{"seq":2,"event":"custom_com.mattermost.calls_call_state",'
        '"data":{"enabled":true,"channel_id":"c1"}}',
      );
      await _settle();

      final states = events.whereType<CallStateEvent>().toList();
      expect(states, hasLength(2));
      expect(states[0].callEventName, 'host_mute');
      expect(states[1].callEventName, 'call_state');
      expect(states[0].data['userID'], 'u1');
      // لا تتسرب الأحداث typed هنا.
      expect(events.whereType<CallUserMuteEvent>(), isEmpty);
    });

    test('unknown events fall through to UnknownWebSocketEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"some_new_event","data":{"a":1}}',
      );
      await _settle();

      final unknown = events.whereType<UnknownWebSocketEvent>();
      expect(unknown, hasLength(1));
      expect(unknown.first.rawEventName, 'some_new_event');
    });
  });
}
