import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:reusable_calls/src/state/call_participant.dart';
import 'package:reusable_calls/src/state/call_state.dart';

/// Contract for managing WebRTC calls, local streams, and peer connections.
abstract class CallEngine {
  /// Current state of the call.
  CallState get state;

  /// Call state change stream.
  Stream<CallState> get stateStream;

  /// Active call participants stream.
  Stream<List<CallParticipant>> get participantsStream;

  /// Local user's video renderer.
  RTCVideoRenderer? get localRenderer;

  /// Initializes local audio/video media streams.
  Future<void> initializeLocalStream({bool audio = true, bool video = false});

  /// Starts or joins a call.
  Future<void> startCall(String callId, String channelId);

  /// Toggles local microphone mute/unmute.
  Future<void> toggleMicrophone();

  /// Toggles local camera on/off.
  Future<void> toggleCamera();

  /// Toggles screen sharing.
  Future<void> toggleScreenShare();

  /// Switches local camera (front/back).
  Future<void> switchCamera();

  /// Ends active call gracefully.
  Future<void> endCall();

  /// Releases media renderers and connections.
  void dispose();
}
