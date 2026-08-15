import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';
import 'package:flutter_mattermost/core/calls/call_ringer.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/calls/sfu_stream_manager.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/chat/data/models/call_dto.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/calls_rest_repository.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:window_manager/window_manager.dart';

class CallParticipantState {
  final String sessionId;
  final String userId;
  final bool isMuted;
  final bool isVoiceActive;
  final bool isHandRaised;
  final bool isSharingScreen;
  final bool isVideoOn;
  final bool isHost;
  final RTCVideoRenderer? renderer;

  const CallParticipantState({
    required this.sessionId,
    required this.userId,
    this.isMuted = false,
    this.isVoiceActive = false,
    this.isHandRaised = false,
    this.isSharingScreen = false,
    this.isVideoOn = false,
    this.isHost = false,
    this.renderer,
  });

  CallParticipantState copyWith({
    bool? isMuted,
    bool? isVoiceActive,
    bool? isHandRaised,
    bool? isSharingScreen,
    bool? isVideoOn,
    bool? isHost,
    RTCVideoRenderer? renderer,
  }) {
    return CallParticipantState(
      sessionId: sessionId,
      userId: userId,
      isMuted: isMuted ?? this.isMuted,
      isVoiceActive: isVoiceActive ?? this.isVoiceActive,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      isHost: isHost ?? this.isHost,
      renderer: renderer ?? this.renderer,
    );
  }
}

/// تفاعل (emoji) من مشارك أثناء المكالمة (user_reacted).
class CallReactionEvent {
  final String sessionId;
  final String userId;
  final String emojiName;

  /// الرمز الحرفي للإيموجي (`emoji.literal`) للعرض المباشر.
  final String emojiLiteral;
  final int timestamp;

  const CallReactionEvent({
    required this.sessionId,
    required this.userId,
    required this.emojiName,
    required this.emojiLiteral,
    required this.timestamp,
  });
}

/// إجراء تحكم من المضيف موجّه إلينا (host_mute/host_removed/...).
class CallHostControlEvent {
  final String type;
  final Map<String, dynamic> data;

  const CallHostControlEvent({required this.type, required this.data});
}

/// آلة حالات المكالمة في CallsManager (المرحلة 3).
enum CallState { idle, ringing, joining, connected, reconnecting, ended }

@lazySingleton
class CallsManager {
  final WebSocketClientManager _webSocketClientManager;
  final CallsWebSocketClient _callsClient;
  final CallsRestRepository _callsRestRepository;
  final AudioSessionManager _audioSessionManager;
  final SFUStreamManager _sfuStreamManager;

  StreamSubscription? _hubSubscription;
  StreamSubscription? _callsSubscription;
  StreamSubscription? _statusSubscription;

  final StreamController<CallStartedEvent> _incomingCallsController =
      StreamController<CallStartedEvent>.broadcast();

  final StreamController<Map<String, CallParticipantState>>
  _participantsController =
      StreamController<Map<String, CallParticipantState>>.broadcast();

  final StreamController<CallReactionEvent> _reactionsController =
      StreamController<CallReactionEvent>.broadcast();

  final StreamController<CallHostControlEvent> _hostControlController =
      StreamController<CallHostControlEvent>.broadcast();

  /// انتهاء مكالمة في قناة (call_end) — ليعيد الـ bloc الحالة إلى idle.
  final StreamController<String> _callEndedController =
      StreamController<String>.broadcast();

  /// حالة آلة الحالات الحالية للمكالمة.
  final StreamController<CallState> _callStateController =
      StreamController<CallState>.broadcast();

  /// انتهاء مهلة الرنين لمكالمة واردة (رفض تلقائي) — يحمل channelId.
  final StreamController<String> _incomingCallExpiredController =
      StreamController<String>.broadcast();

  final StreamController<bool> _recordingStateController =
      StreamController<bool>.broadcast();

  final StreamController<CallCaptionEvent> _captionController =
      StreamController<CallCaptionEvent>.broadcast();

  /// مؤقت مهلة الرنين للمكالمة الواردة.
  Timer? _incomingCallTimer;

