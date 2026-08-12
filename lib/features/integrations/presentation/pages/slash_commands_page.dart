import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/command_entity.dart';
import 'package:flutter_mattermost/features/integrations/presentation/blocs/commands_bloc.dart';

class SlashCommandsPage extends StatelessWidget {
  const SlashCommandsPage({super.key, this.teamId = ''});

  final String teamId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CommandsBloc>()..add(LoadCommandsEvent(teamId)),
      child: BlocConsumer<CommandsBloc, CommandsState>(
        listener: (context, state) {
          if (state is CommandsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, state),
              Expanded(child: _buildContent(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CommandsState state) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.terminal_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Slash Commands',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Command'),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CommandsState state) {
    if (state is CommandsLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }
    if (state is! CommandsLoadedState) {
      return const Center(
        child: Text(
          'No slash commands yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final commands = state.commands;
    if (commands.isEmpty) {
      return const Center(
        child: Text(
          'No slash commands yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: commands.length,
      itemBuilder: (context, index) =>
          _buildCommandTile(context, commands[index]),
    );
  }

  Widget _buildCommandTile(BuildContext context, CommandEntity command) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.tealAccent.withValues(alpha: 0.2),
            child: const Icon(
              Icons.terminal,
              color: Colors.tealAccent,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '/${command.trigger}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${command.url} · ${command.method}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white54, size: 18),
            tooltip: 'Execute',
            onPressed: () => _showExecuteDialog(context, command),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 18,
            ),
            onPressed: () => _showEditDialog(context, command),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 18,
            ),
            onPressed: () => _showDeleteDialog(context, command.id),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final triggerController = TextEditingController();
    final urlController = TextEditingController();
    final methodController = TextEditingController(text: 'POST');
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Slash Command',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(
              controller: triggerController,
              label: 'Trigger (without /) *',
            ),
            const SizedBox(height: 12),
            _DialogField(controller: urlController, label: 'Request URL *'),
            const SizedBox(height: 12),
            _DialogField(
              controller: methodController,
              label: 'HTTP Method (POST/GET)',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              final trigger = triggerController.text.trim();
              final url = urlController.text.trim();
              if (trigger.isNotEmpty && url.isNotEmpty) {
                dialogContext.read<CommandsBloc>().add(
                  CreateCommandEvent(
                    teamId: teamId,
                    trigger: trigger,
                    url: url,
                    method: methodController.text.trim().toUpperCase(),
                  ),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CommandEntity command) {
    final triggerController = TextEditingController(text: command.trigger);
    final urlController = TextEditingController(text: command.url);
    final methodController = TextEditingController(text: command.method);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Edit Slash Command',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(
              controller: triggerController,
              label: 'Trigger (without /) *',
            ),
            const SizedBox(height: 12),
            _DialogField(controller: urlController, label: 'Request URL *'),
            const SizedBox(height: 12),
            _DialogField(
              controller: methodController,
              label: 'HTTP Method (POST/GET)',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              final trigger = triggerController.text.trim();
              final url = urlController.text.trim();
              if (trigger.isNotEmpty && url.isNotEmpty) {
                dialogContext.read<CommandsBloc>().add(
                  UpdateCommandEvent(
                    commandId: command.id,
                    trigger: trigger,
                    url: url,
                    method: methodController.text.trim().toUpperCase(),
                  ),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showExecuteDialog(BuildContext context, CommandEntity command) {
    final argsController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: Text(
          '/${command.trigger}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Arguments (executed with the current channel)',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            _DialogField(controller: argsController, label: 'Arguments'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              dialogContext.read<CommandsBloc>().add(
                ExecuteCommandEvent(
                  command: '/${command.trigger} ${argsController.text.trim()}'
                      .trim(),
                  channelId: '',
                  teamId: teamId,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Run'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String commandId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Delete command?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This will permanently remove the slash command.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              dialogContext.read<CommandsBloc>().add(
                DeleteCommandEvent(commandId),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
        filled: true,
        fillColor: const Color(0xFF313244),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
