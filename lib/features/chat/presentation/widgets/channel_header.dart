import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

/// رأس القناة — مطابق channel_header.tsx في webapp:
/// ارتفاع 56px، اسم القناة + وصف، أزرار: بحث → RHS، الأعضاء → RHS،
/// قائمة ⋮ (نسخ الرابط، معلومات القناة، الرسائل المثبتة).
class ChannelHeader extends StatelessWidget {
  const ChannelHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ChannelBloc, ChannelState>(
      builder: (context, state) {
        final channel = state is ChannelsLoadedState
            ? state.selectedChannel
            : null;

        return Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            border: Border(
              bottom: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                channel == null
                    ? Icons.tag
                    : channel.type == ChannelType.direct
                    ? Icons.person_outline
                    : channel.type == ChannelType.private
                    ? Icons.lock_outline
                    : Icons.tag,
                size: 20,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      channel?.displayName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (channel != null && channel.type != ChannelType.direct)
                      Text(
                        channel.header.isNotEmpty
                            ? channel.header
                            : channel.purpose,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MatterButton(
                size: MatterButtonSize.icon,
                transparent: true,
                tooltip: l10n.channelHeaderSearch,
                onPressed: () {
                  context.read<RhsBloc>().add(const ShowSearchResultsEvent());
                },
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
              ),
              MatterButton(
                size: MatterButtonSize.icon,
                transparent: true,
                tooltip: l10n.channelHeaderMembers,
                onPressed: () {
                  context.read<RhsBloc>().add(ShowChannelMembersEvent());
                },
                child: Icon(
                  Icons.group_outlined,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
              ),
              MatterMenuScope(
                openUp: true,
                items: [
                  MatterMenuItem(
                    id: 'copy_link',
                    label: l10n.channelHeaderCopyLink,
                    icon: const Icon(Icons.link, size: 18),
                    onTap: () => _copyChannelLink(context, channel),
                  ),
                  MatterMenuItem(
                    id: 'channel_info',
                    label: l10n.channelHeaderChannelInfo,
                    icon: const Icon(Icons.info_outline, size: 18),
                    onTap: () {
                      context.read<RhsBloc>().add(ShowChannelInfoEvent());
                    },
                  ),
                  MatterMenuItem(
                    id: 'pinned',
                    label: l10n.channel_headerPinnedPosts,
                    icon: const Icon(Icons.push_pin_outlined, size: 18),
                    separatorBefore: true,
                    onTap: () {
                      context.read<RhsBloc>().add(ShowPinnedPostsEvent());
                    },
                  ),
                ],
                child: MatterButton(
                  size: MatterButtonSize.icon,
                  transparent: true,
                  tooltip: l10n.channelHeaderMore,
                  onPressed: () {},
                  child: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: theme.centerChannelColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyChannelLink(BuildContext context, channel) {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    final channelName = channel?.name;
    final link =
        teamName != null && channelName != null
        ? '/$teamName/channels/$channelName'
        : '';
    Clipboard.setData(ClipboardData(text: link));
  }
}
