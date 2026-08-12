import 'package:equatable/equatable.dart';

class PlaybookEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final String? team_id;
  final bool? create_public_playbook_run;
  final int? create_at;
  final int? delete_at;
  final int? num_stages;
  final int? num_steps;
  final List<Map<String, dynamic>>? checklists;
  final List<String>? member_ids;
  final String? channel_name_template;
  final bool? channel_name_template_locked;

  const PlaybookEntity({
    this.id,
    this.title,
    this.description,
    this.team_id,
    this.create_public_playbook_run,
    this.create_at,
    this.delete_at,
    this.num_stages,
    this.num_steps,
    this.checklists,
    this.member_ids,
    this.channel_name_template,
    this.channel_name_template_locked,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        team_id,
        create_public_playbook_run,
        create_at,
        delete_at,
        num_stages,
        num_steps,
        checklists,
        member_ids,
        channel_name_template,
        channel_name_template_locked,
      ];

  PlaybookEntity copyWith({
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
    return PlaybookEntity(
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
}
