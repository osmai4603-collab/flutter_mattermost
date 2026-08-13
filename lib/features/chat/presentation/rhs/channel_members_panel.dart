import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/add_channel_members_modal.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';

/// لوحة أعضاء القناة — مطابقة channel_members_rhs في webapp:
/// شريط بحث + قائمة مقسومة (مسؤولو القناة / الأعضاء) بترتيب أبجدي،
/// صورة وحالة لحظية لكل عضو، ترقية/تنزيل الأدوار وإزالة الأعضاء
/// وإضافة أعضاء (للمدراء فقط)، وبطاقة ملف سريعة عند النقر على العضو.
class ChannelMembersPanel extends StatefulWidget {
  final String channelId;

  const ChannelMembersPanel({super.key, required this.channelId});

  @override
  State<ChannelMembersPanel> createState() => _ChannelMembersPanelState();
}

class _MembersData {
  final List<ChannelMemberEntity> members;
  final Map<String, UserEntity> users;

  const _MembersData(this.members, this.users);
}

class _ChannelMembersPanelState extends State<ChannelMembersPanel> {
  final TextEditingController _searchController = TextEditingController();
  Future<_MembersData>? _future;
  bool _busy = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    _future = _load();
  }

  Future<_MembersData> _load() async {
    final repository = getIt<ChannelRepository>();
    final members = await repository.getChannelMembers(
      widget.channelId,
      perPage: 200,
    );
    final ids = members.map((m) => m.userId).toList();
    var users = <String, UserEntity>{};
    if (ids.isNotEmpty) {
      try {
        final profiles = await getIt<UserRepository>().getProfilesByIds(ids);
        users = {for (final u in profiles) u.id: u};
      } catch (_) {
        // تبقى الأسماء احتياطية من معرف العضو عند فشل جلب الملفات.
      }
      if (mounted) {
        context
            .read<UserStatusBloc>()
            .add(LoadUserStatusesEvent(ids));
      }
    }
    return _MembersData(members, users);
  }

  bool _isChannelAdmin(ChannelMemberEntity member) =>
      member.roles.split(',').any((r) => r.trim() == 'channel_admin');

  bool _isCurrentUserSystemAdmin() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      return authState.user.roles
          .split(',')
          .any((r) => r.trim() == 'system_admin');
    }
    return false;
  }

  bool _isCurrentUserAdmin() {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is! ChannelsLoadedState) return false;
    final member = channelState.members[widget.channelId];
    return member != null && _isChannelAdmin(member);
  }

  bool _isCurrentUser(String userId) {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is! ChannelsLoadedState) return false;
    return channelState.userId == userId;
  }

  String? _currentTeamId() {
    final channelState = context.read<ChannelBloc>().state;
    if (channelState is ChannelsLoadedState) return channelState.teamId;
    return null;
  }

  Future<void> _openAddMembers() async {
    final teamId = _currentTeamId();
    if (teamId == null) return;
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddChannelMembersModal(
        channelId: widget.channelId,
        teamId: teamId,
      ),
    );
    if (added == true && mounted) setState(_reload);
  }

  void _openProfile(String userId) {
    showUserProfile(context, userId);
  }

  Future<void> _changeRole(ChannelMemberEntity member, bool makeAdmin) async {
    if (mounted) setState(() => _busy = true);
    try {
      await getIt<ChannelRepository>().updateChannelMemberSchemeRoles(
        widget.channelId,
        member.userId,
        schemeAdmin: makeAdmin,
      );
      if (mounted) setState(_reload);
    } catch (_) {
      // لا تغيير عند فشل الخادم.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeMember(
    ChannelMemberEntity member,
    Map<String, UserEntity> users,
  ) async {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final user = users[member.userId];
    final name = user == null ? member.userId : _displayNameOf(user);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.centerChannelBg,
        title: Text(
          l10n.channel_members_dropdownRemove_from_channel,
          style: TextStyle(color: theme.centerChannelColor),
        ),
        content: Text(
          '$name?',
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.generic_modalCancel,
              style: TextStyle(color: theme.centerChannelColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.channel_members_dropdownRemove_from_channel,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await getIt<ChannelRepository>().removeChannelMember(
        widget.channelId,
        member.userId,
      );
      if (mounted) setState(_reload);
    } catch (_) {
      // لا تغيير عند فشل الخادم.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _matchesQuery(ChannelMemberEntity member, Map<String, UserEntity> users) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final user = users[member.userId];
    if (user == null) {
      return member.userId.toLowerCase().contains(q);
    }
    return '${user.firstName} ${user.lastName}'
            .toLowerCase()
            .contains(q) ||
        user.username.toLowerCase().contains(q) ||
        user.email.toLowerCase().contains(q) ||
        user.nickname.toLowerCase().contains(q);
  }

  String _displayNameOf(UserEntity user) {
    final full = '${user.firstName} ${user.lastName}'.trim();
    return full.isNotEmpty ? full : user.username;
  }

  List<ChannelMemberEntity> _sorted(
    List<ChannelMemberEntity> list,
    Map<String, UserEntity> users,
  ) {
    final sorted = [...list];
    sorted.sort((a, b) {
      final an = users[a.userId] == null ? a.userId : _displayNameOf(users[a.userId]!);
      final bn = users[b.userId] == null ? b.userId : _displayNameOf(users[b.userId]!);
      return an.toLowerCase().compareTo(bn.toLowerCase());
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final canManage = _isCurrentUserAdmin() || _isCurrentUserSystemAdmin();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: FutureBuilder<_MembersData>(
                  future: _future,
                  builder: (context, snapshot) {
                    final count =
                        snapshot.connectionState == ConnectionState.done
                        ? (snapshot.data?.members.length ?? 0)
                        : null;
                    return Text(
                      count == null
                          ? ''
                          : l10n
                                .channel_members_rhsAction_barMembers_count_title(
                                count,
                              ),
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              if (canManage)
                MatterButton(
                  onPressed: _busy ? null : _openAddMembers,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_add_alt,
                        size: 16,
                        color: theme.buttonColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.channel_members_modalAddNew,
                        style: TextStyle(
                          color: theme.buttonColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
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
        ),
        Expanded(
          child: FutureBuilder<_MembersData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data;
              if (data == null || data.members.isEmpty) {
                return const SizedBox.shrink();
              }
              final admins = _sorted(
                data.members.where(_isChannelAdmin).toList(),
                data.users,
              ).where((m) => _matchesQuery(m, data.users)).toList();
              final members = _sorted(
                data.members.where((m) => !_isChannelAdmin(m)).toList(),
                data.users,
              ).where((m) => _matchesQuery(m, data.users)).toList();
              if (admins.isEmpty && members.isEmpty) {
                return Center(
                  child: Text(
                    l10n.no_resultsUser_group_membersTitle,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                );
              }
              return ListView(
                children: [
                  if (admins.isNotEmpty) ...[
                    _sectionHeader(
                      theme,
                      l10n.channel_members_rhsListChannel_admin_title,
                    ),
                    ...admins.map(
                      (m) =>
                          _memberRow(theme, l10n, m, data.users, canManage),
                    ),
                  ],
                  if (members.isNotEmpty) ...[
                    _sectionHeader(
                      theme,
                      l10n.channel_members_rhsListChannel_members_title,
                    ),
                    ...members.map(
                      (m) =>
                          _memberRow(theme, l10n, m, data.users, canManage),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        if (_busy) const LinearProgressIndicator(minHeight: 2),
      ],
    );
  }

  Widget _sectionHeader(MattermostColors theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: theme.centerChannelColor.withValues(alpha: 0.5),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  UserStatus? _statusOf(String userId) {
    final state = context.watch<UserStatusBloc>().state;
    if (state is UserStatusesLoadedState) return state.statuses[userId];
    return null;
  }

  Widget _memberRow(
    MattermostColors theme,
    AppLocalizations l10n,
    ChannelMemberEntity member,
    Map<String, UserEntity> users,
    bool canManage,
  ) {
    final user = users[member.userId];
    final name = user == null ? member.userId : _displayNameOf(user);
    final username = user?.username ?? member.userId;
    final isAdmin = _isChannelAdmin(member);
    final isSelf = _isCurrentUser(member.userId);
    final position = user?.position ?? '';

    final content = Row(
      children: [
        ProfilePicture.md(
          avatarUrl: userAvatarUrl(member.userId),
          username: username,
          status: _statusOf(member.userId),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.buttonBg.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusPill,
                        ),
                      ),
                      child: Text(
                        l10n.channel_members_dropdownChannel_admin,
                        style: TextStyle(
                          color: theme.buttonBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                position.isNotEmpty ? '@$username · $position' : '@$username',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.55),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final tappable = Expanded(
      child: InkWell(
        onTap: () => _openProfile(member.userId),
        hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: content,
        ),
      ),
    );

    if (!canManage || isSelf || _busy) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [tappable],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          tappable,
          MatterMenuScope(
            openUp: true,
            items: [
              MatterMenuItem(
                id: isAdmin ? 'demote' : 'promote',
                label: isAdmin
                    ? l10n.channel_members_dropdownMake_channel_member
                    : l10n.channel_members_dropdownMake_channel_admin,
                icon: Icon(
                  isAdmin ? Icons.person_outline : Icons.admin_panel_settings,
                  size: 18,
                ),
                onTap: () => _changeRole(member, !isAdmin),
              ),
              MatterMenuItem(
                id: 'remove',
                label: l10n.channel_members_dropdownRemove_from_channel,
                icon: const Icon(Icons.person_remove_outlined, size: 18),
                danger: true,
                separatorBefore: true,
                onTap: () => _removeMember(member, users),
              ),
            ],
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: theme.centerChannelColor.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}