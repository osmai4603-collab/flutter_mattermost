import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Contract for active speaker detection in multi-party calls.
abstract class ActiveSpeakerDetector {
  /// Stream emitting session ID of currently active/loudest speaker.
  Stream<String> get activeSpeakerStream;

  /// Starts monitoring RTP statistics on peer connection.
  void startMonitoring(RTCPeerConnection pc);

  /// Stops monitoring statistics.
  void stopMonitoring();

  /// Releases resources.
  void dispose();
}
