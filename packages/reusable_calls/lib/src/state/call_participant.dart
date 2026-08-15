import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Representation of a participant within a WebRTC call session.
class CallParticipant {
  final String id;
  final String name;
  final bool isMuted;
  final bool isVideoOn;
  final bool isVoiceActive;
  final bool isHandRaised;
  final bool isSharingScreen;
  final bool isHost;
  final RTCVideoRenderer? videoRenderer;

  const CallParticipant({
    required this.id,
    required this.name,
    this.isMuted = false,
    this.isVideoOn = false,
    this.isVoiceActive = false,
    this.isHandRaised = false,
    this.isSharingScreen = false,
    this.isHost = false,
    this.videoRenderer,
  });

  CallParticipant copyWith({
    String? name,
    bool? isMuted,
    bool? isVideoOn,
    bool? isVoiceActive,
    bool? isHandRaised,
    bool? isSharingScreen,
    bool? isHost,
    RTCVideoRenderer? videoRenderer,
  }) {
    return CallParticipant(
      id: id,
      name: name ?? this.name,
      isMuted: isMuted ?? this.isMuted,
      isVideoOn: isVideoOn ?? this.isVideoOn,
      isVoiceActive: isVoiceActive ?? this.isVoiceActive,
      isHandRaised: isHandRaised ?? this.isHandRaised,
      isSharingScreen: isSharingScreen ?? this.isSharingScreen,
      isHost: isHost ?? this.isHost,
      videoRenderer: videoRenderer ?? this.videoRenderer,
    );
  }
}
