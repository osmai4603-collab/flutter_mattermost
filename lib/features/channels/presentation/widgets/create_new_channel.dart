import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';

class CreateNewChannel extends StatefulWidget {
  final ChannelEntity? channel;
  const CreateNewChannel({super.key, this.channel});

  @override
  State<CreateNewChannel> createState() => _CreateNewChannelState();
}

class _CreateNewChannelState extends State<CreateNewChannel> {
  static const _newCategoryValue = '__new_category__';

  final channelNameController = TextEditingController();
  final channelPurposeController = TextEditingController();
  final newCategoryController = TextEditingController();
  bool isPublic = true;
  String? categorySelected;
  bool _creatingNewCategory = false;
  bool _submitting = false;
  String? _nameError;
  String? _error;
  String? _pendingChannelName;

  List<ChannelCategoryEntity> categories = [];

  @override
  void initState() {
    super.initState();
    final state = context.read<ChannelBloc>().state;
    if (state is ChannelsLoadedState) {
      categories = state.categories;
    }
  }

  @override
  void dispose() {
    channelNameController.dispose();
    channelPurposeController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  String _channelSlug(String displayName) {
    var slug = displayName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^[^a-z0-9]+'), '')
        .replaceAll(RegExp(r'[^a-z0-9]+$'), '');
    if (slug.isEmpty) {
      slug = 'channel-${DateTime.now().millisecondsSinceEpoch}';
    }
    return slug;
  }

  void _onCategorySelected(String? value) {
    setState(() {
      categorySelected = value;
      _creatingNewCategory = value == _newCategoryValue;
    });
  }

  Future<void> _createChannel() async {
    final name = channelNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Channel name is required');
      return;
    }
    if (_creatingNewCategory && newCategoryController.text.trim().isEmpty) {
      setState(() => _error = 'Category name is required');
      return;
    }

    final teamState = context.read<TeamBloc>().state;
    final team = teamState is TeamsLoadedState ? teamState.selectedTeam : null;
    final authState = context.read<AuthBloc>().state;
    final userId = authState is AuthenticatedState ? authState.user.id : null;
    if (team == null || userId == null) {
      setState(() => _error = 'Failed to create channel');
      return;
    }

    final channelName = _channelSlug(name);
    setState(() {
      _submitting = true;
      _error = null;
      _nameError = null;
      _pendingChannelName = channelName;
    });

    context.read<ChannelBloc>().add(
      CreateChannelEvent(
        teamId: team.id,
        userId: userId,
        displayName: name,
        name: channelName,
        type: isPublic ? ChannelType.open : ChannelType.private,
        purpose: channelPurposeController.text.trim(),
        categoryId: _creatingNewCategory ? null : categorySelected,
        newCategoryName: _creatingNewCategory
            ? newCategoryController.text.trim()
            : null,
      ),
    );
  }

  void _onStateChanged(BuildContext context, ChannelState state) {
    if (!_submitting) return;
    if (state is ChannelErrorState) {
      setState(() {
        _submitting = false;
        _error = state.message;
      });
      return;
    }
    if (state is ChannelsLoadedState && _pendingChannelName != null) {
      final channel = state.channels
          .where((c) => c.name == _pendingChannelName)
          .firstOrNull;
      if (channel != null) {
        setState(() => _submitting = false);
        _openChannel(context, channel);
      }
    }
  }

  void _openChannel(BuildContext context, ChannelEntity channel) {
    Navigator.of(context).pop();
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName != null) {
      context.go('/$teamName/channels/${channel.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textTheme = TextTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocListener<ChannelBloc, ChannelState>(
      listener: _onStateChanged,
      child: AlertDialog(
        constraints: BoxConstraints(minWidth: 600),
        title: Row(
          spacing: 10,
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('Create a new channel', style: textTheme.titleLarge),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _submitting
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
            ),
          ],
        ),
        insetPadding: .symmetric(horizontal: 32, vertical: 24),

        backgroundColor: theme.centerChannelBg,
        // insetPadding: .all(16),
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            spacing: 32,
            children: [
              TextField(
                controller: channelNameController,
                onChanged: (_) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter a name of your new channel',
                  labelText: 'Channel name',
                  errorText: _nameError,
                  helperText:
                      "URL: http://loc...:8065/sample-team/channels/hello-world Edit",
                ),
              ),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: Card(
                      margin: .zero,
                      child: InkWell(
                        borderRadius: .circular(8),
                        onTap: () => setState(() => isPublic = true),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 16,
                            children: [
                              Container(
                                padding: .all(8),
                                decoration: BoxDecoration(
                                  color: isPublic
                                      ? theme.buttonBg.withValues(alpha: 0.40)
                                      : theme.centerChannelBg.withValues(
                                          alpha: 0.30,
                                        ),
                                  shape: .circle,
                                ),
                                child: Icon(Icons.public),
                              ),
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    'Public channel',
                                    style: textTheme.titleSmall,
                                  ),
                                  Text(
                                    'Anyone can join',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              if (isPublic)
                                Expanded(
                                  child: Align(
                                    alignment: .centerEnd,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: theme.buttonBg,
                                      size: 27,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: .zero,
                      child: InkWell(
                        borderRadius: .circular(8),
                        onTap: () => setState(() => isPublic = false),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 16,
                            children: [
                              Container(
                                padding: .all(8),
                                decoration: BoxDecoration(
                                  color: !isPublic
                                      ? theme.buttonBg.withValues(alpha: 0.40)
                                      : theme.centerChannelBg.withValues(
                                          alpha: 0.30,
                                        ),
                                  shape: .circle,
                                ),
                                child: Icon(Icons.lock_rounded),
                              ),
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    'Private channel',
                                    style: textTheme.titleSmall,
                                  ),
                                  Text(
                                    'Only invited members',
                                    style: textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              if (!isPublic)
                                Expanded(
                                  child: Align(
                                    alignment: .centerEnd,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: theme.buttonBg,
                                      size: 27,
                                    ),
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
              DropdownButtonFormField<String>(
                initialValue: categorySelected,
                isExpanded: true,
                items: [
                  for (final category in categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        category.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  DropdownMenuItem(
                    value: _newCategoryValue,
                    child: Text(l10n.create_category_modalCreateCategory),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: 'Select a category or type new category',
                  labelText: 'Default category (optional)',
                  helperText:
                      'Sets the default sidebar category for users when they join the channel.',
                  prefixIcon: Icon(Icons.folder_rounded, size: 22),
                ),
                onChanged: _submitting ? null : _onCategorySelected,
              ),
              if (_creatingNewCategory)
                TextField(
                  controller: newCategoryController,
                  decoration: InputDecoration(
                    labelText: l10n.create_category_modalCreateCategory,
                    hintText: 'Enter a name for the new category',
                  ),
                ),

              TextField(
                controller: channelPurposeController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Enter a purpose for this channel (optional)',
                  labelText: 'Channel purpose',
                  helperText:
                      'This will be displayed when browsing for channels.',
                ),
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
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: _submitting ? null : _createChannel,
            child: _submitting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Create channel'),
          ),
        ],
      ),
    );
  }
}
