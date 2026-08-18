import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

enum _InviteStep { invite, results }

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
class InvitePeopleToTeam extends StatefulWidget {
  const InvitePeopleToTeam({super.key});

  @override
  State<InvitePeopleToTeam> createState() => _InvitePeopleToTeamState();
}

class _InvitePeopleToTeamState extends State<InvitePeopleToTeam> {
  _InviteStep _currentStep = _InviteStep.invite;

  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final List<InvitationResult> _results = [];

  final List<_InviteEntry> _entries = [];

  List<UserEntity> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_onTextChanged);
    _inputController.dispose();
    _inputFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_inputController.text);
    });
    setState(() {});
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    if (mounted) setState(() => _isSearching = true);

    try {
      final teamState = context.read<TeamBloc>().state;
      final teamId = teamState is TeamsLoadedState
          ? teamState.selectedTeam?.id
          : null;

      final users = await getIt<UserRepository>().autocompleteUsers(
        query.trim(),
        teamId: teamId,
      );

      if (mounted) {
        setState(() {
          _suggestions = users;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _addEntry(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (_entries.any((e) => e.value == trimmed)) return;
    setState(() {
      _entries.add(_InviteEntry(value: trimmed));
      _inputController.clear();
      _suggestions = [];
    });
  }

  void _addUserEntry(UserEntity user) {
    final display = user.email.isNotEmpty ? user.email : user.username;
    if (_entries.any((e) => e.value == display)) return;
    setState(() {
      _entries.add(_InviteEntry(value: display, user: user));
      _inputController.clear();
      _suggestions = [];
    });
  }

  void _removeEntry(int index) {
    setState(() => _entries.removeAt(index));
  }

  void _handleInvite() async {
    if (_entries.isEmpty) return;

    setState(() => _isSending = true);

    final entryValues = _entries.map((e) => e.value).toList();

    final teamState = context.read<TeamBloc>().state;
    final teamId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.id ?? teamState.teams.firstOrNull?.id
        : null;

    final newResults = <InvitationResult>[];
    if (teamId == null) {
      newResults.addAll(
        entryValues.map(
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

        await repo.inviteMembersByEmail(teamId, entryValues);
        newResults.addAll(
          entryValues.map(
            (e) => InvitationResult(emailOrUsername: e, success: true),
          ),
        );
      } catch (e) {
        newResults.addAll(
          entryValues.map(
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
      _entries.clear();
      _inputController.clear();
      _results.clear();
      _suggestions = [];
      _currentStep = _InviteStep.invite;
    });
  }

  String _buildInviteLink() {
    final serverUrl = getIt<ServerManager>().activeServerUrl;
    final teamState = context.read<TeamBloc>().state;
    final inviteId = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.inviteId ?? ''
        : '';
    return '$serverUrl/signup_user_complete/?id=$inviteId';
  }

  void _copyInviteLink() {
    final link = _buildInviteLink();
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite link copied to clipboard')),
    );
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
      fontSize: 22,
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
      extraFooter: _currentStep == _InviteStep.invite
          ? OutlinedButton.icon(
              onPressed: _copyInviteLink,
              icon: const Icon(Icons.link, size: 18),
              label: Text(l10n.invite_modalCopy_link),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.centerChannelColor,
                side: BorderSide(
                  color: theme.centerChannelColor.withValues(alpha: 0.24),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInviteView(MattermostColors theme, AppLocalizations l10n) {
    final query = _inputController.text.trim();
    final showNoMatches =
        query.isNotEmpty && _suggestions.isEmpty && !_isSearching;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected entries as chips
        if (_entries.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (int i = 0; i < _entries.length; i++)
                Chip(
                  label: Text(
                    _entries[i].value,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 13,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    size: 16,
                    color: theme.centerChannelColor.withValues(alpha: 0.6),
                  ),
                  onDeleted: () => _removeEntry(i),
                  backgroundColor: theme.centerChannelColor.withValues(
                    alpha: 0.08,
                  ),
                  side: BorderSide(
                    color: theme.centerChannelColor.withValues(alpha: 0.12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Input field with autocomplete
        Stack(
          children: [
            TextField(
              controller: _inputController,
              focusNode: _inputFocusNode,
              style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.invite_modalAdd_invites,
                hintStyle: TextStyle(
                  color: theme.centerChannelColor.withValues(alpha: 0.48),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: theme.centerChannelBg,
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  borderSide: BorderSide(
                    color: theme.centerChannelColor.withValues(alpha: 0.16),
                  ),
                ),
              ),
              onSubmitted: _addEntry,
            ),
            if (_suggestions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 48),
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  color: theme.centerChannelBg,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final user = _suggestions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        user.username,
                        style: TextStyle(color: theme.centerChannelColor),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      onTap: () => _addUserEntry(user),
                    );
                  },
                ),
              ),
          ],
        ),

        // No matches message
        if (showNoMatches) ...[
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
              children: [
                TextSpan(text: "No one found matching '$query' - "),
                TextSpan(
                  text: 'enter their email to invite them',
                  style: TextStyle(
                    color: theme.buttonBg,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
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

class _InviteEntry {
  final String value;
  final UserEntity? user;

  const _InviteEntry({required this.value, this.user});
}
