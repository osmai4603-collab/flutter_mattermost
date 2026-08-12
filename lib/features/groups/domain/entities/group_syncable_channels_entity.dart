import 'package:equatable/equatable.dart';

class GroupSyncableChannelsEntity extends Equatable {
  final String? channel_id;
  final String? channel_display_name;
  final String? channel_type;
  final String? team_id;
  final String? team_display_name;
  final String? team_type;
  final String? group_id;
  final bool? auto_add;
  final int? create_at;
  final int? delete_at;
  final int? update_at;

  const GroupSyncableChannelsEntity({
    this.channel_id,
    this.channel_display_name,
    this.channel_type,
    this.team_id,
    this.team_display_name,
    this.team_type,
    this.group_id,
    this.auto_add,
    this.create_at,
    this.delete_at,
    this.update_at,
  });

  @override
  List<Object?> get props => [
        channel_id,
        channel_display_name,
        channel_type,
        team_id,
        team_display_name,
        team_type,
        group_id,
        auto_add,
        create_at,
        delete_at,
        update_at,
      ];

  GroupSyncableChannelsEntity copyWith({
    String? channel_id,
    String? channel_display_name,
    String? channel_type,
    String? team_id,
    String? team_display_name,
    String? team_type,
    String? group_id,
    bool? auto_add,
    int? create_at,
    int? delete_at,
    int? update_at,
  }) {
    return GroupSyncableChannelsEntity(
      channel_id: channel_id ?? this.channel_id,
      channel_display_name: channel_display_name ?? this.channel_display_name,
      channel_type: channel_type ?? this.channel_type,
      team_id: team_id ?? this.team_id,
      team_display_name: team_display_name ?? this.team_display_name,
      team_type: team_type ?? this.team_type,
      group_id: group_id ?? this.group_id,
      auto_add: auto_add ?? this.auto_add,
      create_at: create_at ?? this.create_at,
      delete_at: delete_at ?? this.delete_at,
      update_at: update_at ?? this.update_at,
    );
  }
}
