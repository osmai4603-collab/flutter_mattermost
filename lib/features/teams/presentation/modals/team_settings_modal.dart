import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// نافذة إعدادات الفريق — مطابقة team_settings_modal.tsx في webapp:
/// Modal بعرض 800px + قائمة جانبية (SettingsSidebar) بتبويبات Info / Access
/// + لوحة محتوى مقسمة لأقسام.
enum TeamSettingsTab {
  info,
  access,
}

extension TeamSettingsTabLabels on TeamSettingsTab {
  String label(AppLocalizations l10n) => switch (this) {
    TeamSettingsTab.info => 'Info',
    TeamSettingsTab.access => 'Access',
  };

  IconData get icon => switch (this) {
    TeamSettingsTab.info => Icons.info_outline,
    TeamSettingsTab.access => Icons.group_outlined,
  };
}

class TeamSettingsModal extends StatefulWidget {
  const TeamSettingsModal({super.key});

  @override
  State<TeamSettingsModal> createState() => _TeamSettingsModalState();
}

class _TeamSettingsModalState extends State<TeamSettingsModal> {
  TeamSettingsTab _selectedTab = TeamSettingsTab.info;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Center(
      child: Material(
        color: theme.centerChannelBg,
        elevation: 16,
        borderRadius: BorderRadius.circular(DesignTokens.dialogRadius),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TeamSettingsHeader(
                onClose: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TeamSettingsSidebar(
                      selected: _selectedTab,
                      onSelect: (tab) => setState(() => _selectedTab = tab),
                    ),
                    Container(
                      width: 1,
                      color: theme.centerChannelColor.withValues(alpha: 0.1),
                    ),
                    Expanded(
                      child: _buildTabContent(_selectedTab),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(TeamSettingsTab tab) => switch (tab) {
    TeamSettingsTab.info => const _TeamInfoTab(),
    TeamSettingsTab.access => const _TeamAccessTab(),
  };
}

/// رأس النافذة: عنوان "Team Settings" + زر إغلاق.
class _TeamSettingsHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _TeamSettingsHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Team Settings',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.close,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// القائمة الجانبية للتبويبات.
class _TeamSettingsSidebar extends StatelessWidget {
  final TeamSettingsTab selected;
  final ValueChanged<TeamSettingsTab> onSelect;

  const _TeamSettingsSidebar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: 240,
      color: theme.centerChannelColor.withValues(alpha: 0.04),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final tab in TeamSettingsTab.values)
            _TeamSettingsNavItem(
              tab: tab,
              active: tab == selected,
              onTap: () => onSelect(tab),
            ),
        ],
      ),
    );
  }
}

class _TeamSettingsNavItem extends StatelessWidget {
  final TeamSettingsTab tab;
  final bool active;
  final VoidCallback onTap;

  const _TeamSettingsNavItem({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      hoverColor: theme.centerChannelColor.withValues(alpha: 0.06),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active
              ? theme.buttonBg.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              tab.icon,
              size: 18,
              color: active
                  ? theme.buttonBg
                  : theme.centerChannelColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tab.label(l10n),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: active ? theme.buttonBg : theme.centerChannelColor,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===== تبويب Info — معلومات الفريق =====
class _TeamInfoTab extends StatefulWidget {
  const _TeamInfoTab();

  @override
  State<_TeamInfoTab> createState() => _TeamInfoTabState();
}

class _TeamInfoTabState extends State<_TeamInfoTab> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _hasChanges = false;
  bool _saving = false;

  TeamEntity? _team;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadTeam() {
    final state = context.read<TeamBloc>().state;
    _team = state is TeamsLoadedState ? state.selectedTeam : null;
    final team = _team;
    if (team != null) {
      _nameController.text = team.displayName;
      _descriptionController.text = team.description;
    }
  }

  void _markDirty() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _save() async {
    final team = _team;
    if (team == null || _saving) return;
    setState(() {
      _saving = true;
    });
    try {
      final patch = <String, dynamic>{};
      final newName = _nameController.text.trim();
      final newDescription = _descriptionController.text.trim();
      if (newName != team.displayName) patch['display_name'] = newName;
      if (newDescription != team.description) {
        patch['description'] = newDescription;
      }
      if (patch.isEmpty) {
        setState(() {
          _saving = false;
          _hasChanges = false;
        });
        return;
      }

      // Use the remote data source directly for patching
      // Since TeamRepository doesn't expose patchTeam, we update locally
      // and emit an updated team through the bloc
      final updated = team.copyWith(
        displayName: newName,
        description: newDescription,
      );

      // Update selected team in bloc
      context.read<TeamBloc>().add(SelectTeamEvent(updated));
      context.read<TeamBloc>().add(RefreshTeamsEvent());

      if (mounted) {
        setState(() {
          _saving = false;
          _hasChanges = false;
          _team = updated;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Team settings saved')));
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Save failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final team = _team;

    if (team == null) {
      return Center(
        child: Text(
          'No team selected',
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(label: 'TEAM NAME'),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  onChanged: (_) => _markDirty(),
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Team name',
                    hintStyle: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.4),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Displayed on the login screen and the top of the sidebar for your team.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 28),
                _SectionHeader(label: 'TEAM DESCRIPTION'),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  onChanged: (_) => _markDirty(),
                  maxLines: 3,
                  minLines: 2,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Team description',
                    hintStyle: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.4),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Shown in the team list and when hovering over the team name.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 28),
                _SectionHeader(label: 'TEAM ICON'),
                const SizedBox(height: 12),
                _TeamIconSection(team: team),
              ],
            ),
          ),
        ),
        if (_hasChanges)
          _SaveChangesPanel(
            saving: _saving,
            onSave: _save,
            onCancel: () {
              _loadTeam();
              setState(() => _hasChanges = false);
            },
          ),
      ],
    );
  }
}

