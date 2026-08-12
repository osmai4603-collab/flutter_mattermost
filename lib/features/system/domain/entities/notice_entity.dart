import 'package:equatable/equatable.dart';

class NoticeEntity extends Equatable {
  final String? id;
  final bool? sysAdminOnly;
  final bool? teamAdminOnly;
  final String? action;
  final String? actionParam;
  final String? actionText;
  final String? description;
  final String? image;
  final String? title;

  const NoticeEntity({
    this.id,
    this.sysAdminOnly,
    this.teamAdminOnly,
    this.action,
    this.actionParam,
    this.actionText,
    this.description,
    this.image,
    this.title,
  });

  @override
  List<Object?> get props => [
        id,
        sysAdminOnly,
        teamAdminOnly,
        action,
        actionParam,
        actionText,
        description,
        image,
        title,
      ];

  NoticeEntity copyWith({
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
    return NoticeEntity(
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
}