  /// رنّان المكالمة الواردة (نغمة نظام + اهتزاز).
  final CallRinger _ringer = CallRinger();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  late final RTCVideoRenderer _localRenderer;
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, CallParticipantState> _participants = {};

  bool _isInitialized = false;
  bool _sessionReady = false;
  bool _pendingOffer = false;

  /// الحالة الحالية لآلة الحالات — idle افتراضياً.
  CallState _callState = CallState.idle;

  /// القناة التي انضممنا لمكالمتها (تُحفظ لإعادة الاتصال والتحكم).
  String? _activeChannelId;

  /// معرف المكالمة الحالية (من call_start / حالة المكالمة).
  String? _callId;

  /// لحظة بدء المكالمة الحالية (من `start_at` في call_start / حالة الخادم) —
  /// يُقرأ بواسطة عدّاد المدة في CallWidget (مطابق callStartAt في webapp).
  DateTime? _callStartAt;

  /// لحظة بدء المكالمة الحالية (null خارج مكالمة).
  DateTime? get callStartAt => _callStartAt;

  /// تدفق المكالمات الواردة (call_start على الـ Hub الرئيسي).
  Stream<CallStartedEvent> get incomingCalls => _incomingCallsController.stream;

  /// تدفق تحديث بيانات وتغييرات المشاركين بالمكالمة.
  Stream<Map<String, CallParticipantState>> get participantsStream =>
      _participantsController.stream;

  /// تفاعلات المشاركين (user_reacted).
  Stream<CallReactionEvent> get reactionsStream => _reactionsController.stream;

  /// إجراءات تحكم المضيف الموجهة إلينا (host_mute/...).
  Stream<CallHostControlEvent> get hostControlStream =>
      _hostControlController.stream;

  /// انتهاء مكالمة (call_end) — يحمل channelId.
  Stream<String> get callEndedStream => _callEndedController.stream;

  /// حالة آلة الحالات (idle/ringing/joining/connected/reconnecting/ended).
  Stream<CallState> get callStateStream => _callStateController.stream;

  /// آخر حالة معروفة لآلة الحالات.
  CallState get currentCallState => _callState;

  /// انتهاء مهلة الرنين لمكالمة واردة (رفض تلقائي) — يحمل channelId.
  Stream<String> get incomingCallExpiredStream =>
      _incomingCallExpiredController.stream;

  /// حالة تسجيل المكالمة (بدأ/توقف).
  Stream<bool> get recordingStateStream => _recordingStateController.stream;

  /// تدفق الترجمة الحية (captions).
  Stream<CallCaptionEvent> get captionStream => _captionController.stream;

  /// حالة اتصال المكالمات (تستخدم للتفريق بين reconnecting/connected).
  Stream<CallsWebSocketStatus> get connectionStatusStream =>
      _callsClient.statusStream;

  CallsWebSocketStatus get connectionStatus => _callsClient.status;

  /// معرف المكالمة الحالية (null خارج مكالمة).
  String? get currentCallId => _callId;

  RTCVideoRenderer get localRenderer => _localRenderer;
  Map<String, RTCVideoRenderer> get remoteRenderers => _remoteRenderers;

  /// القناة الحالية للمكالمة النشطة.
  String? get currentChannelId => _activeChannelId;

  /// هل المستخدم الحالي هو مضيف المكالمة؟ (userId == host_id)
  bool get isCurrentUserHost {
    final mySessionId = _callsClient.sessionId;
    if (mySessionId == null) return false;
    return _participants[mySessionId]?.isHost ?? false;
  }
  Map<String, CallParticipantState> get participants => _participants;

  AudioSessionManager get audioSessionManager => _audioSessionManager;

  CallsManager(
    this._webSocketClientManager,
    this._callsClient,
    this._callsRestRepository,
    this._audioSessionManager,
    this._sfuStreamManager,
  ) : _localRenderer = RTCVideoRenderer() {
    _hubSubscription = _webSocketClientManager.eventStream.listen(
      _onHubEvent,
    );
    _callsSubscription = _callsClient.events.listen(_onCallsEvent);
    _statusSubscription = _callsClient.statusStream.listen(
      _onConnectionStatusChanged,
    );
  }

