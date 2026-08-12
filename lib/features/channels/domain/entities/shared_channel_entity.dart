import 'package:equatable/equatable.dart';

class SharedChannelEntity extends Equatable {
  final String? id;
  final String? team_id;
  final bool? home;
  final bool? readonly;
  final String? name;
  final String? display_name;
  final String? purpose;
  final String? header;
  final String? creator_id;
  final int? create_at;
  final int? update_at;
  final String? remote_id;

  const SharedChannelEntity({
    this.id,
    this.team_id,
    this.home,
    this.readonly,
    this.name,
    this.display_name,
    this.purpose,
    this.header,
    this.creator_id,
    this.create_at,
    this.update_at,
    this.remote_id,
  });

  @override
  List<Object?> get props => [
        id,
        team_id,
        home,
        readonly,
        name,
        display_name,
        purpose,
        header,
        creator_id,
        create_at,
        update_at,
        remote_id,
      ];

  SharedChannelEntity copyWith({
    String? id,
    String? team_id,
    bool? home,
    bool? readonly,
    String? name,
    String? display_name,
    String? purpose,
    String? header,
    String? creator_id,
    int? create_at,
    int? update_at,
    String? remote_id,
  }) {
    return SharedChannelEntity(
      id: id ?? this.id,
      team_id: team_id ?? this.team_id,
      home: home ?? this.home,
      readonly: readonly ?? this.readonly,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      purpose: purpose ?? this.purpose,
      header: header ?? this.header,
      creator_id: creator_id ?? this.creator_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      remote_id: remote_id ?? this.remote_id,
    );
  }
}