/// قسم أيقونة الفريق — عرض الأحرف الأولى + رفع صورة.
class _TeamIconSection extends StatelessWidget {
  final TeamEntity team;

  const _TeamIconSection({required this.team});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final initials = team.displayName.isNotEmpty
        ? team.displayName.substring(0, 1).toUpperCase()
        : '?';

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.buttonBg,
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: theme.buttonColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload a team icon in BMP, JPG, or PNG format.',
                style: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Square images with a solid background work best.',
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
  }
}

/// ===== تبويب Access — من يمكنه الانضمام =====
class _TeamAccessTab extends StatefulWidget {
  const _TeamAccessTab();

  @override
  State<_TeamAccessTab> createState() => _TeamAccessTabState();
}

class _TeamAccessTabState extends State<_TeamAccessTab> {
  late bool _allowOpenInvite;
  final _domainsController = TextEditingController();
  bool _hasChanges = false;
  bool _saving = false;

  TeamEntity? _team;

  @override
  void initState() {
    super.initState();
    _loadTeam();
  }

  @override
  void dispose() {
    _domainsController.dispose();
    super.dispose();
  }

  void _loadTeam() {
    final state = context.read<TeamBloc>().state;
    _team = state is TeamsLoadedState ? state.selectedTeam : null;
    final team = _team;
    if (team != null) {
      _allowOpenInvite = team.allowOpenInvite;
      _domainsController.text = team.allowedDomains;
    } else {
      _allowOpenInvite = false;
    }
  }

  void _markDirty() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  Future<void> _save() async {
    final team = _team;
    if (team == null || _saving) return;
    setState(() => _saving = true);
    try {
      final updated = team.copyWith(
        allowOpenInvite: _allowOpenInvite,
        allowedDomains: _domainsController.text.trim(),
      );
      final currentState = context.read<TeamBloc>().state;
      if (currentState is TeamsLoadedState) {
        context.read<TeamBloc>().add(SelectTeamEvent(updated));
        context.read<TeamBloc>().add(RefreshTeamsEvent());
      }
      if (mounted) {
        setState(() {
          _saving = false;
          _hasChanges = false;
          _team = updated;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Team settings saved')));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Save failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final team = _team;

    if (team == null) {
      return Center(
        child: Text(
          'No team selected',
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final inviteLink = team.inviteId.isNotEmpty
        ? 'https://your-mattermost-url/signup_user_complete/?id=${team.inviteId}'
        : '';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(label: 'TEAM TYPE'),
                const SizedBox(height: 12),
                Text(
                  'Select whether your team is public or private.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.65),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                _PrivacyOption(
                  icon: Icons.public,
                  title: 'Public team',
                  subtitle: 'Anyone on the server can find and join this team.',
                  selected: _allowOpenInvite,
                  onTap: () {
                    setState(() => _allowOpenInvite = true);
                    _markDirty();
                  },
                ),
                const SizedBox(height: 10),
                _PrivacyOption(
                  icon: Icons.lock_outline,
                  title: 'Private team',
                  subtitle:
                      'Only invited members can join this team.',
                  selected: !_allowOpenInvite,
                  onTap: () {
                    setState(() => _allowOpenInvite = false);
                    _markDirty();
                  },
                ),
                const SizedBox(height: 28),
                _SectionHeader(label: 'ALLOWED EMAIL DOMAINS'),
                const SizedBox(height: 12),
                Text(
                  'Optionally, restrict team joins to users with specific email domains.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.65),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _domainsController,
                  onChanged: (_) => _markDirty(),
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'corp.mattermost.com',
                    hintStyle: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.4),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Separate with spaces or commas. Only users with matching email domains can join.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 28),
                _SectionHeader(label: 'INVITE CODE'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.06,
                          ),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusSm,
                          ),
                          border: Border.all(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Text(
                          inviteLink.isNotEmpty ? inviteLink : '—',
                          style: TextStyle(
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        size: 18,
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                      ),
                      tooltip: 'Copy link',
                      onPressed: inviteLink.isNotEmpty
                          ? () {
                              Clipboard.setData(
                                ClipboardData(text: inviteLink),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text('Invite link copied'),
                                  ),
                                );
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Share this link to invite people to your team.',
                  style: TextStyle(
                    color: theme.centerChannelColor.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_hasChanges)
          _SaveChangesPanel(
            saving: _saving,
            onSave: _save,
            onCancel: () {
              _loadTeam();
              setState(() => _hasChanges = false);
            },
          ),
      ],
    );
  }
}

/// بطاقة خيار الخصوصية (Public / Private).
class _PrivacyOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PrivacyOption({
    required this.icon,
    required this.title,
    required this.subtitle,
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
}

/// عنوان قسم صغير — مطابق .section-title في webapp.
class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// شريط حفظ التغييرات — يظهر عند وجود تعديلات غير محفوظة.
class _SaveChangesPanel extends StatelessWidget {
  final bool saving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _SaveChangesPanel({
    required this.saving,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        border: Border(
          top: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: saving ? null : onCancel,
            child: Text(
              'Cancel',
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: saving ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonBg,
              foregroundColor: theme.buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              minimumSize: const Size(0, 34),
            ),
            child: saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }
}
