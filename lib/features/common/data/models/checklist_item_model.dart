import 'package:flutter_mattermost/features/common/domain/entities/checklist_item_entity.dart';

final class ChecklistItemModel extends ChecklistItemEntity {
  const ChecklistItemModel({
    required super.id,
    required super.title,
    required super.state,
    required super.state_modified,
    required super.assignee_id,
    required super.assignee_modified,
    required super.command,
    required super.command_last_run,
    required super.description,
    required super.delete_at,
    required super.due_date,
    required super.task_actions,
    required super.update_at,
    required super.condition_id,
    required super.condition_action,
    required super.condition_reason,
  });

  factory ChecklistItemModel.fromMap(Map<String, dynamic> map) {
    return ChecklistItemModel(
      id: map["id"] as String?,
      title: map["title"] as String?,
      state: map["state"] as String?,
      state_modified: (map["state_modified"] as num?)?.toInt(),
      assignee_id: map["assignee_id"] as String?,
      assignee_modified: (map["assignee_modified"] as num?)?.toInt(),
      command: map["command"] as String?,
      command_last_run: (map["command_last_run"] as num?)?.toInt(),
      description: map["description"] as String?,
      delete_at: (map["delete_at"] as num?)?.toInt(),
      due_date: (map["due_date"] as num?)?.toInt(),
      task_actions: (map["task_actions"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      update_at: (map["update_at"] as num?)?.toInt(),
      condition_id: map["condition_id"] as String?,
      condition_action: map["condition_action"] as String?,
      condition_reason: map["condition_reason"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "state": state,
      "state_modified": state_modified,
      "assignee_id": assignee_id,
      "assignee_modified": assignee_modified,
      "command": command,
      "command_last_run": command_last_run,
      "description": description,
      "delete_at": delete_at,
      "due_date": due_date,
      "task_actions": task_actions,
      "update_at": update_at,
      "condition_id": condition_id,
      "condition_action": condition_action,
      "condition_reason": condition_reason,
    };
  }

  factory ChecklistItemModel.fromEntity(ChecklistItemEntity entity) {
    return ChecklistItemModel(
      id: entity.id,
      title: entity.title,
      state: entity.state,
      state_modified: entity.state_modified,
      assignee_id: entity.assignee_id,
      assignee_modified: entity.assignee_modified,
      command: entity.command,
      command_last_run: entity.command_last_run,
      description: entity.description,
      delete_at: entity.delete_at,
      due_date: entity.due_date,
      task_actions: entity.task_actions,
      update_at: entity.update_at,
      condition_id: entity.condition_id,
      condition_action: entity.condition_action,
      condition_reason: entity.condition_reason,
    );
  }

  @override
  ChecklistItemModel copyWith({
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
    return ChecklistItemModel(
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

  ChecklistItemEntity toEntity() => ChecklistItemEntity(
        id: id,
        title: title,
        state: state,
        state_modified: state_modified,
        assignee_id: assignee_id,
        assignee_modified: assignee_modified,
        command: command,
        command_last_run: command_last_run,
        description: description,
        delete_at: delete_at,
        due_date: due_date,
        task_actions: task_actions,
        update_at: update_at,
        condition_id: condition_id,
        condition_action: condition_action,
        condition_reason: condition_reason,
      );
}
