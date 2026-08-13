import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

import '../../../../core/theme/mattermost_colors.dart';

/// دعوة أعضاء لقناة محددة — مطابق ChannelInviteModal في webapp:
/// إدخال بريد إلكتروني + إرسال دعوة للقناة الحالية.
class ChannelInviteModal extends StatefulWidget {
  const ChannelInviteModal({super.key});

  @override
  State<ChannelInviteModal> createState() => _ChannelInviteModalState();
}

class _ChannelInviteModalState extends State<ChannelInviteModal> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _sending = false;
  bool _sent = false;
  String? _error;

  List<UserEntity> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _emailController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_emailController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }

    if (mounted) setState(() => _isSearching = true);

    try {
      final teamState = context.read<TeamBloc>().state;
      final teamId = teamState is TeamsLoadedState
          ? teamState.selectedTeam?.id
          : null;

      final channelId = _channelId();

      final users = await getIt<UserRepository>().autocompleteUsers(
        query,
        teamId: teamId,
        channelId: channelId,
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

  String? _channelId() {
    final state = context.read<ChannelBloc>().state;
    if (state is! ChannelsLoadedState) return null;
    return state.selectedChannel?.id;
  }

  Future<void> _send() async {
    final channelId = _channelId();
    final email = _emailController.text.trim();
    if (channelId == null || email.isEmpty) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final teamState = context.read<TeamBloc>().state;
      final teamId = teamState is TeamsLoadedState
          ? teamState.selectedTeam?.id ?? teamState.teams.firstOrNull?.id
          : null;
      if (teamId == null) throw Exception('No team');
      await getIt<TeamRepository>().inviteMembersByEmail(
        teamId,
        [email],
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = 'Invitation failed';
      });
    }
  }

  /// إضافة العضو المختار من مساحة العمل مباشرة إلى القناة — يطابق
  /// POST /channels/{id}/members (إضافة أعضاء ضمن team).
  Future<void> _selectUser(UserEntity user) async {
    final channelId = _channelId();
    if (channelId == null) return;
    setState(() {
      _sending = true;
      _suggestions = [];
      _error = null;
    });
    _focusNode.unfocus();
    try {
      await getIt<ChannelRepository>().addChannelMembers(channelId, [user.id]);
      if (mounted) {
        setState(() => _sending = false);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _sending = false;
          _error = 'Add failed';
        });
      }
    }
  }

  void _openTeamInvite() {
    Navigator.of(context).pop();
    ModalRegistry.open(context, id: ModalIdentifiers.invitation);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.channelInviteTitle,
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _sent
                    ? _buildSuccessView(theme, l10n)
                    : _buildInviteView(theme, l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(MattermostColors theme, AppLocalizations l10n) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.invitation_modalConfirmSentHeader,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.centerChannelColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.channelInviteDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonBg,
              foregroundColor: theme.buttonColor,
            ),
            child: Text(
              l10n.channelInviteDone,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInviteView(MattermostColors theme, AppLocalizations l10n) {
    final showNoMatches = _emailController.text.isNotEmpty &&
        _suggestions.isEmpty &&
        !_isSearching;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.channelInviteDescription,
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.72),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _emailController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: theme.centerChannelColor),
                  decoration: InputDecoration(
                    hintText: l10n.channelInviteEmailPlaceholder,
                    hintStyle: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      size: 18,
                      color: theme.centerChannelColor.withValues(alpha: 0.5),
                    ),
                    isDense: true,
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
                      borderRadius:
                          BorderRadius.circular(DesignTokens.radiusSm),
                    ),
                  ),
                ),
                if (showNoMatches) ...[
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'No matches found - '),
                        TextSpan(
                          text: 'invite them to the team',
                          style: TextStyle(
                            color: theme.buttonBg,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _openTeamInvite,
                        ),
                      ],
                    ),
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
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
                ],
              ],
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
                          color:
                              theme.centerChannelColor.withValues(alpha: 0.6),
                        ),
                      ),
                      onTap: () => _selectUser(user),
                    );
                  },
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: _sending ? null : _send,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.buttonBg,
              foregroundColor: theme.buttonColor,
            ),
            child: _sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    l10n.channelInviteSend,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }
}
