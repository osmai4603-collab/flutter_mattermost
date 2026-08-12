import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

class CallWidget extends StatelessWidget {
  const CallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is! CallConnectedState) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 120,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.centerChannelBg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
            border: Border.all(color: theme.buttonBg.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // Video placeholder
              Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                ),
                child: Center(
                  child: state.isVideoOn
                      ? const Icon(Icons.videocam, color: Colors.white)
                      : const Icon(Icons.videocam_off, color: Colors.white54),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.callWidgetTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: theme.centerChannelColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(state.isMuted ? Icons.mic_off : Icons.mic),
                            color: state.isMuted ? theme.errorTextColor : theme.centerChannelColor,
                            onPressed: () => context.read<CallsBloc>().add(ToggleMuteEvent()),
                          ),
                          IconButton(
                            icon: Icon(state.isVideoOn ? Icons.videocam : Icons.videocam_off),
                            color: theme.centerChannelColor,
                            onPressed: () => context.read<CallsBloc>().add(ToggleVideoEvent()),
                          ),
                          IconButton(
                            tooltip: state.isSharingScreen
                                ? l10n.callWidgetStopSharing
                                : l10n.callWidgetShareScreen,
                            icon: Icon(
                              state.isSharingScreen
                                  ? Icons.stop_screen_share
                                  : Icons.screen_share,
                            ),
                            color: state.isSharingScreen
                                ? theme.mentionBg
                                : theme.centerChannelColor,
                            onPressed: () =>
                                context.read<CallsBloc>().add(ToggleShareScreenEvent()),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.errorTextColor,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.call_end),
                            label: Text(l10n.callWidgetEndCall),
                            onPressed: () => context.read<CallsBloc>().add(EndCallEvent()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}