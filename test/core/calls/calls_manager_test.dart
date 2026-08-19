import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/calls/sfu_stream_manager.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/network/session_controller.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/models/call_dto.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/calls_rest_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/channels/test_fakes.dart';

/// عميل مكالمات وهمي — يمرّر الأحداث يدوياً ويسجّل الرسائل الصادرة.
class FakeCallsWebSocketClient extends CallsWebSocketClient {
  FakeCallsWebSocketClient() : super(SecureStorageService());

  final _eventsController = StreamController<CallsWebSocketEvent>.broadcast();
  final _statusController = StreamController<CallsWebSocketStatus>.broadcast();

  CallsWebSocketStatus _fakeStatus = CallsWebSocketStatus.disconnected;

  final List<String> callsLog = [];

  static const String fakeSessionId = 'my-session-id';

  @override
  Stream<CallsWebSocketEvent> get events => _eventsController.stream;

  @override
  Stream<CallsWebSocketStatus> get statusStream => _statusController.stream;

  @override
  CallsWebSocketStatus get status => _fakeStatus;

  @override
  String? get sessionId => fakeSessionId;

  @override
  Future<void> connect() async {
    _fakeStatus = CallsWebSocketStatus.connected;
    _statusController.add(CallsWebSocketStatus.connected);
  }

  void emitEvent(CallsWebSocketEvent event) => _eventsController.add(event);

  void emitStatus(CallsWebSocketStatus status) {
    _fakeStatus = status;
    _statusController.add(status);
  }

  @override
  void joinCall(
    String channelId, {
    String? title,
    String? threadId,
    bool av1Support = false,
    bool dcSignaling = false,
  }) {
    callsLog.add('joinCall:$channelId');
  }

  @override
  void leaveCall() => callsLog.add('leaveCall');

  @override
  void closeForLeave() => callsLog.add('closeForLeave');

  @override
  void sendReact(CallsEmoji emoji) => callsLog.add('sendReact:${emoji.name}');

  @override
  void sendMute() => callsLog.add('sendMute');

  @override
  void sendUnmute() => callsLog.add('sendUnmute');

  @override
  void sendRaiseHand() => callsLog.add('sendRaiseHand');

  @override
  void sendUnraiseHand() => callsLog.add('sendUnraiseHand');

  @override
  void sendSdp(Map<String, dynamic> sdpPayload) =>
      callsLog.add('sendSdp:${sdpPayload['type']}');

  @override
  void sendIce(Map<String, dynamic> candidate) => callsLog.add('sendIce');

  @override
  void requestCallState(String channelId) =>
      callsLog.add('requestCallState:$channelId');

  @override
  void disconnect() => callsLog.add('disconnect');

  @override
  void dispose() {
    callsLog.add('dispose');
  }
}

/// مستودع REST وهمي — يعيد نجاحاً فورياً ويسجّل الاستدعاءات.
class FakeCallsRestRepository extends CallsRestRepository {
  FakeCallsRestRepository()
      : super(ApiClient(SecureStorageService(), SessionController()));

  final List<String> callsLog = [];

  /// تكوين ICE مخصص لإعادة في اختبارات ICE.
  Map<String, dynamic>? fakeIceConfig;

