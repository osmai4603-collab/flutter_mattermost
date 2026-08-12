import 'package:equatable/equatable.dart';

class ChecklistItemEntity extends Equatable {
  final String? id;
  final String? title;
  final String? state;
  final int? state_modified;
  final String? assignee_id;
  final int? assignee_modified;
  final String? command;
  final int? command_last_run;
  final String? description;
  final int? delete_at;
  final int? due_date;
  final List<Map<String, dynamic>>? task_actions;
  final int? update_at;
  final String? condition_id;
  final String? condition_action;
  final String? condition_reason;

  const ChecklistItemEntity({
    this.id,
    this.title,
    this.state,
    this.state_modified,
    this.assignee_id,
    this.assignee_modified,
    this.command,
    this.command_last_run,
    this.description,
    this.delete_at,
    this.due_date,
    this.task_actions,
    this.update_at,
    this.condition_id,
    this.condition_action,
    this.condition_reason,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        state,
        state_modified,
        assignee_id,
        assignee_modified,
        command,
        command_last_run,
        description,
        delete_at,
        due_date,
        task_actions,
        update_at,
        condition_id,
        condition_action,
        condition_reason,
      ];

  ChecklistItemEntity copyWith({
    String? id,
    String? title,
    String? state,
    int? state_modified,
    String? assignee_id,
    int? assignee_modified,
    String? command,
    int? command_last_run,
    String? description,
    int? delete_at,
    int? due_date,
    List<Map<String, dynamic>>? task_actions,
    int? update_at,
    String? condition_id,
    String? condition_action,
    String? condition_reason,
  }) {
    return ChecklistItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      state: state ?? this.state,
      state_modified: state_modified ?? this.state_modified,
      assignee_id: assignee_id ?? this.assignee_id,
      assignee_modified: assignee_modified ?? this.assignee_modified,
      command: command ?? this.command,
      command_last_run: command_last_run ?? this.command_last_run,
      description: description ?? this.description,
      delete_at: delete_at ?? this.delete_at,
      due_date: due_date ?? this.due_date,
      task_actions: task_actions ?? this.task_actions,
      update_at: update_at ?? this.update_at,
      condition_id: condition_id ?? this.condition_id,
      condition_action: condition_action ?? this.condition_action,
      condition_reason: condition_reason ?? this.condition_reason,
    );
  }
}
