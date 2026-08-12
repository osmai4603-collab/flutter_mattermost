import 'package:equatable/equatable.dart';

class RecapEntity extends Equatable {
  final String? id;
  final String? user_id;
  final String? title;
  final int? create_at;
  final int? update_at;
  final int? delete_at;
  final int? read_at;
  final int? viewed_at;
  final int? total_message_count;
  final String? status;
  final String? bot_id;
  final List<Map<String, dynamic>>? channels;

  const RecapEntity({
    this.id,
    this.user_id,
    this.title,
    this.create_at,
    this.update_at,
    this.delete_at,
    this.read_at,
    this.viewed_at,
    this.total_message_count,
    this.status,
    this.bot_id,
    this.channels,
  });

  @override
  List<Object?> get props => [
        id,
        user_id,
        title,
        create_at,
        update_at,
        delete_at,
        read_at,
        viewed_at,
        total_message_count,
        status,
        bot_id,
        channels,
      ];

  RecapEntity copyWith({
    String? id,
    String? user_id,
    String? title,
    int? create_at,
    int? update_at,
    int? delete_at,
    int? read_at,
    int? viewed_at,
    int? total_message_count,
    String? status,
    String? bot_id,
    List<Map<String, dynamic>>? channels,
  }) {
    return RecapEntity(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      read_at: read_at ?? this.read_at,
      viewed_at: viewed_at ?? this.viewed_at,
      total_message_count: total_message_count ?? this.total_message_count,
      status: status ?? this.status,
      bot_id: bot_id ?? this.bot_id,
      channels: channels ?? this.channels,
    );
  }
}
