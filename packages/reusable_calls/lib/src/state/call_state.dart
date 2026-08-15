/// Connection & lifecycle states of an active or incoming WebRTC call.
enum CallState {
  idle,
  ringing,
  connecting,
  active,
  ending,
  ended,
  error;

  bool get isIdle => this == CallState.idle;
  bool get isRinging => this == CallState.ringing;
  bool get isConnecting => this == CallState.connecting;
  bool get isActive => this == CallState.active;
  bool get isEnding => this == CallState.ending;
  bool get isEnded => this == CallState.ended;
  bool get isError => this == CallState.error;
}
