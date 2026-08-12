import 'package:flutter_mattermost/features/system/domain/entities/notice_entity.dart';

final class NoticeModel extends NoticeEntity {
  const NoticeModel({
    required super.id,
    required super.sysAdminOnly,
    required super.teamAdminOnly,
    required super.action,
    required super.actionParam,
    required super.actionText,
    required super.description,
    required super.image,
    required super.title,
  });

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map["id"] as String?,
      sysAdminOnly: map["sysAdminOnly"] as bool?,
      teamAdminOnly: map["teamAdminOnly"] as bool?,
      action: map["action"] as String?,
      actionParam: map["actionParam"] as String?,
      actionText: map["actionText"] as String?,
      description: map["description"] as String?,
      image: map["image"] as String?,
      title: map["title"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "sysAdminOnly": sysAdminOnly,
      "teamAdminOnly": teamAdminOnly,
      "action": action,
      "actionParam": actionParam,
      "actionText": actionText,
      "description": description,
      "image": image,
      "title": title,
    };
  }

  factory NoticeModel.fromEntity(NoticeEntity entity) {
    return NoticeModel(
      id: entity.id,
      sysAdminOnly: entity.sysAdminOnly,
      teamAdminOnly: entity.teamAdminOnly,
      action: entity.action,
      actionParam: entity.actionParam,
      actionText: entity.actionText,
      description: entity.description,
      image: entity.image,
      title: entity.title,
    );
  }

  @override
  NoticeModel copyWith({
    String? id,
    bool? sysAdminOnly,
    bool? teamAdminOnly,
    String? action,
    String? actionParam,
    String? actionText,
    String? description,
    String? image,
    String? title,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      sysAdminOnly: sysAdminOnly ?? this.sysAdminOnly,
      teamAdminOnly: teamAdminOnly ?? this.teamAdminOnly,
      action: action ?? this.action,
      actionParam: actionParam ?? this.actionParam,
      actionText: actionText ?? this.actionText,
      description: description ?? this.description,
      image: image ?? this.image,
      title: title ?? this.title,
    );
  }

  NoticeEntity toEntity() => NoticeEntity(
        id: id,
        sysAdminOnly: sysAdminOnly,
        teamAdminOnly: teamAdminOnly,
        action: action,
        actionParam: actionParam,
        actionText: actionText,
        description: description,
        image: image,
        title: title,
      );
}
