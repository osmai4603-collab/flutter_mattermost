import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// تعديل القناة — مطابق ChannelSettingsModal في webapp:
/// تبويبات Info (الاسم/الغرض/الرأس) / Privacy (خاص/عام) / Archive.
class ChannelSettingsModal extends StatefulWidget {
  /// القناة المستهدفة — عند غيابها تُستخدم القناة المحددة حالياً.
  final ChannelEntity? channel;

  const ChannelSettingsModal({super.key, this.channel});

  @override
  State<ChannelSettingsModal> createState() => _ChannelSettingsModalState();
}

class _ChannelSettingsModalState extends State<ChannelSettingsModal> {
  bool _saving = false;
  bool _archiving = false;
  String? _error;
  String? _notice;

  late final TextEditingController _nameController;
  late final TextEditingController _purposeController;
  late final TextEditingController _headerController;

  ChannelEntity? _channel;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChannelBloc>().state;
    _channel =
        widget.channel ??
        (state is ChannelsLoadedState ? state.selectedChannel : null);
    final channel = _channel;
    _nameController = TextEditingController(text: channel?.name ?? '');
    _purposeController = TextEditingController(text: channel?.purpose ?? '');
    _headerController = TextEditingController(text: channel?.header ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _purposeController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Future<void> _saveGeneral() async {
    final channel = _channel;
    if (channel == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final channelBloc = context.read<ChannelBloc>();
      await getIt<ChannelRepository>().updateChannel(
        channel.id,
        name: _nameController.text.trim(),
        displayName: _nameController.text.trim(),
        purpose: _purposeController.text.trim(),
        header: _headerController.text.trim(),
      );
      final updated = channel.copyWith(
        name: _nameController.text.trim(),
        displayName: _nameController.text.trim(),
        purpose: _purposeController.text.trim(),
        header: _headerController.text.trim(),
      );
      channelBloc.add(UpdateChannelEvent(updated));
      if (mounted) {
        setState(() {
          _saving = false;
          _notice = 'Saved';
          _channel = updated;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Save failed';
        });
      }
    }
  }

  Future<void> _changePrivacy(bool makePrivate) async {
    final channel = _channel;
    if (channel == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final channelBloc = context.read<ChannelBloc>();
      final updated = await getIt<ChannelRepository>().updateChannelPrivacy(
        channel.id,
        makePrivate ? 'P' : 'O',
      );
      channelBloc.add(UpdateChannelEvent(updated));
      if (mounted) {
        setState(() {
          _saving = false;
          _notice = 'Saved';
          _channel = updated;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Save failed';
        });
      }
    }
  }

  Future<void> _archive() async {
    final channel = _channel;
    if (channel == null) return;
    setState(() {
      _archiving = true;
      _error = null;
    });
    try {
      await getIt<ChannelRepository>().deleteChannel(channel.id);
      if (!mounted) return;
      context.read<ChannelBloc>().add(ArchiveChannelEvent(channel));
      final teamState = context.read<TeamBloc>().state;
      final teamName = teamState is TeamsLoadedState
          ? teamState.selectedTeam?.name
          : null;
      if (teamName != null) context.go('/$teamName/channels/town-square');
    } catch (_) {
      if (mounted) {
        setState(() {
          _archiving = false;
          _error = 'Archive failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final channel = _channel;

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 560),
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.channelSettingsTitle,
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
            if (channel != null)
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: l10n.channelSettingsGeneral),
                        Tab(text: l10n.channelSettingsPrivacy),
                        Tab(text: l10n.channelSettingsArchive),
                      ],
                      labelColor: theme.buttonBg,
                      unselectedLabelColor: theme.centerChannelColor.withValues(
                        alpha: 0.6,
                      ),
                      indicatorColor: theme.buttonBg,
                      dividerColor: theme.centerChannelColor.withValues(
                        alpha: 0.1,
                      ),
                    ),
                    SizedBox(
                      height: 420,
                      child: TabBarView(
                        children: [
                          _buildGeneralTab(theme, l10n),
                          _buildPrivacyTab(theme, l10n),
                          _buildArchiveTab(theme, l10n),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No channel selected',
                  style: TextStyle(color: theme.centerChannelColor),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
            if (_notice != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _notice!,
                      style: const TextStyle(color: Colors.green, fontSize: 13),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab(MattermostColors theme, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _label(l10n.channelSettingsName),
        TextField(
          controller: _nameController,
          style: TextStyle(color: theme.centerChannelColor),
          decoration: InputDecoration(
            hintText: l10n.channel_settings_modalNamePlaceholder,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _label(l10n.channelSettingsPurpose),
        TextField(
          controller: _purposeController,
          maxLines: 2,
          style: TextStyle(color: theme.centerChannelColor),
          decoration: InputDecoration(
            hintText: l10n.channel_settings_modalPurposePlaceholder,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _label(l10n.channelSettingsHeader),
        TextField(
          controller: _headerController,
          maxLines: 2,
          style: TextStyle(color: theme.centerChannelColor),
          decoration: InputDecoration(
            hintText: l10n.channel_settings_modalHeaderPlaceholder,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: _saving ? null : _saveGeneral,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonBg,
              foregroundColor: theme.buttonColor,
            ),
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    l10n.channelSettingsSave,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyTab(MattermostColors theme, AppLocalizations l10n) {
    final channel = _channel!;
    final isPrivate = channel.type == ChannelType.private;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.channelSettingsPrivacyDescription,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        _privacyOption(
          theme,
          icon: Icons.lock_outline,
          title: l10n.channelSettingsPrivate,
          subtitle: l10n.channelSettingsPrivateDescription,
          selected: isPrivate,
          onTap: () => _changePrivacy(true),
        ),
        const SizedBox(height: 12),
        _privacyOption(
          theme,
          icon: Icons.public,
          title: l10n.channelSettingsPublic,
          subtitle: l10n.channelSettingsPublicDescription,
          selected: !isPrivate,
          onTap: () => _changePrivacy(false),
        ),
      ],
    );
  }

  Widget _buildArchiveTab(MattermostColors theme, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.channelSettingsArchiveDescription,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: _archiving ? null : _archive,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
            ),
            child: _archiving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    l10n.channelSettingsArchiveChannel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _privacyOption(
    MattermostColors theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? theme.buttonBg
                : theme.centerChannelColor.withValues(alpha: 0.16),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? theme.buttonBg
                  : theme.centerChannelColor.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, size: 20, color: theme.buttonBg),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
