import 'package:flutter_mattermost/features/common/domain/entities/playbook_run_entity.dart';

final class PlaybookRunModel extends PlaybookRunEntity {
  const PlaybookRunModel({
    required super.id,
    required super.name,
    required super.summary,
    required super.is_active,
    required super.owner_user_id,
    required super.team_id,
    required super.channel_id,
    required super.create_at,
    required super.end_at,
    required super.delete_at,
    required super.active_stage,
    required super.active_stage_title,
    required super.post_id,
    required super.playbook_id,
    required super.checklists,
  });

  factory PlaybookRunModel.fromMap(Map<String, dynamic> map) {
    return PlaybookRunModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      summary: map["summary"] as String?,
      is_active: map["is_active"] as bool?,
      owner_user_id: map["owner_user_id"] as String?,
      team_id: map["team_id"] as String?,
      channel_id: map["channel_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      end_at: (map["end_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      active_stage: (map["active_stage"] as num?)?.toInt(),
      active_stage_title: map["active_stage_title"] as String?,
      post_id: map["post_id"] as String?,
      playbook_id: map["playbook_id"] as String?,
      checklists: (map["checklists"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "summary": summary,
      "is_active": is_active,
      "owner_user_id": owner_user_id,
      "team_id": team_id,
      "channel_id": channel_id,
      "create_at": create_at,
      "end_at": end_at,
      "delete_at": delete_at,
      "active_stage": active_stage,
      "active_stage_title": active_stage_title,
      "post_id": post_id,
      "playbook_id": playbook_id,
      "checklists": checklists,
    };
  }

  factory PlaybookRunModel.fromEntity(PlaybookRunEntity entity) {
    return PlaybookRunModel(
      id: entity.id,
      name: entity.name,
      summary: entity.summary,
      is_active: entity.is_active,
      owner_user_id: entity.owner_user_id,
      team_id: entity.team_id,
      channel_id: entity.channel_id,
      create_at: entity.create_at,
      end_at: entity.end_at,
      delete_at: entity.delete_at,
      active_stage: entity.active_stage,
      active_stage_title: entity.active_stage_title,
      post_id: entity.post_id,
      playbook_id: entity.playbook_id,
      checklists: entity.checklists,
    );
  }

  @override
  PlaybookRunModel copyWith({
    String? id,
    String? name,
    String? summary,
    bool? is_active,
    String? owner_user_id,
    String? team_id,
    String? channel_id,
    int? create_at,
    int? end_at,
    int? delete_at,
    int? active_stage,
    String? active_stage_title,
    String? post_id,
    String? playbook_id,
    List<Map<String, dynamic>>? checklists,
  }) {
    return PlaybookRunModel(
      id: id ?? this.id,
      name: name ?? this.name,
      summary: summary ?? this.summary,
      is_active: is_active ?? this.is_active,
      owner_user_id: owner_user_id ?? this.owner_user_id,
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      create_at: create_at ?? this.create_at,
      end_at: end_at ?? this.end_at,
      delete_at: delete_at ?? this.delete_at,
      active_stage: active_stage ?? this.active_stage,
      active_stage_title: active_stage_title ?? this.active_stage_title,
      post_id: post_id ?? this.post_id,
      playbook_id: playbook_id ?? this.playbook_id,
      checklists: checklists ?? this.checklists,
    );
  }

  PlaybookRunEntity toEntity() => PlaybookRunEntity(
        id: id,
        name: name,
        summary: summary,
        is_active: is_active,
        owner_user_id: owner_user_id,
        team_id: team_id,
        channel_id: channel_id,
        create_at: create_at,
        end_at: end_at,
        delete_at: delete_at,
        active_stage: active_stage,
        active_stage_title: active_stage_title,
        post_id: post_id,
        playbook_id: playbook_id,
        checklists: checklists,
      );
}
