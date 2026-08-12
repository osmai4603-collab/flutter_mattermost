import 'package:equatable/equatable.dart';

class NewTeamMembersListEntity extends Equatable {
  final bool? has_next;
  final List<Map<String, dynamic>>? items;
  final int? total_count;

  const NewTeamMembersListEntity({
    this.has_next,
    this.items,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        has_next,
        items,
        total_count,
      ];

  NewTeamMembersListEntity copyWith({
    bool? has_next,
    List<Map<String, dynamic>>? items,
    int? total_count,
  }) {
    return NewTeamMembersListEntity(
      has_next: has_next ?? this.has_next,
      items: items ?? this.items,
      total_count: total_count ?? this.total_count,
    );
  }
}
