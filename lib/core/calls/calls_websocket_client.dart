import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:msgpack_dart/msgpack_dart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// بادئة أحداث إضافة المكالمات (custom_com.mattermost.calls_*).
const String callsEventPrefix = 'custom_com.mattermost.calls_';

enum CallsWebSocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// الأحداث الواردة من اتصال المكالمات (`?calls=true`).
///
/// هذا الاتصال منفصل تماماً عن الـ Hub الرئيسي: عليه تأتي رسائل المصادقة
/// و hello وإشارات WebRTC فقط — بينما أحداث حالة المكالمة
/// (call_start/user_joined/user_muted/...) تصل على الـ Hub الرئيسي.
sealed class CallsWebSocketEvent {
  const CallsWebSocketEvent();
}

/// اكتملت الجلسة بعد `hello` — على المتصل اختيار `join` (أول اتصال) أو
/// الاعتماد على إعادة الاتصال التلقائي (isReconnect = true).
class CallsWSSessionReadyEvent extends CallsWebSocketEvent {
  /// معرّف الجلسة الثابت للمستخدم (originalConnID) = session_id.
  final String sessionId;

  /// هل هذا اتصال بعد انقطاع (أُرسلت رسالة reconnect تلقائياً)؟
  final bool isReconnect;

  /// connID الجلسة السابقة (يُمرَّر للخادم كـ prevConnID عند إعادة الاتصال).
  final String prevSessionId;

  const CallsWSSessionReadyEvent({
    required this.sessionId,
    required this.isReconnect,
    required this.prevSessionId,
  });
}

/// إقرار الخادم بقبول `join` (event: custom_com.mattermost.calls_join).
class CallsWSJoinedEvent extends CallsWebSocketEvent {
  /// connID الممنوح من الخادم (يساوي sessionId عادة).
  final String sessionId;

  const CallsWSJoinedEvent({required this.sessionId});
}

/// إشارة WebRTC واردة (event: custom_com.mattermost.calls_signal).
/// [data] هو حمولة الإشارة المُحلَّلة: `{type: offer|answer|candidate, ...}`.
/// [sessionId] هو `connID` المصاحب للرسالة — بحسب الخادم (v1.x) هو معرّف
/// الجلسة المعنية نفسها (المتلقي) وليس المرسل.
class CallsWSSignalEvent extends CallsWebSocketEvent {
  final Map<String, dynamic> data;
  final String sessionId;

  const CallsWSSignalEvent({required this.data, required this.sessionId});
}

/// خطأ من الخادم (event: custom_com.mattermost.calls_error) أو فشل مصادقة.
class CallsWSErrorEvent extends CallsWebSocketEvent {
  final String message;

  const CallsWSErrorEvent({required this.message});
}

/// حالة المكالمة المطلوبة عبر `call_state` (event: custom_com.mattermost.calls_call_state).
class CallsWSCallStateEvent extends CallsWebSocketEvent {
  final String channelId;

  /// JSON `call` المرسل نصاً من الخادم — `null` عند عدم وجود مكالمة.
  final Map<String, dynamic>? call;

  const CallsWSCallStateEvent({required this.channelId, this.call});
}

/// شكل الـ emoji المرسل مع إشارة `react` — مطابق `EmojiData` في calls-common.
class CallsEmoji {
  final String name;
  final String unified;
  final String skin;
  final String literal;

  const CallsEmoji({
    required this.name,
    this.unified = '',
    this.skin = '',
    this.literal = '',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'unified': unified,
    'skin': skin,
    'literal': literal,
  };
}

/// اتصال WebSocket مخصص للمكالمات (`?calls=true`) — المرحلة 1 من خطة
/// إصلاح بروتوكول المكالمات.
///
/// البروتوكول المعتمد (v1.x — مُستخرج من كود الخادم المصدري):
/// - URL: `.../websocket?calls=true&connection_id=<connId>&sequence_number=<seq>`
/// - المصادقة عبر `authentication_challenge` ثم استقبال `hello`.
/// - الرسائل الصادرة نص JSON:
///   `{"action": "custom_com.mattermost.calls_<type>", "seq": N, "data": {...}}`
/// - رسالة `sdp` فقط تُرسل كإطار ثنائي msgpack مع حمولة مضغوطة zlib:
///   `{"seq", "action": calls_sdp, "data": {"data": zlib(json({type, sdp}))}}`
///   (الخادم لا يقبل sdp نصياً — يطلب `data` من نوع []byte).
/// - أحداث واردة نص JSON قياسية: hello / calls_join / calls_signal /
///   calls_error / calls_call_state.
@lazySingleton
class CallsWebSocketClient {
  final SecureStorageService _secureStorage;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;

