import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';

/// شريط المكالمة الواردة — يظهر أعلى قائمة الرسائل عند استقبال مكالمة
/// (CallRingingState)، مع أزرار قبول/رفض.
class IncomingCallBanner extends StatelessWidget {
  const IncomingCallBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<CallsBloc, CallsState>(
      builder: (context, state) {
        if (state is! CallRingingState) {
          return const SizedBox.shrink();
        }

        final channelState = context.read<ChannelBloc>().state;
        final channelName = channelState is ChannelsLoadedState
            ? channelState.channels
                  .where((c) => c.id == state.channelId)
                  .firstOrNull
                  ?.displayName
            : null;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.buttonBg,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.incomingCallTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      l10n.incomingCallDescription(channelName ?? ''),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: theme.buttonBg,
                ),
                onPressed: () {
                  context.read<CallsBloc>().add(JoinCallEvent(state.callId));
                },
                child: Text(l10n.incomingCallAccept),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                onPressed: () {
                  context.read<CallsBloc>().add(RejectCallEvent(state.callId));
                },
                child: Text(l10n.incomingCallDecline),
              ),
            ],
          ),
        );
      },
    );
  }
}