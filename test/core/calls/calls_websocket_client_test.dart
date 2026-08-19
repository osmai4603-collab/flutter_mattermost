import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 30));

void main() {
  late CallsWebSocketClient client;
  late List<CallsWebSocketEvent> events;
  late List<CallsWebSocketStatus> statuses;

  setUp(() {
    client = CallsWebSocketClient(SecureStorageService());
    events = [];
    statuses = [];
    client.events.listen(events.add);
    client.statusStream.listen(statuses.add);
  });

  tearDown(() {
    client.dispose();
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
      },
    };
  }

  group('CallsWebSocketClient parsing', () {
    test('hello emits SessionReady with stable sessionId', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage(connectionId: 'conn-a')));
      await _settle();

      final ready = events.whereType<CallsWSSessionReadyEvent>();
      expect(ready, hasLength(1));
      expect(ready.first.sessionId, 'conn-a');
      expect(ready.first.isReconnect, isFalse);
      expect(client.sessionId, 'conn-a');
      expect(statuses, isEmpty);
    });

    test('sessionId stays stable when connection_id changes (reconnect)', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage(connectionId: 'conn-a')));
      await _settle();
      client.handleIncomingMessage(jsonEncode(helloMessage(connectionId: 'conn-b')));
      await _settle();

      final ready = events.whereType<CallsWSSessionReadyEvent>();
      expect(ready, hasLength(2));
      // هوية الجلسة تبقى على أول connID.
      expect(client.sessionId, 'conn-a');
      expect(ready.last.isReconnect, isFalse);
    });

    test('calls_join ack emits CallsWSJoinedEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_join","data":{"connID":"conn-1"}}',
      );
      await _settle();

      final joined = events.whereType<CallsWSJoinedEvent>();
      expect(joined, hasLength(1));
      expect(joined.first.sessionId, 'conn-1');
    });

    test('calls_signal with JSON string data emits CallsWSSignalEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      final signalData = jsonEncode({
        'type': 'offer',
        'sdp': 'v=0\r\nm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
      });
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"data":${jsonEncode(signalData)},"connID":"conn-1"}}',
      );
      await _settle();

      final signals = events.whereType<CallsWSSignalEvent>();
      expect(signals, hasLength(1));
      expect(signals.first.data['type'], 'offer');
      expect(signals.first.data['sdp'], contains('m=audio'));
      // الخادم (v1) يضع connID الجلسة المعنية (المتلقي) وليس المرسل.
      expect(signals.first.sessionId, 'conn-1');
    });

    test('calls_signal with candidate emits CallsWSSignalEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      final signalData = jsonEncode({
        'type': 'candidate',
        'candidate': 'candidate:1 1 udp 2122260223 10.0.0.1 58367 typ host',
        'sdpMid': '0',
        'sdpMLineIndex': 0,
      });
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"data":${jsonEncode(signalData)},"connID":"conn-1"}}',
      );
      await _settle();

      final signals = events.whereType<CallsWSSignalEvent>();
      expect(signals, hasLength(1));
      expect(signals.first.data['type'], 'candidate');
      expect(signals.first.data['sdpMid'], '0');
    });

    test('calls_signal with foreign connID is dropped (connID filter)', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      final signalData = jsonEncode({'type': 'offer', 'sdp': 'v=0'});
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"data":${jsonEncode(signalData)},"connID":"other-session"}}',
      );
      await _settle();

      expect(events.whereType<CallsWSSignalEvent>(), isEmpty);
    });

    test('calls_error emits CallsWSErrorEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_error",'
        '"data":{"data":"no call ongoing","connID":"conn-1"}}',
      );
      await _settle();

      final errors = events.whereType<CallsWSErrorEvent>();
      expect(errors, hasLength(1));
      expect(errors.first.message, contains('no call ongoing'));
    });

    test('calls_call_state emits CallsWSCallStateEvent with parsed call', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      final callJson = jsonEncode({'id': 'call-1', 'channel_id': 'c1', 'host_id': 'u1'});
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_state",'
        '"data":{"channel_id":"c1","call":${jsonEncode(callJson)}}}',
      );
      await _settle();

      final states = events.whereType<CallsWSCallStateEvent>();
      expect(states, hasLength(1));
      expect(states.first.channelId, 'c1');
      expect(states.first.call?['id'], 'call-1');
    });

    test('calls_call_state without call emits null call', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_state",'
        '"data":{"channel_id":"c1","call":""}}',
      );
      await _settle();

      final states = events.whereType<CallsWSCallStateEvent>();
      expect(states, hasLength(1));
      expect(states.first.call, isNull);
    });

    test('auth/ping OK response (seq_reply) emits nothing and no status change', () async {
      client.handleIncomingMessage(
        '{"status":"OK","data":{"text":"pong"},"seq_reply":2}',
      );
      await _settle();

      expect(events, isEmpty);
      expect(statuses, isEmpty);
    });

    test('auth FAIL response emits CallsWSErrorEvent', () async {
      client.handleIncomingMessage(
        '{"status":"FAIL","data":{"error":"invalid token"},"seq_reply":1}',
      );
      await _settle();

      final errors = events.whereType<CallsWSErrorEvent>();
      expect(errors, hasLength(1));
      expect(errors.first.message, contains('invalid token'));
    });

    test('messages before hello are ignored', () async {
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_join","data":{"connID":"x"}}',
      );
      await _settle();

      expect(events.whereType<CallsWSJoinedEvent>(), isEmpty);
    });

    test('unrelated events are ignored', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      await _settle();
      // hello أنتج حدث SessionReady واحداً — نتأكد ألا يضاف أي حدث آخر.
      final countAfterHello = events.length;
      client.handleIncomingMessage(
        '{"seq":1,"event":"posted","data":{"post":"{}"}}',
      );
      await _settle();

      expect(events.length, countAfterHello);
    });
  });

  group('SDP binary frame', () {
    test('buildSdpFrame encodes msgpack + zlib payload the server expects', () {
      final frame = CallsWebSocketClient.buildSdpFrame(5, {
        'type': 'offer',
        'sdp': 'v=0\r\nm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
      });

      final decoded = Map<dynamic, dynamic>.from(
        deserialize(frame) as Map<dynamic, dynamic>,
      );
      expect(decoded['seq'], 5);
      expect(decoded['action'], 'custom_com.mattermost.calls_sdp');

      final inner = Map<dynamic, dynamic>.from(decoded['data'] as Map);
      final compressed = inner['data'] as List<int>;
      final payload = jsonDecode(utf8.decode(ZLibCodec().decode(compressed)));
      expect(payload['type'], 'offer');
      expect(payload['sdp'], contains('m=audio'));
    });

    test('buildSdpFrame round-trips through the server zlib decompressor', () {
      final frame = CallsWebSocketClient.buildSdpFrame(1, {
        'type': 'answer',
        'sdp': 'v=0\r\nm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
      });

      final decoded = Map<dynamic, dynamic>.from(
        deserialize(frame) as Map<dynamic, dynamic>,
      );
      final inner = Map<dynamic, dynamic>.from(decoded['data'] as Map);
      final decompressed = ZLibCodec().decode(inner['data'] as List<int>);
      expect(jsonDecode(utf8.decode(decompressed))['type'], 'answer');
    });

    test('buildSdpFrame يدعم offer و answer بنفس البنية', () {
      for (final type in ['offer', 'answer']) {
        final frame = CallsWebSocketClient.buildSdpFrame(10, {
          'type': type,
          'sdp': 'v=0\r\nm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
        });

        final decoded = Map<dynamic, dynamic>.from(
          deserialize(frame) as Map<dynamic, dynamic>,
        );
        final inner = Map<dynamic, dynamic>.from(decoded['data'] as Map);
        final decompressed = ZLibCodec().decode(inner['data'] as List<int>);
        expect(jsonDecode(utf8.decode(decompressed))['type'], type);
      }
    });
  });

  group('calls_signal — answer type', () {
    test('calls_signal with answer emits CallsWSSignalEvent', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      final signalData = jsonEncode({
        'type': 'answer',
        'sdp': 'v=0\r\nm=video 9 UDP/TLS/RTP/SAVPF 96\r\n',
      });
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"data":${jsonEncode(signalData)},"connID":"conn-1"}}',
      );
      await _settle();

      final signals = events.whereType<CallsWSSignalEvent>();
      expect(signals, hasLength(1));
      expect(signals.first.data['type'], 'answer');
      expect(signals.first.data['sdp'], contains('m=video'));
      expect(signals.first.sessionId, 'conn-1');
    });

    test('calls_signal without data field is ignored', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"connID":"conn-1"}}',
      );
      await _settle();

      expect(events.whereType<CallsWSSignalEvent>(), isEmpty);
    });

    test('calls_signal with empty data string is ignored', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_signal",'
        '"data":{"data":"","connID":"conn-1"}}',
      );
      await _settle();

      expect(events.whereType<CallsWSSignalEvent>(), isEmpty);
    });
  });

  group('رسائل hello متعددة', () {
    test('عدة hello messages كلها تُصدر SessionReady', () async {
      client.handleIncomingMessage(
        jsonEncode(helloMessage(connectionId: 'c1', seq: 0)),
      );
      client.handleIncomingMessage(
        jsonEncode(helloMessage(connectionId: 'c2', seq: 1)),
      );
      client.handleIncomingMessage(
        jsonEncode(helloMessage(connectionId: 'c3', seq: 2)),
      );
      await _settle();

      final ready = events.whereType<CallsWSSessionReadyEvent>();
      expect(ready, hasLength(3));
    });
  });

  group('رسائل خاصة', () {
    test('hello مع serverVersion فارغ لا يسبب مشاكل', () async {
      client.handleIncomingMessage(
        '{"seq":0,"event":"hello","data":{"connection_id":"c1","server_version":""}}',
      );
      await _settle();

      final ready = events.whereType<CallsWSSessionReadyEvent>();
      expect(ready, hasLength(1));
      expect(client.sessionId, 'c1');
    });

    test('hello مع connection_id فارغ لا يضبط sessionId', () async {
      client.handleIncomingMessage(
        '{"seq":0,"event":"hello","data":{"connection_id":"","server_version":"1.0"}}',
      );
      await _settle();

      expect(client.sessionId, isNull);
    });

    test('calls_call_state مع call string فارغة يُصدر null call', () async {
      client.handleIncomingMessage(jsonEncode(helloMessage()));
      client.handleIncomingMessage(
        '{"seq":1,"event":"custom_com.mattermost.calls_call_state",'
        '"data":{"channel_id":"c1","call":""}}',
      );
      await _settle();

      final states = events.whereType<CallsWSCallStateEvent>();
      expect(states, hasLength(1));
      expect(states.first.call, isNull);
    });

    test('pong OK لا يُصدر أي event', () async {
      client.handleIncomingMessage(
        '{"status":"OK","data":{"text":"pong"},"seq_reply":100}',
      );
      await _settle();
      expect(events, isEmpty);
    });
  });
}