  void _setCallState(CallState state) {
    if (_callState == state) return;
    _callState = state;
    if (!_callStateController.isClosed) {
      _callStateController.add(state);
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _localRenderer.initialize();
    await _audioSessionManager.initializeAudioSession();
    _isInitialized = true;
  }

  /// يضمن وجود اتصال مكالمات جاهز (بعد `hello`) — الأول فقط ينتظر الجلسة.
  Future<void> _ensureCallsConnected() async {
    if (_sessionReady) return;

    final completer = Completer<void>();
    late final StreamSubscription<CallsWebSocketEvent> sub;
    sub = _callsClient.events.listen((event) {
      if (event is CallsWSSessionReadyEvent && !completer.isCompleted) {
        completer.complete();
      }
    });

    await _callsClient.connect();
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );
    await sub.cancel();
  }

  /// بدء/الانضمام إلى مكالمة قناة. [selfInitiated]=true للمنشئ (يرسل العرض
  /// الأول بعد إقرار join) و false لمن ينضم لمكالمة قائمة (ينتظر العرض).
  Future<void> startCall(
    String channelId, {
    bool video = false,
    bool selfInitiated = true,
  }) async {
    await initialize();
    _activeChannelId = channelId;
    _pendingOffer = selfInitiated;
    _cancelIncomingCallRingingTimer();
    _setCallState(CallState.joining);

    await _ensureCallsConnected();
    _callsClient.joinCall(channelId);
    await _setupPeerConnection(video: video);
  }

  /// الانضمام لمكالمة قائمة (من حالة الرنين) — ينتظر عرض من المضيف.
  Future<void> joinExistingCall(String channelId, {bool video = false}) =>
      startCall(channelId, video: video, selfInitiated: false);

  Future<void> _setupPeerConnection({bool video = false}) async {
    final iceConfiguration = await _buildIceConfiguration();

    final configuration = {
      ...iceConfiguration,
      'sdpSemantics': 'unified-plan',
      if (kIsWeb) 'encodedInsertableStreams': true,
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _callsClient.sendIce({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _setCallState(CallState.reconnecting);
        _restartIce();
      } else if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        if (_callState == CallState.reconnecting) {
          _setCallState(CallState.connected);
        }
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) async {
      if (event.streams.isEmpty) return;
      final stream = event.streams[0];
      // في نموذج SFU، track ID يحمل session_id المرسل:
      // `audio_<session_id>_<random>` (راجع genTrackID في rtcd v1.2.6) —
      // بهذا نربط ستريم كل مشارك بجلسته في _participants.
      final trackSessionId = _sessionIdFromTrackId(event.track.id);
      final sessionId = trackSessionId ?? stream.id;
      final existing = _remoteRenderers[sessionId];
      if (existing == null) {
        final renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = stream;
        _remoteRenderers[sessionId] = renderer;
      } else {
        existing.srcObject = stream;
      }
      _participants[sessionId] = CallParticipantState(
        sessionId: sessionId,
        userId: _participants[sessionId]?.userId ?? sessionId,
        isMuted: _participants[sessionId]?.isMuted ?? false,
        isVoiceActive: _participants[sessionId]?.isVoiceActive ?? false,
        isHandRaised: _participants[sessionId]?.isHandRaised ?? false,
        isSharingScreen: _participants[sessionId]?.isSharingScreen ?? false,
        isVideoOn: _participants[sessionId]?.isVideoOn ?? false,
        isHost: _participants[sessionId]?.isHost ?? false,
        renderer: _remoteRenderers[sessionId],
      );
      _emitParticipants();
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': video,
    });

    _localRenderer.srcObject = _localStream;

    _localStream!.getTracks().forEach((track) {
      if (track.kind == 'video') {
        _peerConnection!.addTransceiver(
          track: track,
          init: RTCRtpTransceiverInit(
            direction: TransceiverDirection.SendOnly,
            streams: [_localStream!],
            sendEncodings: [
              RTCRtpEncoding(rid: 'h', active: true, maxBitrate: 900000),
              RTCRtpEncoding(rid: 'm', active: true, maxBitrate: 300000, scaleResolutionDownBy: 2.0),
              RTCRtpEncoding(rid: 'l', active: true, maxBitrate: 100000, scaleResolutionDownBy: 4.0),
            ],
          ),
        );
      } else {
        _peerConnection!.addTrack(track, _localStream!);
      }
    });

    _sfuStreamManager.startMonitoring(_peerConnection!);
  }

