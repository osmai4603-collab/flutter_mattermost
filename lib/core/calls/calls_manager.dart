import 'dart:async';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/calls_rest_repository.dart';
import 'package:flutter_mattermost/core/calls/audio_session_manager.dart';

class CallParticipantState {
  final String sessionId;
  final String userId;
  final bool isMuted;
  final bool isVoiceActive;
  final bool isHandRaised;
  final bool isSharingScreen;
  final RTCVideoRenderer? renderer;

  const CallParticipantState({
    required this.sessionId,
    required this.userId,
    this.isMuted = false,
    this.isVoiceActive = false,
    this.isHandRaised = false,
    this.isSharingScreen = false,
    this.renderer,
  });

  CallParticipantState copyWith({
    bool? isMuted,
    bool? isVoiceActive,
    bool? isHandRaised,
    bool? isSharingScreen,
    RTCVideoRenderer? renderer,
  }) {
    return CallParticipantState(
      sessionId: sessionId,
      userId: userId,
      isMuted: isMuted ?? this.isMuted,
      isVoiceActive: isVoiceActive ?? this.isVoiceActive,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      renderer: renderer ?? this.renderer,
    );
  }
}

@lazySingleton
class CallsManager {
  final WebSocketClientManager _webSocketClientManager;
  final CallsRestRepository _callsRestRepository;
  final AudioSessionManager _audioSessionManager;

  StreamSubscription? _wsSubscription;

  final StreamController<CallStartedEvent> _incomingCallsController =
      StreamController<CallStartedEvent>.broadcast();

  final StreamController<Map<String, CallParticipantState>>
  _participantsController =
      StreamController<Map<String, CallParticipantState>>.broadcast();

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  late final RTCVideoRenderer _localRenderer;
  final Map<String, RTCVideoRenderer> _remoteRenderers = {};
  final Map<String, CallParticipantState> _participants = {};

  bool _isInitialized = false;

  /// تدفق المكالمات الواردة
  Stream<CallStartedEvent> get incomingCalls => _incomingCallsController.stream;

  /// تدفق تحديث بيانات وتغييرات المشاركين بالمكالمة
  Stream<Map<String, CallParticipantState>> get participantsStream =>
      _participantsController.stream;

  RTCVideoRenderer get localRenderer => _localRenderer;
  Map<String, RTCVideoRenderer> get remoteRenderers => _remoteRenderers;
  Map<String, CallParticipantState> get participants => _participants;

  AudioSessionManager get audioSessionManager => _audioSessionManager;

  CallsManager(
    this._webSocketClientManager,
    this._callsRestRepository,
    this._audioSessionManager,
  ) : _localRenderer = RTCVideoRenderer() {
    _wsSubscription = _webSocketClientManager.eventStream.listen(
      _onWebSocketEvent,
    );
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _localRenderer.initialize();
    await _audioSessionManager.initializeAudioSession();
    _isInitialized = true;
  }

  Future<void> dispose() async {
    _wsSubscription?.cancel();
    await _incomingCallsController.close();
    await _participantsController.close();
    await _localRenderer.dispose();
    for (final r in _remoteRenderers.values) {
      await r.dispose();
    }
    _remoteRenderers.clear();
    await endCall();
  }

  void _onWebSocketEvent(TypedWebSocketEvent event) {
    if (event is CallStartedEvent) {
      _incomingCallsController.add(event);
    } else if (event is WebRTCSignalingEvent) {
      _handleSignalingEvent(event);
    }
  }