  /// connID الحالي (من رسالة hello) — يُمرَّر في الـ query عند إعادة الاتصال.
  String _connId = '';

  /// أول connID استُلم — يبقى ثابتاً ويعرّف هوية المستخدم (sessionID).
  String _originalConnId = '';

  /// آخر connID قبل إعادة الاتصال الحالية (prevConnID لرسالة reconnect).
  String _prevConnId = '';

  /// آخر seq مستلم من الخادم + 1 — يُمرَّر في `sequence_number` عند إعادة
  /// الاتصال لاسترجاع الأحداث المفقودة.
  int _serverSeq = 0;

  /// عداد الرسائل الصادرة (يبدأ من 1 مطابقاً عميل الموبايل seqNo=1).
  int _outgoingSeq = 1;

  /// آخر ping أرسلناه — للتأكد من عودة pong (القناة حية).
  int _lastPingSeq = 0;
  bool _waitingForPong = false;

  /// القناة النشطة داخل مكالمة — تُحفظ لإعادة الاتصال تلقائياً (reconnect).
  String? _activeChannelId;

  /// هل الاتصال الحالي محاولة إعادة اتصال بعد انقطاع؟
  bool _isReconnect = false;

  /// أُغلق يدوياً عبر [disconnect] — لا تُعاد المحاولة.
  bool _closed = false;

  CallsWebSocketStatus _status = CallsWebSocketStatus.disconnected;
  CallsWebSocketStatus get status => _status;

  final _eventController = StreamController<CallsWebSocketEvent>.broadcast();
  final _statusController = StreamController<CallsWebSocketStatus>.broadcast();

  Stream<CallsWebSocketEvent> get events => _eventController.stream;
  Stream<CallsWebSocketStatus> get statusStream => _statusController.stream;

  /// هوية الجلسة الثابتة (originalConnID) — تساوي session_id في أحداث
  /// user_joined/user_muted/... لتمييز الذات عن الآخرين.
  String? get sessionId => _originalConnId.isEmpty ? null : _originalConnId;

  /// القناة النشطة حالياً (اختياري — null قبل أول join).
  String? get activeChannelId => _activeChannelId;

  CallsWebSocketClient(this._secureStorage);

  Future<void> connect() async {
    if (_closed ||
        _status == CallsWebSocketStatus.connecting ||
        _status == CallsWebSocketStatus.connected) {
      return;
    }

    _updateStatus(CallsWebSocketStatus.connecting);

    // إعادة الاتصال: نحتفظ بـ connId الجلسة السابقة لنمرّرها prevConnID،
    // ونعلم أن الرد التالي على hello هو إعادة اتصال وليس جلسة جديدة.
    _isReconnect = _connId.isNotEmpty;
    _prevConnId = _connId;

    final token = await _secureStorage.getAuthToken();

    try {
      final uri = Uri.parse(AppConfig.defaultWebSocketUrl).replace(
        queryParameters: {
          'calls': 'true',
          'connection_id': _connId,
          'sequence_number': '$_serverSeq',
        },
      );

      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;

      _subscription = _channel!.stream.listen(
        (message) => _onMessageReceived(message),
        onError: (error) => _handleDisconnectAndReconnect(),
        onDone: () => _handleDisconnectAndReconnect(),
      );

      _reconnectAttempts = 0;
      _waitingForPong = false;
      _updateStatus(CallsWebSocketStatus.connected);
      _startHeartbeat();

      if (token != null && token.isNotEmpty) {
        _authenticate(token);
      }
    } catch (e) {
      _handleDisconnectAndReconnect();
    }
  }

  /// يقطع الاتصال نهائياً — يوقف إعادة الاتصال التلقائية.
  void disconnect() {
    _closed = true;
    _onDisconnected();
    _channel?.sink.close();
  }

  /// يقطع مؤقتاً (بدون إيقاف إعادة الاتصال) — يصلح عند مغادرة مكالمة.
  /// يُصفّر حالة الجلسة (connID/seq) ليكون الاتصال التالي جلسة أولى نظيفة.
  void closeForLeave() {
    _activeChannelId = null;
    _connId = '';
    _originalConnId = '';
    _isReconnect = false;
    _serverSeq = 0;
    _outgoingSeq = 1;
    _onDisconnected();
    _channel?.sink.close();
  }

  // ── إرسال الإشارات (outgoing) ────────────────────────────────

  /// الانضمام إلى مكالمة قناة — يُرسل مباشرة بعد `hello` لأول اتصال.
  void joinCall(
    String channelId, {
    String? title,
    String? threadId,
    bool av1Support = false,
    bool dcSignaling = false,
  }) {
    _activeChannelId = channelId;
    sendSignal('join', {
      'channelID': channelId,
      'title': title ?? '',
      'threadID': threadId ?? '',
      'av1Support': av1Support,
      'dcSignaling': dcSignaling,
    });
  }

