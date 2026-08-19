import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/app/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';

/// الحد الأقصى لعدد الأشخاص في محادثة جماعية (مطابق webapp).
const int kMaxGroupMessageMembers = 8;

/// فتح رسالة مباشرة/محادثة جماعية — مطابق more_direct_channels في webapp:
/// بحث عن مستخدم → إنشاء DM فردي، أو اختيار عدة أشخاص (≤ 8) → GM،
/// أو بدء محادثة مع النفس.
class DirectChannelsModal extends StatefulWidget {
  const DirectChannelsModal({super.key});

  @override
  State<DirectChannelsModal> createState() => _DirectChannelsModalState();
}

class _DirectChannelsModalState extends State<DirectChannelsModal> {
  final TextEditingController _controller = TextEditingController();
  List<UserModel> _users = [];
  UserModel? _me;
  bool _loading = false;
  bool _opening = false;
  String? _error;
  bool _groupMode = false;
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadMe() async {
    try {
      final me = await getIt<UsersRemoteDataSource>().getMe();
      if (mounted) setState(() => _me = me);
    } catch (_) {}
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _users = []);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await getIt<UsersRemoteDataSource>().autocompleteUsers(
        query.trim(),
      );
      if (!mounted) return;
      setState(() {
        _users = users.where((u) => u.id != _me?.id).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Search failed';
      });
    }
  }

  void _toggleSelection(UserModel user) {
    setState(() {
      if (_selectedIds.contains(user.id)) {
        _selectedIds.remove(user.id);
      } else if (_selectedIds.length < kMaxGroupMessageMembers) {
        _selectedIds.add(user.id);
      }
    });
  }

  Future<void> _openChannel(ChannelEntity channel) async {
    if (!mounted) return;
    context.read<ChannelBloc>().add(UpsertChannelEvent(channel));
    context.read<ChannelBloc>().add(SelectChannelEvent(channel));
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    final route = teamName != null
        ? '/$teamName/channels/${channel.name}'
        : null;
    Navigator.of(context).pop();
    if (route != null) {
      if (context.mounted) {
        context.go(route);
      } else {
        appRouter.go(route);
      }
    }
  }

  Future<void> _open(UserModel user) async {
    setState(() => _opening = true);
    try {
      final channel = await getIt<ChannelRepository>().createDirectChannel([
        _me?.id ?? '',
        user.id,
      ]);
      if (!mounted) return;
      await _openChannel(channel);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _opening = false;
        _error = 'Failed to open direct message: $e';
      });
    }
  }

  Future<void> _openSelf() async {
    final me = _me;
    if (me == null) return;
    setState(() => _opening = true);
    try {
      final channel = await getIt<ChannelRepository>().createDirectChannel([
        me.id,
        me.id,
      ]);
      if (!mounted) return;
      await _openChannel(channel);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _opening = false;
        _error = 'Failed to open direct message: $e';
      });
    }
  }

  Future<void> _startGroup() async {
    if (_selectedIds.length < 2) return;
    setState(() => _opening = true);
    try {
      final selected = _users
          .where((u) => _selectedIds.contains(u.id))
          .toList();
      if (selected.length < 2) return;
      final channel = await getIt<ChannelRepository>().createGroupChannel([
        for (final u in selected) u.id,
      ]);
      if (!mounted) return;
      await _openChannel(channel);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _opening = false;
        _error = 'Failed to start group message: $e';
      });
    }
  }

  List<ChannelEntity> _existingDirects() {
    final state = context.read<ChannelBloc>().state;
    if (state is! ChannelsLoadedState) return const [];
    return [
      for (final c in state.channels)
        if (c.type == .direct || c.type == .group) c,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: SizedBox(
        width: 560,
        height: 480,
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.more_direct_channelsTitle,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _ModeToggle(
                    label: l10n.more_direct_channelsSingleMode,
                    selected: !_groupMode,
                    onTap: () => setState(() {
                      _groupMode = false;
                      _selectedIds.clear();
                    }),
                  ),
                  const SizedBox(width: 8),
                  _ModeToggle(
                    label: l10n.more_direct_channelsGroupMode,
                    selected: _groupMode,
                    onTap: () => setState(() {
                      _groupMode = true;
                      _selectedIds.clear();
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _search,
                style: TextStyle(color: theme.centerChannelColor),
                decoration: InputDecoration(
                  hintText: l10n.more_direct_channelsPlaceholder,
                  hintStyle: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                    borderSide: BorderSide(
                      color: theme.centerChannelColor.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            if (_groupMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  l10n.more_direct_channelsMaxGroup(kMaxGroupMessageMembers),
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        if (_controller.text.trim().isEmpty)
                          ..._buildEmptyState(theme, l10n)
                        else if (_groupMode)
                          for (final user in _users)
                            _buildUserRow(theme, l10n, user, groupMode: true)
                        else ...[
                          for (final user in _users)
                            _buildUserRow(theme, l10n, user, groupMode: false),
                          if (_users.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  l10n.more_direct_channelsNoResults,
                                  style: TextStyle(
                                    color: theme.centerChannelColor.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
            ),
            if (_groupMode) ...[
              const Divider(height: 1),
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      l10n.more_direct_channelsSelected(_selectedIds.length),
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _opening || _selectedIds.length < 2
                          ? null
                          : _startGroup,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.buttonBg,
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm,
                          ),
                        ),
                        child: Text(
                          _opening
                              ? '...'
                              : l10n.more_direct_channelsStartGroup,
                          style: TextStyle(
                            color: theme.buttonColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmptyState(MattermostColors theme, AppLocalizations l10n) {
    final directs = _existingDirects();
    return [
      if (!_groupMode && _me != null)
        ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: theme.centerChannelColor.withValues(alpha: 0.08),
            child: Icon(
              Icons.person,
              size: 18,
              color: theme.centerChannelColor.withValues(alpha: 0.7),
            ),
          ),
          title: Text(
            l10n.more_direct_channelsMessageYourself,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            l10n.more_direct_channelsSelfHint,
            style: TextStyle(
              color: theme.centerChannelColor.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          onTap: _opening ? null : _openSelf,
        ),
      if (directs.isEmpty && _me == null)
        Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              l10n.more_direct_channelsHint,
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        )
      else if (directs.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            l10n.more_direct_channelsExisting,
            style: TextStyle(
              color: theme.centerChannelColor.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        for (final channel in directs)
          ListTile(
            dense: true,
            leading: Icon(
              channel.type == .group
                  ? Icons.people_outline
                  : Icons.alternate_email,
              size: 20,
              color: theme.centerChannelColor.withValues(alpha: 0.5),
            ),
            title: Text(
              channel.displayName,
              style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
            ),
            onTap: () => _openChannel(channel),
          ),
      ],
    ];
  }

  Widget _buildUserRow(
    MattermostColors theme,
    AppLocalizations l10n,
    UserModel user, {
    required bool groupMode,
  }) {
    final selected = _selectedIds.contains(user.id);
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: theme.centerChannelColor.withValues(alpha: 0.08),
        child: Text(
          (user.firstName.isNotEmpty
                  ? user.firstName[0]
                  : user.username.isNotEmpty
                  ? user.username[0]
                  : '?')
              .toUpperCase(),
          style: TextStyle(fontSize: 14, color: theme.centerChannelColor),
        ),
      ),
      title: Text(
        _displayName(user),
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
      ),
      subtitle: Text(
        '@${user.username}',
        style: TextStyle(
          color: theme.centerChannelColor.withValues(alpha: 0.5),
          fontSize: 12,
        ),
      ),
      trailing: groupMode
          ? Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected
                  ? theme.mentionBg
                  : theme.centerChannelColor.withValues(alpha: 0.4),
            )
          : null,
      onTap: _opening
          ? null
          : groupMode
          ? () => _toggleSelection(user)
          : () => _open(user),
    );
  }

  String _displayName(UserModel user) {
    if (user.firstName.isNotEmpty || user.lastName.isNotEmpty) {
      return '${user.firstName} ${user.lastName}'.trim();
    }
    return user.username;
  }
}

class _ModeToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.buttonBg
              : theme.centerChannelColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? theme.buttonColor : theme.centerChannelColor,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
