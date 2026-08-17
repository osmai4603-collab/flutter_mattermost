import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/repositories/groups_repository.dart';
import 'package:flutter_mattermost/features/users/data/datasources/user_status_remote_data_source.dart';

/// رابط صورة العضو — مطابق `$server/api/v4/users/{id}/image`.
String _memberAvatarUrl(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}

/// نافذة بطاقة المجموعة — تظهر عند النقر على `@group-name` في الرسائل
/// (نظير UserGroupPopover في webapp): اسم المجموعة + عدد الأعضاء
/// + قائمة الأعضاء مع صورهم وحالتهم.
Future<void> showGroupPopover(BuildContext context, GroupEntity group) {
  return showDialog<void>(
    context: context,
    builder: (_) => _GroupPopover(group: group),
  );
}

class _GroupPopover extends StatefulWidget {
  final GroupEntity group;

  const _GroupPopover({required this.group});

  @override
  State<_GroupPopover> createState() => _GroupPopoverState();
}

class _GroupPopoverState extends State<_GroupPopover> {
  List<UserModel> _members = const [];
  Map<String, UserStatus> _statuses = const {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final users = await getIt<GroupsRepository>().getGroupUsers(
        groupId: widget.group.id,
        perPage: 60,
      );
      final statuses = await getIt<UserStatusRemoteDataSource>()
          .getStatusesByIds(users.members.take(50).map((u) => u.id).toList());
      if (!mounted) return;
      setState(() {
        _members = users.members;
        _statuses = {
          for (final s in statuses) s.userId: s.status,
        };
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _displayName(UserModel user) {
    final nickname = user.nickname.trim();
    if (nickname.isNotEmpty) return nickname;
    final full = '${user.firstName} ${user.lastName}'.trim();
    if (full.isNotEmpty) return full;
    return user.username;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final group = widget.group;
    final memberCount = group.memberCount > 0
        ? group.memberCount
        : (_members.isNotEmpty ? _members.length : null);

    return Dialog(
      child: Container(
        width: 360,
        constraints: const BoxConstraints(maxHeight: 480),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.linkColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.group_outlined,
                    size: 24,
                    color: theme.linkColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.displayName.isNotEmpty
                            ? group.displayName
                            : group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@${group.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.linkColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (memberCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.centerChannelColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$memberCount',
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            if (group.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                group.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                  fontSize: 12.5,
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text(
              'Members',
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: _loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Could not load members',
                          style: TextStyle(
                            color: theme.errorTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : _members.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No members',
                          style: TextStyle(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.5,
                            ),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _members.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final user = _members[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              ProfilePicture(
                                userId: user.id,
                                avatarUrl: _memberAvatarUrl(user.id),
                                username: user.username,
                                status: _statuses[user.id],
                                size: 28,
                                showStatus: true,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _displayName(user),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: theme.centerChannelColor,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.username}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.centerChannelColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
