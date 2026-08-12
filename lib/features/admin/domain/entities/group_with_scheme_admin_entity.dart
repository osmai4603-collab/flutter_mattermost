import 'package:equatable/equatable.dart';

class GroupWithSchemeAdminEntity extends Equatable {
  final Map<String, dynamic>? group;
  final bool? scheme_admin;

  const GroupWithSchemeAdminEntity({
    this.group,
    this.scheme_admin,
  });

  @override
  List<Object?> get props => [
        group,
        scheme_admin,
      ];

  GroupWithSchemeAdminEntity copyWith({
    Map<String, dynamic>? group,
    bool? scheme_admin,
  }) {
    return GroupWithSchemeAdminEntity(
      group: group ?? this.group,
      scheme_admin: scheme_admin ?? this.scheme_admin,
    );
  }
}
