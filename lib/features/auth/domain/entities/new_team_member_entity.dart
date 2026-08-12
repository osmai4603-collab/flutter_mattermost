import 'package:equatable/equatable.dart';

class NewTeamMemberEntity extends Equatable {
  final String? id;
  final String? username;
  final String? first_name;
  final String? last_name;
  final String? nickname;
  final String? position;
  final int? create_at;

  const NewTeamMemberEntity({
    this.id,
    this.username,
    this.first_name,
    this.last_name,
    this.nickname,
    this.position,
    this.create_at,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        first_name,
        last_name,
        nickname,
        position,
        create_at,
      ];

  NewTeamMemberEntity copyWith({
    String? id,
    String? username,
    String? first_name,
    String? last_name,
    String? nickname,
    String? position,
    int? create_at,
  }) {
    return NewTeamMemberEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      nickname: nickname ?? this.nickname,
      position: position ?? this.position,
      create_at: create_at ?? this.create_at,
    );
  }
}
