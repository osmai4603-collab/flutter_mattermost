import 'package:flutter_mattermost/features/chat/data/models/call_participant_dto.dart';

/// حالة وظيفة تسجيل/ترجمة/ترجمة فورية حسب `JobStateClient`
/// (`type`, `init_at`, `start_at`, `end_at`, `err`).
final class CallJobStateDto {
  final String type;
  final int initAt;
  final int startAt;
  final int endAt;
  final String? err;

  const CallJobStateDto({
    required this.type,
    required this.initAt,
    required this.startAt,
    required this.endAt,
    this.err,
  });

  factory CallJobStateDto.fromMap(Map<String, dynamic> data) {
    return CallJobStateDto(
      type: data['type'] ?? '',
      initAt: (data['init_at'] ?? 0).toInt(),
      startAt: (data['start_at'] ?? 0).toInt(),
      endAt: (data['end_at'] ?? 0).toInt(),
      err: data['err'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'init_at': initAt,
        'start_at': startAt,
        'end_at': endAt,
        if (err != null) 'err': err,
      };
}

/// حالة المكالمة كما يعيدها الخادم `CallStateClient`
/// (WS `call_state` و REST `GET /{channel_id}?mobilev2=true`).
final class CallDto {
  final String id;
  final int startAt;
  final List<CallParticipantDto> sessions;
  final String threadId;
  final String postId;
  final String screenSharingSessionId;
  final String ownerId;
  final String hostId;
  final CallJobStateDto? recording;
  final CallJobStateDto? transcription;
  final CallJobStateDto? liveCaptions;
  final Map<String, bool> dismissedNotification;

  const CallDto({
    required this.id,
    required this.startAt,
    required this.sessions,
    required this.threadId,
    required this.postId,
    required this.screenSharingSessionId,
    required this.ownerId,
    required this.hostId,
    this.recording,
    this.transcription,
    this.liveCaptions,
    this.dismissedNotification = const {},
  });

  factory CallDto.fromMap(Map<String, dynamic> data) {
    return CallDto(
      id: data['id'] ?? '',
      startAt: (data['start_at'] ?? 0).toInt(),
      sessions: _parseSessions(data['sessions']),
      threadId: data['thread_id'] ?? '',
      postId: data['post_id'] ?? '',
      screenSharingSessionId: data['screen_sharing_session_id'] ?? '',
      ownerId: data['owner_id'] ?? '',
      hostId: data['host_id'] ?? '',
      recording: data['recording'] is Map
          ? CallJobStateDto.fromMap(Map<String, dynamic>.from(data['recording']))
          : null,
      transcription: data['transcription'] is Map
          ? CallJobStateDto.fromMap(
              Map<String, dynamic>.from(data['transcription']),
            )
          : null,
      liveCaptions: data['live_captions'] is Map
          ? CallJobStateDto.fromMap(
              Map<String, dynamic>.from(data['live_captions']),
            )
          : null,
      dismissedNotification: _parseDismissed(data['dismissed_notification']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'start_at': startAt,
        'sessions': sessions.map((s) => s.toMap()).toList(),
        'thread_id': threadId,
        'post_id': postId,
        'screen_sharing_session_id': screenSharingSessionId,
        'owner_id': ownerId,
        'host_id': hostId,
        if (recording != null) 'recording': recording!.toMap(),
        if (transcription != null) 'transcription': transcription!.toMap(),
        if (liveCaptions != null) 'live_captions': liveCaptions!.toMap(),
        if (dismissedNotification.isNotEmpty)
          'dismissed_notification': dismissedNotification,
      };

  static List<CallParticipantDto> _parseSessions(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => CallParticipantDto.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Map<String, bool> _parseDismissed(Object? raw) {
    if (raw is! Map) return const {};
    return raw.map(
      (k, v) => MapEntry(k.toString(), v == true),
    );
  }
}

/// استجابة `GET /{channel_id}?mobilev2=true`: `{enabled, channel_id, call}`.
final class CallChannelStateDto {
  final bool enabled;
  final String channelId;
  final CallDto? call;

  const CallChannelStateDto({
    required this.enabled,
    required this.channelId,
    this.call,
  });

  factory CallChannelStateDto.fromMap(Map<String, dynamic> data) {
    return CallChannelStateDto(
      enabled: data['enabled'] ?? false,
      channelId: data['channel_id'] ?? '',
      call: data['call'] is Map
          ? CallDto.fromMap(Map<String, dynamic>.from(data['call']))
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'enabled': enabled,
        'channel_id': channelId,
        if (call != null) 'call': call!.toMap(),
      };
}
