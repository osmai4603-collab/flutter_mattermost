import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_history_cubit.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// أزرار الرجوع والتقدم في سجل القنوات — يطابق history_buttons.tsx في webapp:
/// سهمان بجوار قائمة المنتجات، يُفعّلان حسب وجود سجل رجوع/تقدم.
class HistoryNavigationButtons extends StatelessWidget {
  const HistoryNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChannelHistoryCubit, ChannelHistoryState>(
      listenWhen: (previous, current) =>
          current.pendingTarget?.id != previous.pendingTarget?.id,
      listener: (context, state) {
        final target = state.pendingTarget;
        if (target == null) return;
        context.read<ChannelHistoryCubit>().ackNavigation();
        // تحديث مسار التطبيق للقنوات ذات اسم قابل للعنونة؛
        // الـ DM/GM يُدار من الحالة وحدها (channel_screen يتبع الحالة).
        final teamState = context.read<TeamBloc>().state;
        final teamName = teamState is TeamsLoadedState
            ? teamState.selectedTeam?.name
            : null;
        if (teamName != null && target.name.isNotEmpty) {
          context.go('/$teamName/channels/${target.name}');
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HistoryButton(
              icon: Icons.arrow_back_ios_new,
              tooltip: l10n.global_headerBack,
              enabled: state.canGoBack,
              onTap: () => context.read<ChannelHistoryCubit>().goBack(),
            ),
            const SizedBox(width: 2),
            _HistoryButton(
              icon: Icons.arrow_forward_ios,
              tooltip: l10n.global_headerForward,
              enabled: state.canGoForward,
              onTap: () => context.read<ChannelHistoryCubit>().goForward(),
            ),
          ],
        );
      },
    );
  }
}

class _HistoryButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool enabled;
  final VoidCallback onTap;

  const _HistoryButton({
    required this.icon,
    required this.tooltip,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_HistoryButton> createState() => _HistoryButtonState();
}

class _HistoryButtonState extends State<_HistoryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final base = theme.sidebarText;
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          child: AnimatedContainer(
            duration: DesignTokens.hoverFadeDuration,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.enabled && _hovered
                  ? base.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: Icon(
              widget.icon,
              size: 14,
              color: widget.enabled
                  ? base.withValues(alpha: 0.72)
                  : base.withValues(alpha: 0.25),
            ),
          ),
        ),
      ),
    );
  }
}