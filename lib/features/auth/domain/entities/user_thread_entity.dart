import 'package:equatable/equatable.dart';

class UserThreadEntity extends Equatable {
  final String? id;
  final int? reply_count;
  final int? last_reply_at;
  final int? last_viewed_at;
  final List<Map<String, dynamic>>? participants;
  final Map<String, dynamic>? post;

  const UserThreadEntity({
    this.id,
    this.reply_count,
    this.last_reply_at,
    this.last_viewed_at,
    this.participants,
    this.post,
  });

  @override
  List<Object?> get props => [
        id,
        reply_count,
        last_reply_at,
        last_viewed_at,
        participants,
        post,
      ];

  UserThreadEntity copyWith({
    String? id,
    int? reply_count,
    int? last_reply_at,
    int? last_viewed_at,
    List<Map<String, dynamic>>? participants,
    Map<String, dynamic>? post,
  }) {
    return UserThreadEntity(
      id: id ?? this.id,
      reply_count: reply_count ?? this.reply_count,
      last_reply_at: last_reply_at ?? this.last_reply_at,
      last_viewed_at: last_viewed_at ?? this.last_viewed_at,
      participants: participants ?? this.participants,
      post: post ?? this.post,
    );
  }
}
