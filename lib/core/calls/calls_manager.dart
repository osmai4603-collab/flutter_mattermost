import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';

@lazySingleton
class CallsManager {
  final WebSocketClientManager _webSocketClientManager;
  StreamSubscription? _wsSubscription;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  late final RTCVideoRenderer _localRenderer;
  late final RTCVideoRenderer _remoteRenderer;

  bool _isInitialized = false;

  CallsManager(
    this._webSocketClientManager, {
    RTCVideoRenderer? localRenderer,
    RTCVideoRenderer? remoteRenderer,
  }) : _localRenderer = localRenderer ?? RTCVideoRenderer(),
       _remoteRenderer = remoteRenderer ?? RTCVideoRenderer() {
    _wsSubscription = _webSocketClientManager.eventStream.listen(
      _onWebSocketEvent,
    );
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    _isInitialized = true;
  }

  Future<void> dispose() async {
    _wsSubscription?.cancel();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    await endCall();
  }

  void _onWebSocketEvent(TypedWebSocketEvent event) {
    if (event is CallStartedEvent) {
      _handleCallStarted(event);
    } else if (event is WebRTCSignalingEvent) {
      _handleSignalingEvent(event);
    }
  }

  Future<void> _handleCallStarted(CallStartedEvent event) async {
    // In Mattermost Calls (SFU), starting a call generally involves establishing
    // a WebRTC connection with the server. We wait for an offer from the server,
    // or we might need to send a join request.
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
    final configuration = {
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      _webSocketClientManager.sendCallSignal('ice_candidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        _remoteRenderer.srcObject = event.streams[0];
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

  void toggleMute() {
    final audioTrack = _localStream?.getAudioTracks().firstOrNull;
    if (audioTrack != null) {
      audioTrack.enabled = !audioTrack.enabled;
    }
  }

  void toggleVideo() {
    final videoTrack = _localStream?.getVideoTracks().firstOrNull;
    if (videoTrack != null) {
      videoTrack.enabled = !videoTrack.enabled;
    }
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
    _remoteRenderer.srcObject = null;

    _webSocketClientManager.sendCallSignal('leave_call', {});
  }
}
