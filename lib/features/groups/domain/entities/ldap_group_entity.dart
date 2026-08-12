import 'package:equatable/equatable.dart';

class LDAPGroupEntity extends Equatable {
  final bool? has_syncables;
  final String? mattermost_group_id;
  final String? primary_key;
  final String? name;

  const LDAPGroupEntity({
    this.has_syncables,
    this.mattermost_group_id,
    this.primary_key,
    this.name,
  });

  @override
  List<Object?> get props => [
        has_syncables,
        mattermost_group_id,
        primary_key,
        name,
      ];

  LDAPGroupEntity copyWith({
    bool? has_syncables,
    String? mattermost_group_id,
    String? primary_key,
    String? name,
  }) {
    return LDAPGroupEntity(
      has_syncables: has_syncables ?? this.has_syncables,
      mattermost_group_id: mattermost_group_id ?? this.mattermost_group_id,
      primary_key: primary_key ?? this.primary_key,
      name: name ?? this.name,
    );
  }
}
