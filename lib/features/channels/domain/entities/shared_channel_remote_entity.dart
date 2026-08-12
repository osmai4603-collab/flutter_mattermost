import 'package:equatable/equatable.dart';

class SharedChannelRemoteEntity extends Equatable {
  final String? id;
  final String? channel_id;
  final String? creator_id;
  final int? create_at;
  final int? update_at;
  final int? delete_at;
  final bool? is_invite_accepted;
  final bool? is_invite_confirmed;
  final String? remote_id;
  final int? last_post_update_at;
  final String? last_post_id;
  final String? last_post_create_at;
  final String? last_post_create_id;

  const SharedChannelRemoteEntity({
    this.id,
    this.channel_id,
    this.creator_id,
    this.create_at,
    this.update_at,
    this.delete_at,
    this.is_invite_accepted,
    this.is_invite_confirmed,
    this.remote_id,
    this.last_post_update_at,
    this.last_post_id,
    this.last_post_create_at,
    this.last_post_create_id,
  });

  @override
  List<Object?> get props => [
        id,
        channel_id,
        creator_id,
        create_at,
        update_at,
        delete_at,
        is_invite_accepted,
        is_invite_confirmed,
        remote_id,
        last_post_update_at,
        last_post_id,
        last_post_create_at,
        last_post_create_id,
      ];

  SharedChannelRemoteEntity copyWith({
    String? id,
    String? channel_id,
    String? creator_id,
    int? create_at,
    int? update_at,
    int? delete_at,
    bool? is_invite_accepted,
    bool? is_invite_confirmed,
    String? remote_id,
    int? last_post_update_at,
    String? last_post_id,
    String? last_post_create_at,
    String? last_post_create_id,
  }) {
    return SharedChannelRemoteEntity(
      id: id ?? this.id,
      channel_id: channel_id ?? this.channel_id,
      creator_id: creator_id ?? this.creator_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      is_invite_accepted: is_invite_accepted ?? this.is_invite_accepted,
      is_invite_confirmed: is_invite_confirmed ?? this.is_invite_confirmed,
      remote_id: remote_id ?? this.remote_id,
      last_post_update_at: last_post_update_at ?? this.last_post_update_at,
      last_post_id: last_post_id ?? this.last_post_id,
      last_post_create_at: last_post_create_at ?? this.last_post_create_at,
      last_post_create_id: last_post_create_id ?? this.last_post_create_id,
    );
  }
}
