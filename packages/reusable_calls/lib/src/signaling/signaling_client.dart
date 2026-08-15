import 'dart:async';
import 'package:reusable_calls/src/signaling/signaling_event.dart';
import 'package:reusable_calls/src/signaling/signaling_status.dart';

/// Abstract contract for WebRTC signaling transport.
abstract class SignalingClient {
  /// Current connection status.
  SignalingStatus get status;

  /// Connection status stream.
  Stream<SignalingStatus> get statusStream;

  /// Incoming signaling event stream.
  Stream<SignalingEvent> get eventStream;

  /// Establishes signaling connection to target endpoint.
  Future<void> connect(String serverUrl, {Map<String, dynamic>? headers});

  /// Joins a specific call room or channel.
  Future<void> joinCall(String callId, String channelId);

  /// Leaves current active call room.
  Future<void> leaveCall(String callId);

  /// Sends SDP offer to remote peer or SFU server.
  void sendOffer(String sdp, {required String targetSessionId});

  /// Sends SDP answer to remote peer or SFU server.
  void sendAnswer(String sdp, {required String targetSessionId});

  /// Sends local ICE Candidate to remote peer or SFU server.
  void sendIceCandidate({
    required String candidate,
    required String sdpMid,
    required int sdpMLineIndex,
    required String targetSessionId,
  });

  /// Closes signaling transport.
  Future<void> disconnect();

  /// Releases resources.
  void dispose();
}
