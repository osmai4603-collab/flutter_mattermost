import 'package:flutter_mattermost/features/auth/domain/entities/new_team_member_entity.dart';

final class NewTeamMemberModel extends NewTeamMemberEntity {
  const NewTeamMemberModel({
    required super.id,
    required super.username,
    required super.first_name,
    required super.last_name,
    required super.nickname,
    required super.position,
    required super.create_at,
  });

  factory NewTeamMemberModel.fromMap(Map<String, dynamic> map) {
    return NewTeamMemberModel(
      id: map["id"] as String?,
      username: map["username"] as String?,
      first_name: map["first_name"] as String?,
      last_name: map["last_name"] as String?,
      nickname: map["nickname"] as String?,
      position: map["position"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "first_name": first_name,
      "last_name": last_name,
      "nickname": nickname,
      "position": position,
      "create_at": create_at,
    };
  }

  factory NewTeamMemberModel.fromEntity(NewTeamMemberEntity entity) {
    return NewTeamMemberModel(
      id: entity.id,
      username: entity.username,
      first_name: entity.first_name,
      last_name: entity.last_name,
      nickname: entity.nickname,
      position: entity.position,
      create_at: entity.create_at,
    );
  }

  @override
  NewTeamMemberModel copyWith({
    String? id,
    String? username,
    String? first_name,
    String? last_name,
    String? nickname,
    String? position,
    int? create_at,
  }) {
    return NewTeamMemberModel(
      id: id ?? this.id,
      username: username ?? this.username,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      nickname: nickname ?? this.nickname,
      position: position ?? this.position,
      create_at: create_at ?? this.create_at,
    );
  }

  NewTeamMemberEntity toEntity() => NewTeamMemberEntity(
    id: id,
    username: username,
    first_name: first_name,
    last_name: last_name,
    nickname: nickname,
    position: position,
    create_at: create_at,
  );
}