  /// إعادة الانضمام بعد انقطاع — تُرسل تلقائياً من العميل عند إعادة الاتصال
  /// (مطابق عميل الموبايل: open + hello → reconnect {channelID, originalConnID, prevConnID}).
  void _sendReconnect(String channelId) {
    sendSignal('reconnect', {
      'channelID': channelId,
      'originalConnID': _originalConnId,
      'prevConnID': _prevConnId,
    });
  }

  /// مغادرة المكالمة — بعدها لا يعيد العميل الاتصال تلقائياً.
  void leaveCall() {
    _activeChannelId = null;
    sendSignal('leave', {});
  }

  void sendMute() => sendSignal('mute', {});
  void sendUnmute() => sendSignal('unmute', {});
  void sendRaiseHand() => sendSignal('raise_hand', {});
  void sendUnraiseHand() => sendSignal('unraise_hand', {});

  /// يرسل تفاعل — `data` نص JSON للـ emoji (مطابق عميل الموبايل).
  void sendReact(CallsEmoji emoji) {
    sendSignal('react', {'data': jsonEncode(emoji.toJson())});
  }

  /// يرسل مرشّح ICE — `data` نص JSON (الحقول candidate/sdpMid/sdpMLineIndex).
  void sendIce(Map<String, dynamic> candidate) {
    sendSignal('ice', {'data': jsonEncode(candidate)});
  }

  /// يرسل عرض/إجابة SDP — يضغط zlib ويغلّفه msgpack في إطار ثنائي
  /// (الخادم يرفض sdp نصياً). [sdpPayload] = `{type, sdp}`.
  void sendSdp(Map<String, dynamic> sdpPayload) {
    final frame = buildSdpFrame(_outgoingSeq++, sdpPayload);
    if (_channel != null && _status == CallsWebSocketStatus.connected) {
      _channel!.sink.add(frame);
    }
  }

  /// يطلب حالة المكالمة الحالية من الخادم (على اتصال المكالمات).
  void requestCallState(String channelId) {
    sendSignal('call_state', {'channelID': channelId});
  }

  /// يرسل إشارة عامة `custom_com.mattermost.calls_<action>` بنص JSON.
  void sendSignal(String action, Map<String, dynamic> data) {
    sendJson({
      'action': '$callsEventPrefix$action',
      'seq': _outgoingSeq++,
      'data': data,
    });
  }

  void sendJson(Map<String, dynamic> jsonMap) {
    if (_channel != null && _status == CallsWebSocketStatus.connected) {
      _channel!.sink.add(jsonEncode(jsonMap));
    }
  }

  // ── المعالجة الداخلية ────────────────────────────────────────

  void _authenticate(String token) {
    sendJson({
      'seq': _outgoingSeq++,
      'action': 'authentication_challenge',
      'data': {'token': token},
    });
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(AppConfig.webSocketPingInterval, (_) {
      if (_status != CallsWebSocketStatus.connected) return;
      if (_waitingForPong) {
        _handleDisconnectAndReconnect();
        return;
      }
      _waitingForPong = true;
      _lastPingSeq = _outgoingSeq++;
      sendJson({'seq': _lastPingSeq, 'action': 'ping'});
    });
  }

  void _onMessageReceived(dynamic rawData) {
    try {
      final decoded = jsonDecode(rawData as String) as Map<String, dynamic>;

      // استجابة لطلب أرسلناه (authentication_challenge/ping) — بلا event.
      if (decoded.containsKey('seq_reply')) {
        _handleResponse(decoded);
        return;
      }

      if (decoded['seq'] is int) {
        _serverSeq = (decoded['seq'] as int) + 1;
      }

      final eventName = decoded['event'] as String?;
      if (eventName == null) return;

      final data = (decoded['data'] as Map<String, dynamic>?) ?? {};

      if (eventName == 'hello') {
        _handleHello(data);
        return;
      }

      // تجاهل الرسائل القادمة من جلسات أخرى قبل اكتمال hello.
      if (_connId.isEmpty) return;

      // مطابق عميل الموبايل (websocket_client.ts): الرسائل المعنية تحمل connID
      // في البيانات — نقبل فقط ما يخص الجلسة الحالية أو الجلسة الأصلية.
      // (رسالة calls_call_state لا تحمل connID — موجَّهة لهذا الاتصال فقط).
      final msgConnId = data['connID'] as String?;
      if (msgConnId != null &&
          msgConnId != _connId &&
          msgConnId != _originalConnId) {
        return;
      }

      switch (eventName) {
        case '${callsEventPrefix}join':
          _eventController.add(
            CallsWSJoinedEvent(sessionId: data['connID'] as String? ?? ''),
          );
          break;
        case '${callsEventPrefix}error':
          _eventController.add(
            CallsWSErrorEvent(
              message: data['data'] as String? ?? 'calls websocket error',
            ),
          );
          break;
        case '${callsEventPrefix}signal':
          final rawSignal = data['data'] as String?;
          if (rawSignal != null && rawSignal.isNotEmpty) {
            final signal = jsonDecode(rawSignal) as Map<String, dynamic>;
            _eventController.add(
              CallsWSSignalEvent(
                data: signal,
                sessionId: data['connID'] as String? ?? '',
              ),
            );
          }
          break;
        case '${callsEventPrefix}call_state':
          final callRaw = data['call'] as String?;
          Map<String, dynamic>? call;
          if (callRaw != null && callRaw.isNotEmpty) {
            call = jsonDecode(callRaw) as Map<String, dynamic>;
          }
          _eventController.add(
            CallsWSCallStateEvent(
              channelId: data['channel_id'] as String? ?? '',
              call: call,
            ),
          );
          break;
      }
    } catch (e, st) {
      debugPrint('[calls-ws] error processing message: $e\n$st');
    }
  }

