import 'package:equatable/equatable.dart';

class PlaybookRunEntity extends Equatable {
  final String? id;
  final String? name;
  final String? summary;
  final bool? is_active;
  final String? owner_user_id;
  final String? team_id;
  final String? channel_id;
  final int? create_at;
  final int? end_at;
  final int? delete_at;
  final int? active_stage;
  final String? active_stage_title;
  final String? post_id;
  final String? playbook_id;
  final List<Map<String, dynamic>>? checklists;

  const PlaybookRunEntity({
    this.id,
    this.name,
    this.summary,
    this.is_active,
    this.owner_user_id,
    this.team_id,
    this.channel_id,
    this.create_at,
    this.end_at,
    this.delete_at,
    this.active_stage,
    this.active_stage_title,
    this.post_id,
    this.playbook_id,
    this.checklists,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        summary,
        is_active,
        owner_user_id,
        team_id,
        channel_id,
        create_at,
        end_at,
        delete_at,
        active_stage,
        active_stage_title,
        post_id,
        playbook_id,
        checklists,
      ];

  PlaybookRunEntity copyWith({
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
    return PlaybookRunEntity(
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
}