  /// تكوين ICE من REST: `ICEServersConfigs` (أو `ICEServers` القديم) + اعتمادات
  /// TURN عند الحاجة — مطابق getICEServersConfigs في عميل الموبايل.
  Future<Map<String, dynamic>> _buildIceConfiguration() async {
    const fallbackIceServers = [
      {'urls': 'stun:stun.l.google.com:19302'},
    ];

    final configResult = await _callsRestRepository.getCallsConfig();
    if (configResult is! ApiSuccess<Map<String, dynamic>>) {
      return {'iceServers': fallbackIceServers};
    }

    final config = configResult.data;
    final iceServers = <Map<String, dynamic>>[];

    final configs = config['ICEServersConfigs'];
    if (configs is List && configs.isNotEmpty) {
      iceServers.addAll(
        configs.map((e) => Map<String, dynamic>.from(e as Map)),
      );
    } else {
      final deprecated = config['ICEServers'];
      if (deprecated is List && deprecated.isNotEmpty) {
        iceServers.add({'urls': deprecated.cast<String>().toList()});
      }
    }

    if (config['NeedsTURNCredentials'] == true) {
      final turnResult = await _callsRestRepository.getTURNCredentials();
      if (turnResult is ApiSuccess<List<Map<String, dynamic>>>) {
        iceServers.addAll(turnResult.data);
      }
    }

    if (iceServers.isEmpty) {
      iceServers.addAll(fallbackIceServers);
    }

    return {'iceServers': iceServers};
  }

  Future<void> _sendOffer() async {
    if (_peerConnection == null) return;
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _callsClient.sendSdp({'type': 'offer', 'sdp': offer.sdp});
  }

  Future<void> _restartIce() async {
    if (_peerConnection == null) return;
    final offer = await _peerConnection!.createOffer({'iceRestart': true});
    await _peerConnection!.setLocalDescription(offer);
    _callsClient.sendSdp({'type': 'offer', 'sdp': offer.sdp});
  }

