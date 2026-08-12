import 'package:equatable/equatable.dart';

class LDAPGroupsPagedEntity extends Equatable {
  final double? count;
  final List<Map<String, dynamic>>? groups;

  const LDAPGroupsPagedEntity({
    this.count,
    this.groups,
  });

  @override
  List<Object?> get props => [
        count,
        groups,
      ];

  LDAPGroupsPagedEntity copyWith({
    double? count,
    List<Map<String, dynamic>>? groups,
  }) {
    return LDAPGroupsPagedEntity(
      count: count ?? this.count,
      groups: groups ?? this.groups,
    );
  }
}
