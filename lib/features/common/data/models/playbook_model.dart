import 'package:flutter_mattermost/features/common/domain/entities/playbook_entity.dart';

final class PlaybookModel extends PlaybookEntity {
  const PlaybookModel({
    required super.id,
    required super.title,
    required super.description,
    required super.team_id,
    required super.create_public_playbook_run,
    required super.create_at,
    required super.delete_at,
    required super.num_stages,
    required super.num_steps,
    required super.checklists,
    required super.member_ids,
    required super.channel_name_template,
    required super.channel_name_template_locked,
  });

  factory PlaybookModel.fromMap(Map<String, dynamic> map) {
    return PlaybookModel(
      id: map["id"] as String?,
      title: map["title"] as String?,
      description: map["description"] as String?,
      team_id: map["team_id"] as String?,
      create_public_playbook_run: map["create_public_playbook_run"] as bool?,
      create_at: (map["create_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      num_stages: (map["num_stages"] as num?)?.toInt(),
      num_steps: (map["num_steps"] as num?)?.toInt(),
      checklists: (map["checklists"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      member_ids: List<String>.from(map["member_ids"] as List<dynamic>? ?? []),
      channel_name_template: map["channel_name_template"] as String?,
      channel_name_template_locked: map["channel_name_template_locked"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "team_id": team_id,
      "create_public_playbook_run": create_public_playbook_run,
      "create_at": create_at,
      "delete_at": delete_at,
      "num_stages": num_stages,
      "num_steps": num_steps,
      "checklists": checklists,
      "member_ids": member_ids,
      "channel_name_template": channel_name_template,
      "channel_name_template_locked": channel_name_template_locked,
    };
  }

  factory PlaybookModel.fromEntity(PlaybookEntity entity) {
    return PlaybookModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      team_id: entity.team_id,
      create_public_playbook_run: entity.create_public_playbook_run,
      create_at: entity.create_at,
      delete_at: entity.delete_at,
      num_stages: entity.num_stages,
      num_steps: entity.num_steps,
      checklists: entity.checklists,
      member_ids: entity.member_ids,
      channel_name_template: entity.channel_name_template,
      channel_name_template_locked: entity.channel_name_template_locked,
    );
  }

  @override
  PlaybookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? team_id,
    bool? create_public_playbook_run,
    int? create_at,
    int? delete_at,
    int? num_stages,
    int? num_steps,
    List<Map<String, dynamic>>? checklists,
    List<String>? member_ids,
    String? channel_name_template,
    bool? channel_name_template_locked,
  }) {
    return PlaybookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      team_id: team_id ?? this.team_id,
      create_public_playbook_run: create_public_playbook_run ?? this.create_public_playbook_run,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      num_stages: num_stages ?? this.num_stages,
      num_steps: num_steps ?? this.num_steps,
      checklists: checklists ?? this.checklists,
      member_ids: member_ids ?? this.member_ids,
      channel_name_template: channel_name_template ?? this.channel_name_template,
      channel_name_template_locked: channel_name_template_locked ?? this.channel_name_template_locked,
    );
  }

  PlaybookEntity toEntity() => PlaybookEntity(
        id: id,
        title: title,
        description: description,
        team_id: team_id,
        create_public_playbook_run: create_public_playbook_run,
        create_at: create_at,
        delete_at: delete_at,
        num_stages: num_stages,
        num_steps: num_steps,
        checklists: checklists,
        member_ids: member_ids,
        channel_name_template: channel_name_template,
        channel_name_template_locked: channel_name_template_locked,
      );
}
