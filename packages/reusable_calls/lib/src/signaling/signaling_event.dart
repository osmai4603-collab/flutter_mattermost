/// Base sealed class for all WebRTC signaling events.
sealed class SignalingEvent {
  const SignalingEvent();
}

/// Received when signaling session is established.
class SessionReadyEvent extends SignalingEvent {
  final String sessionId;
  final bool isReconnect;

  const SessionReadyEvent({
    required this.sessionId,
    required this.isReconnect,
  });
}

/// Received when remote SDP offer is delivered.
class OfferEvent extends SignalingEvent {
  final String sdp;
  final String senderSessionId;

  const OfferEvent({
    required this.sdp,
    required this.senderSessionId,
  });
}

/// Received when remote SDP answer is delivered.
class AnswerEvent extends SignalingEvent {
  final String sdp;
  final String senderSessionId;

  const AnswerEvent({
    required this.sdp,
    required this.senderSessionId,
  });
}

/// Received when remote ICE candidate is delivered.
class IceCandidateEvent extends SignalingEvent {
  final String candidate;
  final String sdpMid;
  final int sdpMLineIndex;
  final String senderSessionId;

  const IceCandidateEvent({
    required this.candidate,
    required this.sdpMid,
    required this.sdpMLineIndex,
    required this.senderSessionId,
  });
}

/// Received when a participant joins the call.
class ParticipantJoinedEvent extends SignalingEvent {
  final String participantId;
  final String sessionId;

  const ParticipantJoinedEvent({
    required this.participantId,
    required this.sessionId,
  });
}

/// Received when a participant leaves the call.
class ParticipantLeftEvent extends SignalingEvent {
  final String participantId;
  final String sessionId;

  const ParticipantLeftEvent({
    required this.participantId,
    required this.sessionId,
  });
}

/// Received when call session is ended.
class CallEndedEvent extends SignalingEvent {
  final String callId;
  final String reason;

  const CallEndedEvent({
    required this.callId,
    this.reason = 'Call terminated',
  });
}
