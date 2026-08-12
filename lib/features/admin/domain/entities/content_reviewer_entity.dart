import 'package:equatable/equatable.dart';

class ContentReviewerEntity extends Equatable {
  final String? user_id;
  final String? username;
  final String? nickname;
  final String? first_name;
  final String? last_name;
  final String? email;
  final int? create_at;
  const ContentReviewerEntity({
    this.user_id,
    this.username,
    this.nickname,
    this.first_name,
    this.last_name,
    this.email,
    this.create_at,
  });

  @override
  List<Object?> get props => [
      user_id,
      username,
      nickname,
      first_name,
      last_name,
      email,
      create_at,
  ];
}