  void toggleMute() {
    final audioTrack = _localStream?.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      audioTrack.enabled = !audioTrack.enabled;
      if (audioTrack.enabled) {
        _callsClient.sendUnmute();
      } else {
        _callsClient.sendMute();
      }
    }
  }

  void toggleVideo() {
    final videoTrack = _localStream?.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      videoTrack.enabled = !videoTrack.enabled;
    }
  }

  void raiseHand(bool raise) {
    if (raise) {
      _callsClient.sendRaiseHand();
    } else {
      _callsClient.sendUnraiseHand();
    }
  }

  /// إرسال تفاعل (emoji) — `react{data: <EmojiData JSON>}` — الخادم يبث
  /// `user_reacted` للجميع (المرسل أيضاً) ولا يخزّن/يمسح التفاعلات.
  void sendReaction(CallsEmoji emoji) {
    _callsClient.sendReact(emoji);
  }

  // ── تحكمات المضيف (REST) ────────────────────────────────────

  /// كتم جميع المشاركين عدا المضيف والمستخدم الحالي.
  Future<void> hostMuteAll() async {
    final callId = _callId;
    if (callId == null) return;
    final mySessionId = _callsClient.sessionId;
    for (final entry in _participants.entries) {
      final participant = entry.value;
      if (participant.sessionId == mySessionId || participant.isHost) continue;
      await _callsRestRepository.hostMute(callId, participant.sessionId);
    }
  }

  /// إنزال كل الأيدي المرفوعة (عدا المضيف والمستخدم الحالي).
  Future<void> hostLowerAllHands() async {
    final callId = _callId;
    if (callId == null) return;
    final mySessionId = _callsClient.sessionId;
    for (final entry in _participants.entries) {
      final participant = entry.value;
      if (participant.sessionId == mySessionId || participant.isHost) continue;
      await _callsRestRepository.hostLowerHand(callId, participant.sessionId);
    }
  }

  /// طرد مشارك من المكالمة (host_remove).
  Future<void> hostRemove(String sessionId) async {
    final callId = _callId;
    if (callId == null) return;
    await _callsRestRepository.hostRemove(callId, sessionId);
  }

  /// إنهاء المكالمة للجميع — REST end + تنظيف محلي.
  Future<void> hostEndCall() async {
    final channelId = _activeChannelId;
    if (channelId != null) {
      await _callsRestRepository.endCall(channelId);
    }
    await endCall();
  }

  /// رفض مكالمة واردة — `dismiss-notification` (كما يفعل عميل الموبايل
  /// في rejectCall) مع تنظيف محلي دون leave.
  Future<void> dismissIncomingCall(String channelId) async {
    _cancelIncomingCallRingingTimer();
    await _callsRestRepository.dismissCall(channelId);
    _setCallState(CallState.idle);
  }

  Future<void> toggleScreenShare() async {
    await initialize();
    if (_peerConnection == null) return;

    final isCurrentlySharing = _participants[_callsClient.sessionId]?.isSharingScreen ?? false;

    if (isCurrentlySharing) {
      // Switch back to camera
      final senders = await _peerConnection!.getSenders();
      final videoSender = senders.firstWhere((s) => s.track?.kind == 'video');
      final cameraStream = await navigator.mediaDevices.getUserMedia({
        'audio': false,
        'video': true,
      });
      final cameraTrack = cameraStream.getVideoTracks().first;
      await videoSender.replaceTrack(cameraTrack);
      _localRenderer.srcObject = cameraStream;
      _updateParticipant(_callsClient.sessionId!, isSharingScreen: false);
    } else {
      // Start screen sharing
      final displayStream = await navigator.mediaDevices.getDisplayMedia({
        'video': true,
        'audio': true,
      });
      final displayTrack = displayStream.getVideoTracks().first;
      
      final senders = await _peerConnection!.getSenders();
      final videoSender = senders.firstWhere((s) => s.track?.kind == 'video');
      await videoSender.replaceTrack(displayTrack);
      
      _localRenderer.srcObject = displayStream;
      _updateParticipant(_callsClient.sessionId!, isSharingScreen: true);
      
      displayTrack.onEnded = () {
        toggleScreenShare(); // Revert when system stops sharing
      };
    }
  }

  Future<void> endCall() async {
    _callsClient.leaveCall();
    _callsClient.closeForLeave();

    _activeChannelId = null;
    _callId = null;
    _callStartAt = null;
    _pendingOffer = false;
    _sessionReady = false;

    _cancelIncomingCallRingingTimer();
    _setCallState(CallState.idle);
    await _audioSessionManager.deactivateAudioSession();

    await _cleanupResources();
  }

  Future<void> _cleanupResources() async {
    _sfuStreamManager.stopMonitoring();

    // Stop all local tracks
    if (_localStream != null) {
      for (final track in _localStream!.getTracks()) {
        await track.stop();
      }
      await _localStream!.dispose();
      _localStream = null;
    }

    // Close peer connection
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }

    // Reset local renderer
    _localRenderer.srcObject = null;

    // Dispose remote renderers
    for (final sessionId in _remoteRenderers.keys.toList()) {
      final renderer = _remoteRenderers.remove(sessionId);
      if (renderer != null) {
        renderer.srcObject = null;
        await renderer.dispose();
      }
    }

    _remoteRenderers.clear();
    _participants.clear();
    _emitParticipants();
  }

  // ── معالجة أحداث اتصال المكالمات (calls=true) ───────────────

  void _onCallsEvent(CallsWebSocketEvent event) {
    switch (event) {
      case CallsWSSessionReadyEvent():
        _sessionReady = true;
        if (event.isReconnect) {
          _handleReconnected();
        }
      case CallsWSJoinedEvent():
        _setCallState(CallState.connected);
        if (_pendingOffer) {
          _pendingOffer = false;
          _sendOffer();
        }
      case CallsWSSignalEvent():
        _handleSignal(event);
      case CallsWSErrorEvent():
        debugPrint('[calls-manager] server error: ${event.message}');
      case CallsWSCallStateEvent():
        _applyCallState(
          event.call != null ? CallDto.fromMap(event.call!) : null,
        );
    }
  }

  Future<void> _handleReconnected() async {
    // إعادة التفاوض (offer مع iceRestart) عبر الاتصال الجديد، وتحديث
    // المشاركين من الخادم — المطابق لسلوك عميل الموبايل بعد إعادة الاتصال.
    if (_activeChannelId != null && _peerConnection != null) {
      await _restartIce();
    }
    if (_activeChannelId != null) {
      await _refreshParticipants();
    }
  }

  Future<void> _refreshParticipants() async {
    final channelId = _activeChannelId;
    if (channelId == null) return;
    final result = await _callsRestRepository.getChannelCallState(channelId);
    if (result is! ApiSuccess<CallChannelStateDto>) return;
    _applyCallState(result.data.call);
  }

  /// يطبق حالة المكالمة من الخادم (WS call_state أو REST) — sessions[].
  void _applyCallState(CallDto? call) {
    if (call == null) return;

    _callId = call.id;
    if (call.startAt > 0) {
      _callStartAt = DateTime.fromMillisecondsSinceEpoch(
        call.startAt,
        isUtc: true,
      );
    }

    final hostId = call.hostId;
    for (final session in call.sessions) {
      if (session.sessionId.isEmpty) continue;
      final existing = _participants[session.sessionId];
      _participants[session.sessionId] = CallParticipantState(
        sessionId: session.sessionId,
        userId: session.userId.isEmpty
            ? (existing?.userId ?? session.sessionId)
            : session.userId,
        isMuted: !session.unmuted,
        isHandRaised: session.raisedHand != 0,
        isVideoOn: session.video,
        isHost: session.userId == hostId,
        renderer: existing?.renderer,
      );
    }
    _emitParticipants();
  }

  void _handleSignal(CallsWSSignalEvent event) {
    final type = event.data['type'] as String?;
    if (type == 'offer') {
      _handleRemoteOffer(event.data);
    } else if (type == 'answer') {
      _handleRemoteAnswer(event.data);
    } else if (type == 'candidate') {
      _handleRemoteCandidate(event.data);
    }
  }

  Future<void> _handleRemoteOffer(Map<String, dynamic> data) async {
    if (_peerConnection == null) {
      await _setupPeerConnection();
    }
    final sdp = data['sdp'] as String?;
    if (sdp == null) return;
    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(sdp, 'offer'),
    );
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);
    _callsClient.sendSdp({'type': 'answer', 'sdp': answer.sdp});
  }

  Future<void> _handleRemoteAnswer(Map<String, dynamic> data) async {
    final sdp = data['sdp'] as String?;
    if (sdp == null) return;
    await _peerConnection?.setRemoteDescription(
      RTCSessionDescription(sdp, 'answer'),
    );
  }

  Future<void> _handleRemoteCandidate(Map<String, dynamic> data) async {
    final candidate = data['candidate'];
    final sdpMid = data['sdpMid'];
    final sdpMLineIndex = data['sdpMLineIndex'];
    if (candidate == null || sdpMid == null || sdpMLineIndex == null) return;
    await _peerConnection?.addCandidate(
      RTCIceCandidate(candidate, sdpMid, sdpMLineIndex),
    );
  }

  // ── معالجة أحداث الـ Hub الرئيسي (حالة المكالمة) ────────────

  void _onHubEvent(TypedWebSocketEvent event) {
    if (event is CallStartedEvent) {
      _onCallStarted(event);
    } else if (event is CallEndedEvent) {
      _handleCallEnd(event);
    } else if (event is CallUserJoinedEvent) {
      _handleUserJoined(event);
    } else if (event is CallUserLeftEvent) {
      _handleUserLeft(event);
    } else if (event is CallUserMuteEvent) {
      _updateParticipant(event.sessionId, isMuted: event.muted);
    } else if (event is CallUserVideoEvent) {
      _updateParticipant(event.sessionId, isVideoOn: event.videoOn);
    } else if (event is CallUserVoiceEvent) {
      _updateParticipant(event.sessionId, isVoiceActive: event.voiceActive);
    } else if (event is CallScreenShareEvent) {
      _updateParticipant(event.sessionId, isSharingScreen: event.sharing);
    } else if (event is CallRaiseHandEvent) {
      _updateParticipant(event.sessionId, isHandRaised: event.raised);
    } else if (event is CallUserReactedEvent) {
      _handleUserReacted(event);
    } else if (event is CallRecordingStateEvent) {
      _handleRecordingState(event);
    } else if (event is CallJobStateEvent) {
      _handleJobState(event);
    } else if (event is CallCaptionEvent) {
      _captionController.add(event);
    } else if (event is CallHostChangedEvent) {
      _handleHostChanged(event);
    } else if (event is CallStateEvent) {
      // host_mute/host_unmute/host_screen_off/host_lower_hand/host_removed
      // call_state وغيرها من الأحداث غير المذكورة في الكلاسات typed.
      _handleCallStateEvent(event);
    }
  }

  void _onCallStarted(CallStartedEvent event) {
    // تذكّر لحظة بدء المكالمة لعدّاد المدة (أول حدث call_start للمكالمة).
    _callStartAt = event.startAt ?? _callStartAt;

    // المكالمة التي أنشأناها/انضممنا لها لا تُعرض كرنين وارد.
    if (_activeChannelId == event.channelId) {
      _callId = event.callId;
      return;
    }

    // Desktop: Bring window to front and focus on incoming call
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux)) {
      windowManager.show();
      windowManager.focus();
    }

    // مكالمة واردة في قناة أخرى: رنين + مهلة زمنية للرفض التلقائي.
    if (_callState == CallState.idle || _callState == CallState.ended) {
      _setCallState(CallState.ringing);
    }
    _startIncomingCallRingingTimer(event.channelId);
    _incomingCallsController.add(event);
  }

  void _handleCallStateEvent(CallStateEvent event) {
    switch (event.callEventName) {
      case 'host_mute':
      case 'host_screen_off':
      case 'host_lower_hand':
      case 'host_removed':
        _hostControlController.add(
          CallHostControlEvent(type: event.callEventName, data: event.data),
        );
        break;
      default:
        break;
    }
  }

  void _handleCallEnd(CallEndedEvent event) {
    _participants.clear();
    _emitParticipants();
    _cancelIncomingCallRingingTimer();
    if (_activeChannelId == event.channelId) {
      _callStartAt = null;
    }
    _setCallState(CallState.ended);
    _callEndedController.add(event.channelId);
  }

  // ── مهلة الرنين للمكالمة الواردة ───────────────────────────

  static const Duration incomingCallRingDuration = Duration(seconds: 30);

  void _startIncomingCallRingingTimer(String channelId) {
    _incomingCallTimer?.cancel();
    _ringer.startRinging();
    _incomingCallTimer = Timer(incomingCallRingDuration, () {
      if (_callState == CallState.ringing) {
        _setCallState(CallState.idle);
      }
      _ringer.stopRinging();
      _incomingCallExpiredController.add(channelId);
    });
  }

  void _cancelIncomingCallRingingTimer() {
    _incomingCallTimer?.cancel();
    _incomingCallTimer = null;
    _ringer.stopRinging();
  }

  // ── ربط الجلسات بالستريمات (نموذج SFU) ──────────────────────

  /// يستخرج session_id من track id على نمط `audio_<session_id>_<random>`
  /// (راجع genTrackID/isValidTrackID في rtcd v1.2.6).
  String? _sessionIdFromTrackId(String? trackId) {
    if (trackId == null) return null;
    final fields = trackId.split('_');
    if (fields.length != 3) return null;
    return fields[1];
  }

  void _onConnectionStatusChanged(CallsWebSocketStatus status) {
    switch (status) {
      case CallsWebSocketStatus.disconnected:
        if (_callState == CallState.connected ||
            _callState == CallState.reconnecting) {
          _setCallState(CallState.reconnecting);
        }
      case CallsWebSocketStatus.reconnecting:
        if (_callState == CallState.connected) {
          _setCallState(CallState.reconnecting);
        }
      case CallsWebSocketStatus.connected:
        if (_callState == CallState.reconnecting) {
          _setCallState(CallState.connected);
        }
      case CallsWebSocketStatus.connecting:
      case CallsWebSocketStatus.error:
        break;
    }
  }

  void _handleUserJoined(CallUserJoinedEvent event) {
    if (event.sessionId.isEmpty) return;
    if (_participants.containsKey(event.sessionId)) return;
    _participants[event.sessionId] = CallParticipantState(
      sessionId: event.sessionId,
      userId: event.userId,
    );
    _emitParticipants();
  }

  void _handleUserLeft(CallUserLeftEvent event) {
    if (event.sessionId.isEmpty) return;
    final renderer = _remoteRenderers.remove(event.sessionId);
    if (renderer != null) {
      unawaited(renderer.dispose());
    }
    _participants.remove(event.sessionId);
    _emitParticipants();
  }

  void _updateParticipant(
    String sessionId, {
    bool? isMuted,
    bool? isVoiceActive,
    bool? isHandRaised,
    bool? isSharingScreen,
    bool? isVideoOn,
  }) {
    if (sessionId.isEmpty) return;
    final existing = _participants[sessionId];
    if (existing == null) return;
    _participants[sessionId] = existing.copyWith(
      isMuted: isMuted,
      isVoiceActive: isVoiceActive,
      isHandRaised: isHandRaised,
      isSharingScreen: isSharingScreen,
      isVideoOn: isVideoOn,
    );
    _emitParticipants();
  }

  void _handleUserReacted(CallUserReactedEvent event) {
    if (event.sessionId.isEmpty) return;
    _reactionsController.add(
      CallReactionEvent(
        sessionId: event.sessionId,
        userId: event.userId,
        emojiName: event.emojiName,
        emojiLiteral: event.emojiLiteral,
        timestamp: event.timestamp,
      ),
    );
  }

  void _handleHostChanged(CallHostChangedEvent event) {
    for (final entry in _participants.entries.toList()) {
      _participants[entry.key] = entry.value.copyWith(
        isHost: entry.value.userId == event.hostId,
      );
    }
    _emitParticipants();
  }

  void _emitParticipants() {
    if (!_participantsController.isClosed) {
      _participantsController.add(_participants);
    }
  }

  void _handleRecordingState(CallRecordingStateEvent event) {
    _recordingStateController.add(event.recording);
  }

  void _handleJobState(CallJobStateEvent event) {
    // Similarly track job states if needed
  }

  Future<void> startRecording() async {
    if (_activeChannelId != null) {
      await _callsRestRepository.startRecording(_activeChannelId!);
    }
  }

  Future<void> stopRecording() async {
    if (_activeChannelId != null) {
      await _callsRestRepository.stopRecording(_activeChannelId!);
    }
  }

  Future<void> dispose() async {
    _hubSubscription?.cancel();
    _callsSubscription?.cancel();
    _statusSubscription?.cancel();
    _cancelIncomingCallRingingTimer();
    _callsClient.dispose();
    await _incomingCallsController.close();
    await _participantsController.close();
    await _reactionsController.close();
    await _hostControlController.close();
    await _callEndedController.close();
    await _callStateController.close();
    await _incomingCallExpiredController.close();
    await _recordingStateController.close();
    await _captionController.close();
    await _localRenderer.dispose();
    for (final r in _remoteRenderers.values) {
      await r.dispose();
    }
    _remoteRenderers.clear();
    await endCall();
  }
}
