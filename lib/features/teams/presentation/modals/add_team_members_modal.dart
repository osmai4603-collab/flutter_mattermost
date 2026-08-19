import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';

/// إضافة أعضاء جدد للفريق — مطابقة add_members_to_team_modal في webapp:
/// قائمة مستخدمي السيرفر غير الموجودين في الفريق مع بحث واختيار متعدد،
/// ثم إضافتهم دفعة واحدة عبر POST /teams/{id}/members/batch.
class AddTeamMembersModal extends StatefulWidget {
  final String teamId;

  const AddTeamMembersModal({super.key, required this.teamId});

  @override
  State<AddTeamMembersModal> createState() => _AddTeamMembersModalState();
}

class _AddTeamMembersModalState extends State<AddTeamMembersModal> {
  final TextEditingController _searchController = TextEditingController();
  List<UserEntity> _candidates = [];
  final Set<String> _selectedIds = {};
  bool _loading = true;
  bool _adding = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final existing = await getIt<TeamRepository>().getTeamMembers(
        widget.teamId,
        perPage: 200,
      );
      final existingIds = existing.map((m) => m.userId).toSet();
      final teamUsers = await getIt<UserRepository>().getProfilesInTeam(
        widget.teamId,
        perPage: 200,
      );
      if (!mounted) return;
      setState(() {
        _candidates = teamUsers
            .where((u) => !existingIds.contains(u.id))
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  String _displayNameOf(UserEntity user) {
    final full = '${user.firstName} ${user.lastName}'.trim();
    return full.isNotEmpty ? full : user.username;
  }

  bool _matches(UserEntity user) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return _displayNameOf(user).toLowerCase().contains(q) ||
        user.username.toLowerCase().contains(q) ||
        user.email.toLowerCase().contains(q);
  }

  Future<void> _add() async {
    if (_selectedIds.isEmpty || _adding) return;
    setState(() => _adding = true);
    try {
      await getIt<TeamRepository>().addUsersToTeam(
        widget.teamId,
        _selectedIds.toList(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final filtered = _candidates.where(_matches).toList();

    return GenericModal(
      title: 'Add Members to Team',
      width: 480,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search for people',
                hintStyle: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: theme.centerChannelColor.withValues(alpha: 0.6),
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _candidates.isEmpty
                  ? 'No more people to add'
                  : '${filtered.length} / ${_candidates.length}',
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No people found',
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final user in filtered)
                      CheckboxListTile(
                        dense: true,
                        value: _selectedIds.contains(user.id),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedIds.add(user.id);
                            } else {
                              _selectedIds.remove(user.id);
                            }
                          });
                        },
                        secondary: ProfilePicture.sm(
                          userId: user.id,
                          avatarUrl: userAvatarUrl(user.id),
                          username: user.username,
                        ),
                        title: Text(
                          _displayNameOf(user),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '@${user.username}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
      dismissLabel: 'Cancel',
      confirmLabel: 'Add',
      onConfirm: _add,
    );
  }
}