  void _handleHello(Map<String, dynamic> data) {
    final newConnId = data['connection_id'] as String? ?? '';

    if (newConnId.isNotEmpty && newConnId != _connId) {
      _connId = newConnId;
      _serverSeq = 0;
      if (_originalConnId.isEmpty) {
        _originalConnId = _connId;
      }
    }

    _eventController.add(
      CallsWSSessionReadyEvent(
        sessionId: _originalConnId,
        isReconnect: _isReconnect,
        prevSessionId: _prevConnId,
      ),
    );

    // إعادة الاتصال: نعيد الانضمام للقناة النشطة تلقائياً (مطابق الموبايل).
    if (_isReconnect &&
        _activeChannelId != null &&
        _originalConnId.isNotEmpty) {
      _sendReconnect(_activeChannelId!);
    }
  }

  void _handleResponse(Map<String, dynamic> decoded) {
    final status = decoded['status'] as String?;
    final seqReply = decoded['seq_reply'] as int? ?? 0;
    final data = (decoded['data'] as Map<String, dynamic>?) ?? {};

    if (seqReply == _lastPingSeq && status == 'OK') {
      _waitingForPong = false;
    }

    if (status == 'FAIL') {
      _eventController.add(
        CallsWSErrorEvent(
          message: data['error'] as String? ?? 'calls websocket auth failed',
        ),
      );
    }
  }

  void _handleDisconnectAndReconnect() {
    _onDisconnected();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_closed) return;
    _reconnectAttempts++;
    if (_reconnectAttempts > AppConfig.maxWebSocketReconnectAttempts) {
      debugPrint(
        '[calls-ws] max reconnect attempts reached ($_reconnectAttempts)',
      );
      _updateStatus(CallsWebSocketStatus.error);
      return;
    }
    _updateStatus(CallsWebSocketStatus.reconnecting);
    final delayMs =
        (500 * pow(2, min(_reconnectAttempts, 5))).toInt() +
        Random().nextInt(200);
    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () {
      if (_status == CallsWebSocketStatus.reconnecting && !_closed) {
        connect();
      }
    });
  }

  void _onDisconnected() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _outgoingSeq = 1;
    _waitingForPong = false;
    _updateStatus(CallsWebSocketStatus.disconnected);
  }

  /// يمرر رسالة JSON واردة للمعالجة — يستخدم في الاختبارات لحقن أحداث.
  @visibleForTesting
  void handleIncomingMessage(String rawData) => _onMessageReceived(rawData);

  /// يبني إطار SDP الثنائي: msgpack `{seq, action: calls_sdp, data: {data: <zlib>}}`
  /// — الحمولة المضغوطة JSON `{type, sdp}` (الخادم يفككها عبر unpackSDPData).
  @visibleForTesting
  static Uint8List buildSdpFrame(int seq, Map<String, dynamic> sdpPayload) {
    final payloadJson = utf8.encode(jsonEncode(sdpPayload));
    final compressed = Uint8List.fromList(ZLibCodec().encode(payloadJson));
    return serialize({
      'seq': seq,
      'action': '${callsEventPrefix}sdp',
      'data': {'data': compressed},
    });
  }

  void _updateStatus(CallsWebSocketStatus newStatus) {
    _status = newStatus;
    if (!_statusController.isClosed) {
      _statusController.add(_status);
    }
  }

  void dispose() {
    disconnect();
    _eventController.close();
    _statusController.close();
  }
}
