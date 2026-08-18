import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateNewTeam extends StatefulWidget {
  const CreateNewTeam({super.key});

  @override
  State<CreateNewTeam> createState() => _CreateNewTeamState();
}

class _CreateNewTeamState extends State<CreateNewTeam> {
  final teamDisplayNameController = TextEditingController();
  final teamNameController = TextEditingController();
  bool isOpen = true;
  bool _submitting = false;
  bool _isUrlManuallyEdited = false;
  String? _displayNameError;
  String? _nameError;
  String? _error;
  String? _pendingTeamName;

  @override
  void dispose() {
    teamDisplayNameController.dispose();
    teamNameController.dispose();
    super.dispose();
  }

  String _teamSlug(String displayName) {
    var slug = displayName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^[^a-z0-9]+'), '')
        .replaceAll(RegExp(r'[^a-z0-9]+$'), '');
    if (slug.isEmpty) {
      slug = '';
    }
    return slug;
  }

  void _onDisplayNameChanged(String value) {
    if (!_isUrlManuallyEdited) {
      teamNameController.text = _teamSlug(value);
    }
    if (_displayNameError != null) {
      setState(() => _displayNameError = null);
    }
  }

  void _onUrlChanged(String value) {
    _isUrlManuallyEdited = true;
    if (_nameError != null) {
      setState(() => _nameError = null);
    }
  }

  Future<void> _createTeam() async {
    final displayName = teamDisplayNameController.text.trim();
    final name = teamNameController.text.trim();

    if (displayName.isEmpty) {
      setState(() => _displayNameError = 'Team name is required');
      return;
    }
    if (name.isEmpty) {
      setState(() => _nameError = 'Team URL is required');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
      _displayNameError = null;
      _nameError = null;
      _pendingTeamName = name;
    });

    context.read<TeamBloc>().add(
          CreateTeamEvent(
            displayName: displayName,
            name: name,
            type: isOpen ? TeamType.open.value : TeamType.inviteOnly.value,
          ),
        );
  }

  void _onStateChanged(BuildContext context, TeamState state) {
    if (!_submitting) return;
    if (state is TeamErrorState) {
      setState(() {
        _submitting = false;
        _error = state.message;
      });
      return;
    }
    if (state is TeamsLoadedState && _pendingTeamName != null) {
      final team = state.teams
          .where((t) => t.name == _pendingTeamName)
          .firstOrNull;
      if (team != null) {
        setState(() => _submitting = false);
        Navigator.of(context).pop();
        context.go('/${team.name}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textTheme = TextTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<TeamBloc, TeamState>(
      listener: _onStateChanged,
      child: AlertDialog(
        constraints: const BoxConstraints(minWidth: 600),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Create a new team', style: textTheme.titleLarge),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _submitting ? null : () => Navigator.pop(context),
            ),
          ],
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        backgroundColor: theme.centerChannelBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teamDisplayNameController,
                onChanged: _onDisplayNameChanged,
                decoration: InputDecoration(
                  hintText: 'Enter a name for your new team',
                  labelText: 'Team name',
                  errorText: _displayNameError,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: teamNameController,
                onChanged: _onUrlChanged,
                decoration: InputDecoration(
                  hintText: 'team-url',
                  labelText: 'Team URL',
                  errorText: _nameError,
                  prefixText: 'http://localhost:8065/',
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => isOpen = true),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isOpen
                                      ? theme.buttonBg.withValues(alpha: 0.40)
                                      : theme.centerChannelBg.withValues(alpha: 0.30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.public),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Open team', style: textTheme.titleSmall),
                                  Text('Anyone can join', style: textTheme.bodySmall),
                                ],
                              ),
                              if (isOpen)
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Icon(Icons.check_circle, color: theme.buttonBg, size: 27),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => isOpen = false),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: !isOpen
                                      ? theme.buttonBg.withValues(alpha: 0.40)
                                      : theme.centerChannelBg.withValues(alpha: 0.30),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.lock_rounded),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Invite-only', style: textTheme.titleSmall),
                                  Text('Only invited members', style: textTheme.bodySmall),
                                ],
                              ),
                              if (!isOpen)
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Icon(Icons.check_circle, color: theme.buttonBg, size: 27),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          if (_error != null)
            Flexible(
              child: Text(
                _error!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.errorTextColor.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
            ),
          OutlinedButton(
            onPressed: _submitting ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _submitting ? null : _createTeam,
            child: _submitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Create team'),
          ),
        ],
      ),
    );
  }
}
