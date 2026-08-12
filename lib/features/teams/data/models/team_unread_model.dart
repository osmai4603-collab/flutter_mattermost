import 'package:flutter_mattermost/features/teams/domain/entities/team_unread_entity.dart';

final class TeamUnreadModel extends TeamUnreadEntity {
  const TeamUnreadModel({
    required super.team_id,
    required super.msg_count,
    required super.mention_count,
    super.urgent_mention_count,
  });

  factory TeamUnreadModel.fromMap(Map<String, dynamic> map) {
    return TeamUnreadModel(
      team_id: map["team_id"] as String?,
      msg_count: (map["msg_count"] as num?)?.toInt(),
      mention_count: (map["mention_count"] as num?)?.toInt(),
      urgent_mention_count:
          (map["urgent_mention_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "team_id": team_id,
      "msg_count": msg_count,
      "mention_count": mention_count,
      "urgent_mention_count": urgent_mention_count,
    };
  }

  factory TeamUnreadModel.fromEntity(TeamUnreadEntity entity) {
    return TeamUnreadModel(
      team_id: entity.team_id,
      msg_count: entity.msg_count,
      mention_count: entity.mention_count,
      urgent_mention_count: entity.urgent_mention_count,
    );
  }

  @override
  TeamUnreadModel copyWith({
    String? team_id,
    int? msg_count,
    int? mention_count,
    int? urgent_mention_count,
  }) {
    return TeamUnreadModel(
      team_id: team_id ?? this.team_id,
      msg_count: msg_count ?? this.msg_count,
      mention_count: mention_count ?? this.mention_count,
      urgent_mention_count:
          urgent_mention_count ?? this.urgent_mention_count,
    );
  }

  TeamUnreadEntity toEntity() => TeamUnreadEntity(
        team_id: team_id,
        msg_count: msg_count,
        mention_count: mention_count,
        urgent_mention_count: urgent_mention_count,
      );
}
