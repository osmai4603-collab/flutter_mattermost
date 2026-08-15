import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reusable_calls/src/engine/call_engine.dart';
import 'package:reusable_calls/src/media/audio_session_controller.dart';
import 'package:reusable_calls/src/media/default_audio_session_controller.dart';
import 'package:reusable_calls/src/ringer/call_ringer_controller.dart';
import 'package:reusable_calls/src/ringer/default_call_ringer_controller.dart';
import 'package:reusable_calls/src/signaling/signaling_client.dart';
import 'package:reusable_calls/src/signaling/signaling_event.dart';
import 'package:reusable_calls/src/state/call_participant.dart';
import 'package:reusable_calls/src/state/call_state.dart';

/// Full WebRTC implementation of [CallEngine].
class WebRTCCallEngine implements CallEngine {
  final SignalingClient signalingClient;
  final AudioSessionController audioSessionController;
  final CallRingerController ringerController;
  final Map<String, dynamic> rtcConfiguration;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer? _localRenderer;

  CallState _state = CallState.idle;
  final List<CallParticipant> _participants = [];
  final List<RTCIceCandidate> _queuedCandidates = [];

  StreamSubscription? _signalingSubscription;

  final StreamController<CallState> _stateController =
      StreamController<CallState>.broadcast();
  final StreamController<List<CallParticipant>> _participantsController =
      StreamController<List<CallParticipant>>.broadcast();

  WebRTCCallEngine({
    required this.signalingClient,
    AudioSessionController? audioSessionController,
    CallRingerController? ringerController,
    Map<String, dynamic>? rtcConfiguration,
  })  : audioSessionController =
            audioSessionController ?? DefaultAudioSessionController(),
        ringerController = ringerController ?? DefaultCallRingerController(),
        rtcConfiguration = rtcConfiguration ??
            const {
              'iceServers': [
                {'urls': 'stun:stun.l.google.com:19302'},
              ],
            } {
    _listenSignalingEvents();
  }

  @override
  CallState get state => _state;

  @override
  Stream<CallState> get stateStream => _stateController.stream;

  @override
  Stream<List<CallParticipant>> get participantsStream =>
      _participantsController.stream;

  @override
  RTCVideoRenderer? get localRenderer => _localRenderer;

  void _listenSignalingEvents() {
    _signalingSubscription = signalingClient.eventStream.listen((event) async {
      switch (event) {
        case OfferEvent(:final sdp, :final senderSessionId):
          await _handleOffer(sdp, senderSessionId);
        case AnswerEvent(:final sdp):
          await _handleAnswer(sdp);
        case IceCandidateEvent(
            :final candidate,
            :final sdpMid,
            :final sdpMLineIndex
          ):
          await _handleRemoteCandidate(candidate, sdpMid, sdpMLineIndex);
        case ParticipantJoinedEvent(:final participantId, :final sessionId):
          _addParticipant(participantId, sessionId);
        case ParticipantLeftEvent(:final sessionId):
          _removeParticipant(sessionId);
        case CallEndedEvent():
          await endCall();
        default:
          break;
      }
    });
  }

  @override
  Future<void> initializeLocalStream({
    bool audio = true,
    bool video = false,
  }) async {
    final mediaConstraints = <String, dynamic>{
      'audio': audio,
      'video': video
          ? {
              'mandatory': {
                'minWidth': '640',
                'minHeight': '360',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [],
            }
          : false,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    if (video) {
      _localRenderer = RTCVideoRenderer();
      await _localRenderer!.initialize();
      _localRenderer!.srcObject = _localStream;
    }
  }

  @override
  Future<void> startCall(String callId, String channelId) async {
    _updateState(CallState.connecting);
    await audioSessionController.activateAudioSession();

    _peerConnection = await createPeerConnection(rtcConfiguration);

    if (_localStream != null) {
      for (final track in _localStream!.getTracks()) {
        await _peerConnection?.addTrack(track, _localStream!);
      }
    }

    _peerConnection?.onIceCandidate = (candidate) {
      signalingClient.sendIceCandidate(
        candidate: candidate.candidate ?? '',
        sdpMid: candidate.sdpMid ?? '',
        sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
        targetSessionId: '',
      );
    };

    _peerConnection?.onTrack = (event) async {
      if (event.streams.isNotEmpty) {
        final remoteRenderer = RTCVideoRenderer();
        await remoteRenderer.initialize();
        remoteRenderer.srcObject = event.streams[0];
      }
    };

    await signalingClient.joinCall(callId, channelId);
    _updateState(CallState.active);
  }

  Future<void> _handleOffer(String sdp, String senderSessionId) async {
    if (_peerConnection == null) return;

    final description = RTCSessionDescription(sdp, 'offer');
    await _peerConnection!.setRemoteDescription(description);

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    signalingClient.sendAnswer(
      answer.sdp ?? '',
      targetSessionId: senderSessionId,
    );
    await _drainQueuedCandidates();
  }

  Future<void> _handleAnswer(String sdp) async {
    if (_peerConnection == null) return;
    final description = RTCSessionDescription(sdp, 'answer');
    await _peerConnection!.setRemoteDescription(description);
    await _drainQueuedCandidates();
  }

  Future<void> _handleRemoteCandidate(
    String candidateStr,
    String sdpMid,
    int sdpMLineIndex,
  ) async {
    final candidate = RTCIceCandidate(candidateStr, sdpMid, sdpMLineIndex);
    if (_peerConnection != null &&
        await _peerConnection!.getRemoteDescription() != null) {
      await _peerConnection!.addCandidate(candidate);
    } else {
      _queuedCandidates.add(candidate);
    }
  }

  Future<void> _drainQueuedCandidates() async {
    if (_peerConnection == null) return;
    for (final candidate in _queuedCandidates) {
      await _peerConnection!.addCandidate(candidate);
    }
    _queuedCandidates.clear();
  }

  @override
  Future<void> toggleMicrophone() async {
    if (_localStream == null) return;
    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      final track = audioTracks.first;
      track.enabled = !track.enabled;
    }
  }

  @override
  Future<void> toggleCamera() async {
    if (_localStream == null) return;
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      final track = videoTracks.first;
      track.enabled = !track.enabled;
    }
  }

  @override
  Future<void> toggleScreenShare() async {
    // Screen share setup using DesktopCapturer or displayMedia
  }

  @override
  Future<void> switchCamera() async {
    if (_localStream == null) return;
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isNotEmpty) {
      await Helper.switchCamera(videoTracks.first);
    }
  }

  void _addParticipant(String id, String sessionId) {
    if (!_participants.any((p) => p.id == id)) {
      _participants.add(CallParticipant(id: id, name: 'Participant $id'));
      _participantsController.add(List.unmodifiable(_participants));
    }
  }

  void _removeParticipant(String sessionId) {
    _participants.removeWhere((p) => p.id == sessionId);
    _participantsController.add(List.unmodifiable(_participants));
  }

  void _updateState(CallState newState) {
    if (_state != newState) {
      _state = newState;
      _stateController.add(_state);
    }
  }

  @override
  Future<void> endCall() async {
    _updateState(CallState.ending);
    ringerController.stopRinging();
    await audioSessionController.deactivateAudioSession();

    await _localStream?.dispose();
    await _localRenderer?.dispose();
    await _peerConnection?.close();

    _localStream = null;
    _localRenderer = null;
    _peerConnection = null;

    _updateState(CallState.ended);
  }

  @override
  void dispose() {
    _signalingSubscription?.cancel();
    endCall();
    audioSessionController.dispose();
    ringerController.dispose();
    _stateController.close();
    _participantsController.close();
  }
}
