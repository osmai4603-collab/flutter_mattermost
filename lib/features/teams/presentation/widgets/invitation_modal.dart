import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

enum _InviteStep { invite, results }

enum _UserRole { member, guest }

class InvitationResult {
  final String emailOrUsername;
  final bool success;
  final String? error;

  const InvitationResult({
    required this.emailOrUsername,
    required this.success,
    this.error,
  });
}

/// نافذة دعوة الأعضاء المنبثقة — مطابقة لـ InvitationModal في webapp (عرض 600px)
class InvitationModal extends StatefulWidget {
  const InvitationModal({super.key});

  @override
  State<InvitationModal> createState() => _InvitationModalState();
}

class _InvitationModalState extends State<InvitationModal> {
  _InviteStep _currentStep = _InviteStep.invite;
  _UserRole _selectedRole = _UserRole.member;

  final TextEditingController _usersController = TextEditingController();
  final List<String> _selectedChannels = [];
  final List<InvitationResult> _results = [];

  bool _isSending = false;

  @override
  void dispose() {
    _usersController.dispose();
    super.dispose();
  }

  void _handleInvite() async {
    final rawText = _usersController.text.trim();
    if (rawText.isEmpty) return;

    setState(() => _isSending = true);

    final entries = rawText
        .split(RegExp(r'[,\s]+'))
        .where((e) => e.isNotEmpty)
        .toList();

    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? teamState.teams.firstOrNull?.id
        : null;

    final newResults = <InvitationResult>[];
    if (teamId == null) {
      newResults.addAll(
        entries.map(
          (e) => InvitationResult(
            emailOrUsername: e,
            success: false,
            error: 'No team selected',
          ),
        ),
      );
    } else {
      try {
        final repo = getIt<TeamRepository>();
        if (_selectedRole == _UserRole.member) {
          await repo.inviteMembersByEmail(teamId, entries);
        } else {
          await repo.inviteGuestsToChannels(
            teamId,
            emails: entries,
            channelIds: _selectedChannels,
          );
        }
        newResults.addAll(
          entries.map(
            (e) => InvitationResult(emailOrUsername: e, success: true),
          ),
        );
      } catch (e) {
        newResults.addAll(
          entries.map(
            (entry) => InvitationResult(
              emailOrUsername: entry,
              success: false,
              error: 'Invite failed',
            ),
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      _results.clear();
      _results.addAll(newResults);
      _isSending = false;
      _currentStep = _InviteStep.results;
    });
  }

  void _reset() {
    setState(() {
      _usersController.clear();
      _selectedChannels.clear();
      _results.clear();
      _currentStep = _InviteStep.invite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return GenericModal(
      width: 600,
      title: _currentStep == _InviteStep.invite
          ? l10n.modalInviteTitle
          : l10n.invitation_modalConfirmSentHeader,
      body: _currentStep == _InviteStep.invite
          ? _buildInviteView(theme, l10n)
          : _buildResultView(theme, l10n),
      confirmLabel: _currentStep == _InviteStep.invite
          ? l10n.invite_modalInvite
          : l10n.invitation_modalConfirmDone,
      onConfirm: _currentStep == _InviteStep.invite && !_isSending
          ? _handleInvite
          : _currentStep == _InviteStep.results
          ? () => Navigator.of(context).pop()
          : null,
    );
  }

  Widget _buildInviteView(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Role Selector (Member vs Guest)
        Text(
          l10n.invite_modalAs,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<_UserRole>(
                value: _UserRole.member,
                groupValue: _selectedRole,
                title: Text(
                  l10n.invite_modalChoose_member,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                  ),
                ),
                activeColor: theme.buttonBg,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
            ),
            Expanded(
              child: RadioListTile<_UserRole>(
                value: _UserRole.guest,
                groupValue: _selectedRole,
                title: Text(
                  l10n.invite_modalChoose_guest_a,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                  ),
                ),
                activeColor: theme.buttonBg,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Users / Emails Input
        Text(
          l10n.invitation_modalMembersSearch_and_addTitle,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _usersController,
          maxLines: 3,
          style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: l10n.invite_modalAdd_invites,
            hintStyle: TextStyle(
              color: theme.centerChannelColor.withValues(alpha: 0.48),
              fontSize: 13,
            ),
            filled: true,
            fillColor: theme.centerChannelBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              borderSide: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.16),
              ),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),

        // Add to Channels Section
        Text(
          l10n.invite_modalAdd_channels_title_a,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        BlocBuilder<ChannelBloc, ChannelState>(
          builder: (context, state) {
            final channels = (state is ChannelsLoadedState)
                ? state.channels
                : [];
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final ch in channels.take(6))
                  FilterChip(
                    label: Text(
                      ch.displayName,
                      style: TextStyle(
                        color: _selectedChannels.contains(ch.id)
                            ? theme.buttonColor
                            : theme.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    selected: _selectedChannels.contains(ch.id),
                    selectedColor: theme.buttonBg,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedChannels.add(ch.id);
                        } else {
                          _selectedChannels.remove(ch.id);
                        }
                      });
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultView(MattermostColors theme, AppLocalizations l10n) {
    final successfulCount = _results.where((r) => r.success).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          successfulCount > 0
              ? l10n.invitation_modalConfirmSentHeader
              : l10n.invitation_modalConfirmNotSentHeader,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),

        // Results Table
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            border: Border.all(
              color: theme.centerChannelColor.withValues(alpha: 0.16),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _results.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    color: theme.centerChannelColor.withValues(alpha: 0.12),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _results[i].success
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        color: _results[i].success
                            ? Colors.green
                            : Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _results[i].emailOrUsername,
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        _results[i].success
                            ? 'Sent'
                            : (_results[i].error ?? 'Failed'),
                        style: TextStyle(
                          color: _results[i].success
                              ? Colors.green
                              : Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        TextButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.add),
          label: Text(l10n.invitation_modalInviteMore),
          style: TextButton.styleFrom(foregroundColor: theme.buttonBg),
        ),
      ],
    );
  }
}
