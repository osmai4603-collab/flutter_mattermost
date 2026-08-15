/// مشارك في مكالمة حسب شكل `UserStateClient` في خادم الإضافة
/// (`session_id`, `user_id`, `unmuted`, `raised_hand`, `video`) —
/// المستخدم في `call.sessions` بـ `CallStateClient` (WS call_state + REST).
final class CallParticipantDto {
  final String sessionId;
  final String userId;
  final bool unmuted;
  final int raisedHand;
  final bool video;

  const CallParticipantDto({
    required this.sessionId,
    required this.userId,
    required this.unmuted,
    required this.raisedHand,
    required this.video,
  });

  factory CallParticipantDto.fromMap(Map<String, dynamic> data) {
    return CallParticipantDto(
      sessionId: data['session_id'] ?? '',
      userId: data['user_id'] ?? '',
      unmuted: data['unmuted'] ?? false,
      raisedHand: (data['raised_hand'] ?? 0).toInt(),
      video: data['video'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'session_id': sessionId,
        'user_id': userId,
        'unmuted': unmuted,
        'raised_hand': raisedHand,
        'video': video,
      };
}
