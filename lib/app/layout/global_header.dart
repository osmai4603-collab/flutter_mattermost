import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/i18n/app_settings_cubit.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';
import 'package:go_router/go_router.dart';

/// الشريط العلوي العام — مطابق components/global_header في webapp:
/// ارتفاع 44px، خلفية --sidebar-teambar-bg، نص rgba(sidebar-text, 0.64).
class GlobalHeader extends StatelessWidget {
  const GlobalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: DesignTokens.globalHeaderHeight,
      padding: const EdgeInsets.only(left: 8, right: 4),
      color: theme.sidebarTeamBarBg,
      child: Row(
        children: [
          _ProductMenuButton(l10n: l10n),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Align(child: _GlobalSearchNav(l10n: l10n)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _RightIconButton(
                  icon: Icons.forum_outlined,
                  tooltip: l10n.globalThreadsSidebarLink,
                  toggled: false,
                  onTap: () {
                    final teamState = context.read<TeamBloc>().state;
                    final teamName = teamState is TeamsLoadedState
                        ? teamState.selectedTeam?.name
                        : null;
                    if (teamName != null) {
                      context.go('/$teamName/threads');
                    }
                  },
                ),
                _RightIconButton(
                  icon: Icons.alternate_email,
                  tooltip: l10n.sidebar_right_menuRecentMentions,
                  toggled: false,
                  onTap: () {
                    context.read<RhsBloc>().add(ShowMentionsEvent());
                  },
                ),
                _RightIconButton(
                  icon: Icons.bookmark_border,
                  tooltip: l10n.postMenuFlag,
                  toggled: false,
                  onTap: () {
                    context.read<RhsBloc>().add(ShowFlaggedPostsEvent());
                  },
                ),
                _RightIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: l10n.global_headerProductSettings,
                  toggled: false,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                const _UserAccountMenuButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// زر منتج Channels (أيقونة + اسم المنتج) — منتجات webapp.
class _ProductMenuButton extends StatelessWidget {
  final AppLocalizations l10n;
  const _ProductMenuButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textColor = theme.sidebarText.withValues(alpha: 0.64);
    return Tooltip(
      message: l10n.global_headerProductSwitchMenu,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          hoverColor: theme.sidebarText.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 3, 6, 3),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                Icon(
                  Icons.dashboard_customize_rounded,
                  size: 20,
                  color: textColor,
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/images/mattermost.ico',
                  width: 18,
                  height: 18,
                  colorBlendMode: .saturation,
                ),
                const SizedBox(width: 4),
                Text(
                  'Mattermost',
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: .symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: theme.mentionColor,
                    borderRadius: .circular(4),
                  ),
                  child: Text(
                    'Team Edition'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: .w400,
                      color: theme.mentionBg.withValues(alpha: 0.60),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مربع البحث في منتصف الـ header (webapp NewSearch -> Quick Switch).
class _GlobalSearchNav extends StatelessWidget {
  final AppLocalizations l10n;
  const _GlobalSearchNav({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    const maxWidth = 432.0;
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: InkWell(
          onTap: () => showQuickSwitcher(context),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.sidebarText.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  size: 16,
                  color: theme.sidebarText.withValues(alpha: 0.64),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.search_barSearch,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.sidebarText.withValues(alpha: 0.64),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// زر أيقونة في الـ header (16px) — يطابق header_icon_button.scss:
/// padding 6px، radius 4، opacity النص 0.56، hover 0.08/0.72.
class _RightIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool toggled;
  final VoidCallback onTap;

  const _RightIconButton({
    required this.icon,
    required this.tooltip,
    required this.toggled,
    required this.onTap,
  });

  @override
  State<_RightIconButton> createState() => _RightIconButtonState();
}

class _RightIconButtonState extends State<_RightIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final base = theme.sidebarText;
    final opacity = widget.toggled ? 1.0 : (_hovered ? 0.72 : 0.56);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: AnimatedContainer(
            duration: DesignTokens.hoverFadeDuration,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.toggled
                  ? base.withValues(alpha: 0.8)
                  : _hovered
                  ? base.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: widget.toggled
                  ? theme.sidebarTeamBarBg
                  : base.withValues(alpha: opacity),
            ),
          ),
        ),
      ),
    );
  }
}

/// زر حساب المستخدم (أفاتار 24 + حالة) — يطابق user_account_menuButton.
class _UserAccountMenuButton extends StatelessWidget {
  const _UserAccountMenuButton();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;

    final statusBloc = context.read<UserStatusBloc>();
    final statusState = statusBloc.state;
    final myStatus = statusState is UserStatusesLoadedState
        ? statusState.statusOf('me')
        : UserStatus.online;

    return MatterMenuScope(
      openUp: false,
      items: [
        MatterMenuItem(
          id: 'name',
          label: user?.firstName ?? user?.username ?? '',
          onTap: () {},
        ),
        MatterMenuItem(
          id: 'custom_status',
          label: l10n.userAccountMenuSetCustomStatus,
          icon: const Icon(Icons.emoji_emotions_outlined, size: 18),
          onTap: () {},
        ),
        MatterMenuItem(
          id: 'status_online',
          label: l10n.statusSetOnline,
          icon: const Icon(Icons.circle, size: 12, color: Colors.green),
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.online)),
        ),
        MatterMenuItem(
          id: 'status_away',
          label: l10n.statusSetAway,
          icon: const Icon(Icons.circle, size: 12, color: Colors.orange),
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.away)),
        ),
        MatterMenuItem(
          id: 'status_dnd',
          label: l10n.statusSetDnd,
          icon: const Icon(Icons.circle, size: 12, color: Colors.red),
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.dnd)),
        ),
        MatterMenuItem(
          id: 'status_offline',
          label: l10n.statusSetOffline,
          icon: const Icon(Icons.circle, size: 12, color: Colors.grey),
          onTap: () =>
              statusBloc.add(const SetMyUserStatusEvent(UserStatus.offline)),
        ),
        MatterMenuItem(
          id: 'profile',
          label: l10n.userAccountMenuProfile,
          icon: const Icon(Icons.account_circle_outlined, size: 18),
          separatorBefore: true,
          onTap: () {},
        ),
        MatterMenuItem(
          id: 'settings',
          label: l10n.global_headerProductSettings,
          icon: const Icon(Icons.settings_outlined, size: 18),
          onTap: () {},
        ),
        MatterMenuItem(
          id: 'theme',
          label: l10n.settingsThemeTitle,
          icon: const Icon(Icons.brightness_6_outlined, size: 18),
          onTap: () => context.read<AppSettingsCubit>().toggleThemeMode(),
        ),
        MatterMenuItem(
          id: 'logout',
          label: l10n.statusLogout,
          icon: const Icon(Icons.logout, size: 18),
          separatorBefore: true,
          onTap: () => context.read<AuthBloc>().add(LogoutRequestedEvent()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            ProfilePicture.sm(
              username: user?.username ?? '?',
              avatarUrl: null,
              status: myStatus,
              showStatus: true,
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.expand_more,
              size: 16,
              color: theme.sidebarText.withValues(alpha: 0.64),
            ),
          ],
        ),
      ),
    );
  }
}
