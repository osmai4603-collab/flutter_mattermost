import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';

/// إضافة أعضاء جدد للقناة — مطابق channel_members_rhs "إضافة" في webapp:
/// قائمة مستخدمي الفريق غير الموجودين في القناة مع بحث واختيار متعدد،
/// ثم إضافتهم دفعة واحدة عبر POST /channels/{id}/members.
class AddChannelMembersModal extends StatefulWidget {
  final String channelId;
  final String teamId;

  const AddChannelMembersModal({
    super.key,
    required this.channelId,
    required this.teamId,
  });

  @override
  State<AddChannelMembersModal> createState() => _AddChannelMembersModalState();
}

class _AddChannelMembersModalState extends State<AddChannelMembersModal> {
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
      final existing = await getIt<ChannelRepository>().getChannelMembers(
        widget.channelId,
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
      await getIt<ChannelRepository>().addChannelMembers(
        widget.channelId,
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
    final l10n = AppLocalizations.of(context);
    final filtered = _candidates.where(_matches).toList();

    return GenericModal(
      title: l10n.channel_members_modalAddNew,
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
                hintText: l10n.channel_members_rhsSearch_barPlaceholder,
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
                  ? l10n.no_resultsUser_group_membersTitle
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
                    l10n.no_resultsUser_group_membersTitle,
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
      dismissLabel: l10n.channel_members_rhsAction_barDone_button,
      confirmLabel: l10n.channel_members_rhsAction_barAdd_button,
      onConfirm: _add,
    );
  }
}