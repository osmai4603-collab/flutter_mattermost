import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';

final class GroupUsersModel {
  final List<UserModel> members;
  final int totalMemberCount;

  const GroupUsersModel({
    required this.members,
    required this.totalMemberCount,
  });

  factory GroupUsersModel.fromMap(Map<String, dynamic> map) {
    final members = (map['members'] as List<dynamic>? ?? [])
        .map(
          (e) => UserModel.fromMap(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    return GroupUsersModel(
      members: members,
      totalMemberCount: (map['total_member_count'] as num?)?.toInt() ?? 0,
    );
  }
}