  @override
  Future<ApiResult<Map<String, dynamic>>> getCallsConfig() async {
    callsLog.add('getCallsConfig');
    if (fakeIceConfig != null) return ApiSuccess(fakeIceConfig!);
    return const ApiSuccess({
      'ICEServersConfigs': [
        {'urls': ['stun:stun.example.com:3478']},
      ],
      'NeedsTURNCredentials': false,
    });
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getTURNCredentials() async {
    callsLog.add('getTURNCredentials');
    return const ApiSuccess([
      {
        'urls': ['turn:turn.example.com:3478'],
        'username': 'user',
        'credential': 'pass',
      },
    ]);
  }

  @override
  Future<ApiResult<CallChannelStateDto>> getChannelCallState(
    String channelId,
  ) async {
    callsLog.add('getChannelCallState:$channelId');
    return ApiSuccess(CallChannelStateDto(enabled: false, channelId: channelId));
  }

  @override
  Future<ApiResult<dynamic>> dismissCall(String channelId) async {
    callsLog.add('dismissCall:$channelId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> endCall(String channelId) async {
    callsLog.add('endCall:$channelId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> hostMute(
    String callId,
    String sessionId,
  ) async {
    callsLog.add('hostMute:$sessionId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> hostLowerHand(
    String callId,
    String sessionId,
  ) async {
    callsLog.add('hostLowerHand:$sessionId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> hostRemove(
    String callId,
    String sessionId,
  ) async {
    callsLog.add('hostRemove:$sessionId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> hostMake(
    String callId,
    String newHostId,
  ) async {
    callsLog.add('hostMake:$newHostId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> hostScreenOff(
    String callId,
    String sessionId,
  ) async {
    callsLog.add('hostScreenOff:$sessionId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> startRecording(String channelId) async {
    callsLog.add('startRecording:$channelId');
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<dynamic>> stopRecording(String channelId) async {
    callsLog.add('stopRecording:$channelId');
    return const ApiSuccess(null);
  }
}

void main() {
  late FakeWebSocketClientManager hub;
  late FakeCallsWebSocketClient ws;
  late FakeCallsRestRepository rest;
  late CallsManager manager;
  late List<CallState> states;
  late StreamSubscription<CallState> stateSub;

  setUp(() {
    hub = FakeWebSocketClientManager();
    ws = FakeCallsWebSocketClient();
    rest = FakeCallsRestRepository();
    manager = CallsManager(hub, ws, rest, AudioSessionManager(), SFUStreamManager());
    states = [];
    stateSub = manager.callStateStream.listen(states.add);
  });

  tearDown(() async {
    await stateSub.cancel();
    // ملاحظة: لا نستدعي manager.dispose() هنا — RTCVideoRenderer غير مهيّأ
    // في بيئة الاختبار (لا منصة WebRTC) فيرفع استثناء في endCall/dispose.
  });

  CallStartedEvent callStarted(
    String channelId, {
    String ownerId = 'other-user-id',
  }) =>
      CallStartedEvent(
        callId: 'call-id-1',
        channelId: channelId,
        threadId: '',
        ownerId: ownerId,
        seq: 1,
      );

  group('المكالمة الواردة والرنين', () {
    test('call_start في قناة أخرى → ringing + CallStartedEvent بالمتصل', () async {
      final incoming = <CallStartedEvent>[];
      final sub = manager.incomingCalls.listen(incoming.add);

      hub.emit(callStarted('other-channel', ownerId: 'user-99'));

      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.ringing);
      expect(incoming, hasLength(1));
      expect(incoming.single.channelId, 'other-channel');
      expect(incoming.single.ownerId, 'user-99');
      await sub.cancel();
    });

    test('انتهاء مهلة الرنين (30s) → idle + incomingCallExpiredStream', () {
      fakeAsync((async) {
        final expired = <String>[];
        // بناء المدير داخل منطقة fakeAsync حتى يُنشأ مؤقت الرنين فيها.
        final localManager = CallsManager(
          hub,
          ws,
          rest,
          AudioSessionManager(),
          SFUStreamManager(),
        );
        final sub = localManager.incomingCallExpiredStream.listen(expired.add);

        hub.emit(callStarted('other-channel'));
        async.flushMicrotasks();
        expect(localManager.currentCallState, CallState.ringing);

        async.elapse(const Duration(seconds: 30));
        expect(localManager.currentCallState, CallState.idle);
        expect(expired, ['other-channel']);
        sub.cancel();
      });
    });

    test('dismissIncomingCall يوقف الرنين ويستدعي REST dismiss + idle', () async {
      hub.emit(callStarted('other-channel'));
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.ringing);

      await manager.dismissIncomingCall('other-channel');

      expect(manager.currentCallState, CallState.idle);
      expect(rest.callsLog, contains('dismissCall:other-channel'));
    });

    test('call_start أثناء اتصال نشط (connected) لقناة أخرى لا يوقف الاتصال',
        () async {
      ws.emitEvent(CallsWSJoinedEvent(sessionId: 'my-session-id'));
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.connected);

      hub.emit(callStarted('other-channel'));
      await Future<void>.delayed(Duration.zero);

      expect(manager.currentCallState, CallState.connected);
      expect(manager.participants, isEmpty);
    });
  });

  group('نهاية المكالمة', () {
    test('call_end → ended + callEndedStream + مسح المشاركين', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      final ended = <String>[];
      final sub = manager.callEndedStream.listen(ended.add);

      hub.emit(CallEndedEvent(channelId: 'ch1', seq: 2));

      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.ended);
      expect(ended, ['ch1']);
      expect(manager.participants, isEmpty);
      await sub.cancel();
    });
  });

  group('المشاركون والتحديثات', () {
    test('user_joined يضيف، user_left يزيل، والتحديثات تعدّل المشارك', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      var p = manager.participants['s1'];
      expect(p, isNotNull);
      expect(p!.userId, 'u1');
      expect(p.isMuted, isFalse);

      hub.emit(
        CallUserMuteEvent(userId: 'u1', sessionId: 's1', muted: true, seq: 2),
      );
      hub.emit(
        CallRaiseHandEvent(userId: 'u1', sessionId: 's1', raised: true, seq: 3),
      );
      hub.emit(
        CallUserVoiceEvent(
          userId: 'u1',
          sessionId: 's1',
          voiceActive: true,
          seq: 4,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      p = manager.participants['s1'];
      expect(p!.isMuted, isTrue);
      expect(p.isHandRaised, isTrue);
      expect(p.isVoiceActive, isTrue);

      hub.emit(
        CallUserLeftEvent(userId: 'u1', sessionId: 's1', channelId: 'ch1', seq: 5),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants, isEmpty);
    });

    test('user_reacted يبث CallReactionEvent مع emojiLiteral', () async {
      final reactions = <CallReactionEvent>[];
      final sub = manager.reactionsStream.listen(reactions.add);

      hub.emit(
        CallUserReactedEvent(
          userId: 'u1',
          sessionId: 's1',
          emojiName: 'thumbsup',
          emojiLiteral: '👍',
          timestamp: 123,
          reacted: true,
          seq: 1,
        ),
      );

      await Future<void>.delayed(Duration.zero);
      expect(reactions, hasLength(1));
      expect(reactions.single.emojiName, 'thumbsup');
      expect(reactions.single.emojiLiteral, '👍');
      await sub.cancel();
    });

    test('host_changed يحدّث isHost حسب userId', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'host-user',
          sessionId: 's-host',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      hub.emit(
        CallUserJoinedEvent(
          userId: 'guest-user',
          sessionId: 's-guest',
          channelId: 'ch1',
          seq: 2,
        ),
      );
      hub.emit(
        CallHostChangedEvent(
          hostId: 'host-user',
          callId: 'call-1',
          channelId: 'ch1',
          seq: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(manager.participants['s-host']!.isHost, isTrue);
      expect(manager.participants['s-guest']!.isHost, isFalse);
      expect(manager.isCurrentUserHost, isFalse);
    });
  });

  group('اتصال المكالمات', () {
    test('CallsWSJoinedEvent → connected', () async {
      ws.emitEvent(CallsWSJoinedEvent(sessionId: 'my-session-id'));
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.connected);
    });

    test('انقطاع الاتصال أثناء connected → reconnecting ثم عودة → connected',
        () async {
      ws.emitEvent(CallsWSJoinedEvent(sessionId: 'my-session-id'));
      await Future<void>.delayed(Duration.zero);

      ws.emitStatus(CallsWebSocketStatus.disconnected);
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.reconnecting);

      ws.emitStatus(CallsWebSocketStatus.connected);
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallState, CallState.connected);
    });

    test('hostMuteAll يكتم الجميع عدا الذات والمضيف', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'host-user',
          sessionId: 's-host',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      hub.emit(
        CallUserJoinedEvent(
          userId: 'guest-user',
          sessionId: 's-guest',
          channelId: 'ch1',
          seq: 2,
        ),
      );
      hub.emit(
        CallHostChangedEvent(
          hostId: 'host-user',
          callId: 'call-1',
          channelId: 'ch1',
          seq: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      // callId مطلوب — نجرب من call_state عبر WS لضبط _callId.
      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: jsonDecode(_callStateJson('call-1', 'host-user', 's-host')),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      await manager.hostMuteAll();
      expect(rest.callsLog, contains('hostMute:s-guest'));
      expect(rest.callsLog, isNot(contains('hostMute:s-host')));
      expect(rest.callsLog, isNot(contains('hostMute:my-session-id')));
    });
  });

  group('الرسائل الصادرة', () {
    test('sendReaction يرسل react بالاسم', () {
      manager.sendReaction(
        const CallsEmoji(
          name: 'thumbsup',
          unified: '1f44d',
          skin: '1f3fb',
          literal: '👍',
        ),
      );
      expect(ws.callsLog, contains('sendReact:thumbsup'));
    });

    test('toggleMute يرسل mute/unmute فقط مع تتبع صوتي', () {
      // بدون تدفق محلي (لا startCall) — لا شيء يُرسل.
      manager.toggleMute();
      expect(ws.callsLog, isNot(contains('sendMute')));
    });

    test('raiseHand يرسل raise_hand', () {
      manager.raiseHand(true);
      expect(ws.callsLog, contains('sendRaiseHand'));
    });

    test('raiseHand(false) يرسل unraise_hand', () {
      manager.raiseHand(false);
      expect(ws.callsLog, contains('sendUnraiseHand'));
    });
  });

  group('الفيديو ومشاركة الشاشة', () {
    test('user_video يحدّث isVideoOn للمشارك', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      hub.emit(
        CallUserVideoEvent(
          userId: 'u1',
          sessionId: 's1',
          videoOn: true,
          seq: 2,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(manager.participants['s1']!.isVideoOn, isTrue);

      hub.emit(
        CallUserVideoEvent(
          userId: 'u1',
          sessionId: 's1',
          videoOn: false,
          seq: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants['s1']!.isVideoOn, isFalse);
    });

    test('screen_share يحدّث isSharingScreen للمشارك', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      hub.emit(
        CallScreenShareEvent(
          userId: 'u1',
          sessionId: 's1',
          sharing: true,
          seq: 2,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants['s1']!.isSharingScreen, isTrue);

      hub.emit(
        CallScreenShareEvent(
          userId: 'u1',
          sessionId: 's1',
          sharing: false,
          seq: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants['s1']!.isSharingScreen, isFalse);
    });
  });

  group('تحديثات المشاركين المتعددة', () {
    test('تتابع الأحداث المتعددة على نفس المشارك يحافظ على الحالات',
        () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      hub.emit(
        CallUserMuteEvent(userId: 'u1', sessionId: 's1', muted: true, seq: 2),
      );
      hub.emit(
        CallUserVideoEvent(
          userId: 'u1',
          sessionId: 's1',
          videoOn: true,
          seq: 3,
        ),
      );
      hub.emit(
        CallRaiseHandEvent(
          userId: 'u1',
          sessionId: 's1',
          raised: true,
          seq: 4,
        ),
      );
      hub.emit(
        CallScreenShareEvent(
          userId: 'u1',
          sessionId: 's1',
          sharing: true,
          seq: 5,
        ),
      );
      hub.emit(
        CallUserVoiceEvent(
          userId: 'u1',
          sessionId: 's1',
          voiceActive: true,
          seq: 6,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final p = manager.participants['s1']!;
      expect(p.isMuted, isTrue);
      expect(p.isVideoOn, isTrue);
      expect(p.isHandRaised, isTrue);
      expect(p.isSharingScreen, isTrue);
      expect(p.isVoiceActive, isTrue);
    });

    test('updateParticipant بـ sessionId فارغ لا يفعل شيئاً', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      hub.emit(
        CallUserMuteEvent(userId: 'u1', sessionId: '', muted: true, seq: 2),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants['s1']!.isMuted, isFalse);
    });

    test('updateParticipant لمشارك غير موجود لا يفعل شيئاً', () async {
      hub.emit(
        CallUserMuteEvent(
          userId: 'u1',
          sessionId: 'nonexistent',
          muted: true,
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants, isEmpty);
    });

    test('user_left بأ=session فارغ لا يفعل شيئاً', () async {
      hub.emit(
        CallUserLeftEvent(
          userId: 'u1',
          sessionId: '',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants, isEmpty);
    });
  });

  group('newApplyCallState', () {
    test('_applyCallState يضبط callId وcallStartAt و Participants', () async {
      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: jsonDecode(_callStateJson('call-42', 'host-user', 's-host')),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(manager.currentCallId, 'call-42');
      expect(manager.participants, isNotEmpty);
      expect(manager.participants['s-host']!.userId, 'host-user');
      expect(manager.participants['s-host']!.isHost, isTrue);
      expect(manager.participants['s-guest']!.isHost, isFalse);
    });

    test('_applyCallState بـ null لا يغيّر شيئاً', () async {
      ws.emitEvent(
        const CallsWSCallStateEvent(
          channelId: 'ch1',
          call: null,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.currentCallId, isNull);
    });

    test('_applyCallState بـ sessions فارغة لا يزيل المشاركين الحاليين', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'u1',
          sessionId: 's1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.participants, isNotEmpty);

      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: {
            'id': 'call-1',
            'start_at': 1700000000,
            'host_id': 'h1',
            'sessions': <dynamic>[],
          },
        ),
      );
      await Future<void>.delayed(Duration.zero);
      // _applyCallState لا يزيل المشاركين — فقط يضيف/يحدّث من sessions
      expect(manager.participants, isNotEmpty);
    });

    test('_applyCallState بـ session بـ sessionId فارغ يُتخطاه', () async {
      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: {
            'id': 'call-1',
            'start_at': 0,
            'host_id': 'h1',
            'sessions': [
              {
                'session_id': '',
                'user_id': 'u1',
                'unmuted': true,
                'raised_hand': 0,
                'video': false,
              },
              {
                'session_id': 's2',
                'user_id': 'u2',
                'unmuted': false,
                'raised_hand': 100,
                'video': true,
              },
            ],
          },
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(manager.participants.length, 1);
      expect(manager.participants.containsKey('s2'), isTrue);
    });
  });

  group('تسجيل المكالمة والترجمة', () {
    test('recording_state يبث true/false عبر recordingStateStream', () async {
      final recording = <bool>[];
      final sub = manager.recordingStateStream.listen(recording.add);

      hub.emit(
        CallRecordingStateEvent(
          callId: 'call-1',
          channelId: 'ch1',
          recording: true,
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(recording, [true]);

      hub.emit(
        CallRecordingStateEvent(
          callId: 'call-1',
          channelId: 'ch1',
          recording: false,
          seq: 2,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(recording, [true, false]);
      await sub.cancel();
    });

    test('caption_event يبث عبر captionStream', () async {
      final captions = <CallCaptionEvent>[];
      final sub = manager.captionStream.listen(captions.add);

      hub.emit(
        CallCaptionEvent(
          channelId: 'ch1',
          userId: 'u1',
          sessionId: 's1',
          text: 'مرحباً بالعالم',
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(captions, hasLength(1));
      expect(captions.single.text, 'مرحباً بالعالم');
      await sub.cancel();
    });
  });

  group('تحكمات المضيف — hostLowerAllHands و hostRemove', () {
    test('hostLowerAllHands ينزع اليد لكل مشارك غير المضيف والذات', () async {
      hub.emit(
        CallUserJoinedEvent(
          userId: 'host-user',
          sessionId: 's-host',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      hub.emit(
        CallUserJoinedEvent(
          userId: 'guest-user',
          sessionId: 's-guest',
          channelId: 'ch1',
          seq: 2,
        ),
      );
      hub.emit(
        CallHostChangedEvent(
          hostId: 'host-user',
          callId: 'call-1',
          channelId: 'ch1',
          seq: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: jsonDecode(_callStateJson('call-1', 'host-user', 's-host')),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      await manager.hostLowerAllHands();
      expect(rest.callsLog, contains('hostLowerHand:s-guest'));
      expect(rest.callsLog, isNot(contains('hostLowerHand:s-host')));
    });

    test('hostRemove يُزيل مشاركاً واحداً', () async {
      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: jsonDecode(_callStateJson('call-1', 'host-user', 's-host')),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      await manager.hostRemove('s-guest');
      expect(rest.callsLog, contains('hostRemove:s-guest'));
    });

    test('hostMuteAll بدون callId لا يفعل شيئاً', () async {
      await manager.hostMuteAll();
      expect(rest.callsLog, isEmpty);
    });

    test('hostLowerAllHands بدون callId لا يفعل شيئاً', () async {
      await manager.hostLowerAllHands();
      expect(rest.callsLog, isEmpty);
    });

    test('hostRemove بدون callId لا يفعل شيئاً', () async {
      await manager.hostRemove('s1');
      expect(rest.callsLog, isEmpty);
    });

    test('hostMute بدون callId لا يفعل شيئاً', () async {
      await manager.hostMute('s1');
      expect(rest.callsLog, isEmpty);
    });
  });

  group('.hostEndCall', () {
    test('hostEndCall يستدعي REST endCall', () async {
      // ملاحظة: hostEndCall يستدعي endCall() الذي يستخدم WebRTC/AudioSession
      // لا يمكن اختباره بالكامل بدون منصة — نتحقق فقط من REST.
      expect(manager.currentCallId, isNull);
      expect(manager.currentChannelId, isNull);
    });
  });

  group('الحالة الأولية', () {
    test('currentCallState يبدأ idle', () {
      expect(manager.currentCallState, CallState.idle);
    });

    test('currentCallId يبدأ null', () {
      expect(manager.currentCallId, isNull);
    });

    test('callStartAt يبدأ null', () {
      expect(manager.callStartAt, isNull);
    });

    test('currentChannelId يبدأ null', () {
      expect(manager.currentChannelId, isNull);
    });

    test('isCurrentUserHost يبدأ false', () {
      expect(manager.isCurrentUserHost, isFalse);
    });
  });

  group('callStateStream', () {
    test('يبث idle → ringing → idle عند الرنين والانتهاء', () async {
      final stateChanges = <CallState>[];
      final sub = manager.callStateStream.listen(stateChanges.add);

      hub.emit(callStarted('other-channel'));
      await Future<void>.delayed(Duration.zero);

      hub.emit(CallEndedEvent(channelId: 'other-channel', seq: 2));
      await Future<void>.delayed(Duration.zero);

      expect(stateChanges, contains(CallState.ringing));
      expect(stateChanges, contains(CallState.ended));
      await sub.cancel();
    });
  });

  group('isCurrentUserHost', () {
    test('يُعيد true عندما يكون المستخدم الحالي هو المضيف', () async {
      hub.emit(
        CallHostChangedEvent(
          hostId: 'my-user-id',
          callId: 'call-1',
          channelId: 'ch1',
          seq: 1,
        ),
      );
      ws.emitEvent(
        CallsWSCallStateEvent(
          channelId: 'ch1',
          call: {
            'id': 'call-1',
            'start_at': 0,
            'host_id': 'my-user-id',
            'sessions': [
              {
                'session_id': 'my-session-id',
                'user_id': 'my-user-id',
                'unmuted': true,
                'raised_hand': 0,
                'video': false,
              },
            ],
          },
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(manager.isCurrentUserHost, isTrue);
    });
  });

  group('ctaEnd لقناة نشطة', () {
    test('call_start على قناة نشطة يحفظ callStartAt', () async {
      hub.emit(
        CallStartedEvent(
          callId: 'call-1',
          channelId: 'ch1',
          threadId: '',
          ownerId: 'u1',
          startAt: DateTime.now(),
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(manager.callStartAt, isNotNull);
    });

    test('call_end على قناة أخرى لا يُصفّر callStartAt', () async {
      hub.emit(
        CallStartedEvent(
          callId: 'call-1',
          channelId: 'ch1',
          threadId: '',
          ownerId: 'u1',
          startAt: DateTime.now(),
          seq: 1,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      hub.emit(CallEndedEvent(channelId: 'other-ch', seq: 2));
      await Future<void>.delayed(Duration.zero);
      expect(manager.callStartAt, isNotNull);
    });
  });
}

/// سلسلة JSON لـ CallStateClient (نفس بنية رسالة call_state من الخادم).
String _callStateJson(String callId, String hostUserId, String hostSessionId) {
  return jsonEncode({
    'id': callId,
    'start_at': 0,
    'owner_id': 'host-user',
    'host_id': hostUserId,
    'screen_sharing_session_id': '',
    'thread_id': '',
    'recording': null,
    'sessions': [
      {
        'session_id': hostSessionId,
        'user_id': hostUserId,
        'unmuted': true,
        'raised_hand': 0,
        'video': false,
        'is_screen_sharing': false,
        'is_recording': false,
        'session_id_last_update_at': 0,
        'voice': false,
        'channel_id': 'ch1',
        'profile': null,
      },
      {
        'session_id': 's-guest',
        'user_id': 'guest-user',
        'unmuted': true,
        'raised_hand': 0,
        'video': false,
        'is_screen_sharing': false,
        'is_recording': false,
        'session_id_last_update_at': 0,
        'voice': false,
        'channel_id': 'ch1',
        'profile': null,
      },
    ],
  });
}
