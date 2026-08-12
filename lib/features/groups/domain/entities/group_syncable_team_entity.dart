import 'package:equatable/equatable.dart';

class GroupSyncableTeamEntity extends Equatable {
  final String? team_id;
  final String? group_id;
  final bool? auto_add;
  final int? create_at;
  final int? delete_at;
  final int? update_at;

  const GroupSyncableTeamEntity({
    this.team_id,
    this.group_id,
    this.auto_add,
    this.create_at,
    this.delete_at,
    this.update_at,
  });

  @override
  List<Object?> get props => [
        team_id,
        group_id,
        auto_add,
        create_at,
        delete_at,
        update_at,
      ];

  GroupSyncableTeamEntity copyWith({
    String? team_id,
    String? group_id,
    bool? auto_add,
    int? create_at,
    int? delete_at,
    int? update_at,
  }) {
    return GroupSyncableTeamEntity(
      team_id: team_id ?? this.team_id,
      group_id: group_id ?? this.group_id,
      auto_add: auto_add ?? this.auto_add,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      update_at: update_at ?? this.update_at,
    );
  }
}
