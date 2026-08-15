import 'package:reusable_calls/src/state/call_state.dart';

/// Metadata for an active call session.
class CallSession {
  final String callId;
  final String channelId;
  final String initiatorId;
  final bool isHost;
  final CallState state;
  final DateTime startTime;

  CallSession({
    required this.callId,
    required this.channelId,
    required this.initiatorId,
    required this.isHost,
    this.state = CallState.connecting,
    DateTime? startTime,
  }) : startTime = startTime ?? DateTime.now();

  CallSession copyWith({
    CallState? state,
    bool? isHost,
  }) {
    return CallSession(
      callId: callId,
      channelId: channelId,
      initiatorId: initiatorId,
      isHost: isHost ?? this.isHost,
      state: state ?? this.state,
      startTime: startTime,
    );
  }
}