  Future<void> _handleSignalingEvent(WebRTCSignalingEvent event) async {
    final type = event.data['type'] as String?;
    if (type == 'offer') {
      final sdp = event.data['sdp'] as String?;
      if (sdp != null) {
        await _handleRemoteOffer(sdp);
      }
    } else if (type == 'answer') {
      final sdp = event.data['sdp'] as String?;
      if (sdp != null) {
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(sdp, 'answer'),
        );
      }
    } else if (type == 'candidate') {
      final candidate = event.data['candidate'];
      final sdpMid = event.data['sdpMid'];
      final sdpMLineIndex = event.data['sdpMLineIndex'];
      if (candidate != null && sdpMid != null && sdpMLineIndex != null) {
        await _peerConnection?.addCandidate(
          RTCIceCandidate(candidate, sdpMid, sdpMLineIndex),
        );
      }
    }
  }

  Future<void> startCall(String channelId, {bool video = false}) async {
    await initialize();
    _webSocketClientManager.sendCallSignal('join_call', {
      'channel_id': channelId,
    });
    await _createPeerConnection(video: video);
  }

  Future<void> _createPeerConnection({bool video = false}) async {
    // جلب تكوينات الشبكة المحلية والملاحظات
    Map<String, dynamic> iceConfiguration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ],
    };

    final configResult = await _callsRestRepository.getCallsConfig();
    if (configResult is ApiSuccess<Map<String, dynamic>>) {
      final config = configResult.data;
      if (config.containsKey('ice_servers')) {
        iceConfiguration = {'iceServers': config['ice_servers']};
      }
    }

    _peerConnection = await createPeerConnection(iceConfiguration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _webSocketClientManager.sendCallSignal('ice_candidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        _restartIce();
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) async {
      if (event.streams.isNotEmpty) {
        final stream = event.streams[0];
        final streamId = stream.id;
        if (!_remoteRenderers.containsKey(streamId)) {
          final renderer = RTCVideoRenderer();
          await renderer.initialize();
          renderer.srcObject = stream;
          _remoteRenderers[streamId] = renderer;
          _participants[streamId] = CallParticipantState(
            sessionId: streamId,
            userId: streamId,
            renderer: renderer,
          );
          _participantsController.add(_participants);
        }
      }
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': video,
    });

    _localRenderer.srcObject = _localStream;

    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });
  }

  Future<void> _restartIce() async {
    if (_peerConnection == null) return;
    final offer = await _peerConnection!.createOffer({'iceRestart': true});
    await _peerConnection!.setLocalDescription(offer);
    _webSocketClientManager.sendCallSignal('webrtc_offer', {'sdp': offer.sdp});
  }

  void toggleMute() {
    final audioTrack = _localStream?.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      audioTrack.enabled = !audioTrack.enabled;
      _webSocketClientManager.sendCallSignal(
        audioTrack.enabled ? 'unmute' : 'mute',
        {},
      );
    }
  }

  void toggleVideo() {
    final videoTrack = _localStream?.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      videoTrack.enabled = !videoTrack.enabled;
    }
  }

  void raiseHand(bool raise) {
    _webSocketClientManager.sendCallSignal(
      raise ? 'raise_hand' : 'unraise_hand',
      {},
    );
  }

  Future<void> toggleScreenShare() async {
    await initialize();
    if (_peerConnection == null) {
      await _createPeerConnection();
    }
    final videoTracks = _localStream?.getVideoTracks() ?? [];
    for (final track in videoTracks) {
      await _localStream?.removeTrack(track);
    }
    final displayStream = await navigator.mediaDevices.getDisplayMedia({
      'video': true,
      'audio': false,
    });
    final displayTrack = displayStream.getVideoTracks().first;
    await _peerConnection?.addTrack(displayTrack, displayStream);
  }

  Future<void> _handleRemoteOffer(String sdp) async {
    if (_peerConnection == null) {
      await _createPeerConnection();
    }

    await _peerConnection!.setRemoteDescription(
      RTCSessionDescription(sdp, 'offer'),
    );

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _webSocketClientManager.sendCallSignal('webrtc_answer', {
      'sdp': answer.sdp,
    });
  }

  Future<void> endCall() async {
    _localStream?.getTracks().forEach((track) => track.stop());
    await _localStream?.dispose();
    _localStream = null;

    await _peerConnection?.close();
    _peerConnection = null;

    _localRenderer.srcObject = null;
    for (final r in _remoteRenderers.values) {
      r.srcObject = null;
      await r.dispose();
    }
    _remoteRenderers.clear();
    _participants.clear();

    _webSocketClientManager.sendCallSignal('leave_call', {});
  }
}
