import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/bot_account_entity.dart';
import 'package:flutter_mattermost/features/integrations/presentation/blocs/bots_bloc.dart';

class BotsPage extends StatelessWidget {
  const BotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BotsBloc>()..add(LoadBotsEvent()),
      child: BlocConsumer<BotsBloc, BotsState>(
        listener: (context, state) {
          if (state is BotsErrorState) {
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

  Widget _buildHeader(BuildContext context, BotsState state) {
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
            Icons.smart_toy_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Bot Accounts',
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
            label: const Text('New Bot'),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BotsState state) {
    if (state is BotsLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }
    if (state is! BotsLoadedState) {
      return const Center(
        child: Text(
          'No bot accounts yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final bots = state.bots;
    if (bots.isEmpty) {
      return const Center(
        child: Text(
          'No bot accounts yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bots.length,
      itemBuilder: (context, index) => _buildBotTile(context, bots[index]),
    );
  }

  Widget _buildBotTile(BuildContext context, BotAccountEntity bot) {
    final disabled = bot.isDeleted;
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
            backgroundColor: disabled
                ? Colors.white10
                : Colors.blueAccent.withValues(alpha: 0.2),
            child: Icon(
              Icons.smart_toy_outlined,
              color: disabled ? Colors.white38 : Colors.blueAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bot.displayName.isEmpty ? bot.username : bot.displayName,
                  style: TextStyle(
                    color: disabled ? Colors.white38 : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '@${bot.username} · ${disabled ? 'Disabled' : 'Enabled'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              disabled ? Icons.play_circle_outline : Icons.pause_circle_outline,
              color: Colors.white54,
              size: 18,
            ),
            tooltip: disabled ? 'Enable' : 'Disable',
            onPressed: () {
              final bloc = context.read<BotsBloc>();
              if (disabled) {
                bloc.add(EnableBotEvent(bot.userId));
              } else {
                bloc.add(DisableBotEvent(bot.userId));
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 18,
            ),
            onPressed: () => _showEditDialog(context, bot),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 18,
            ),
            onPressed: () => _showDeleteDialog(context, bot.userId),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Bot Account',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: usernameController, label: 'Username *'),
            const SizedBox(height: 12),
            _DialogField(controller: nameController, label: 'Display Name'),
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
              final username = usernameController.text.trim();
              if (username.isNotEmpty) {
                dialogContext.read<BotsBloc>().add(
                  CreateBotEvent(
                    username: username,
                    displayName: nameController.text.trim(),
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

  void _showEditDialog(BuildContext context, BotAccountEntity bot) {
    final nameController = TextEditingController(text: bot.displayName);
    final descriptionController = TextEditingController(text: bot.description);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Edit Bot Account',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: nameController, label: 'Display Name'),
            const SizedBox(height: 12),
            _DialogField(
              controller: descriptionController,
              label: 'Description',
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
              dialogContext.read<BotsBloc>().add(
                UpdateBotEvent(
                  botUserId: bot.userId,
                  displayName: nameController.text.trim(),
                  description: descriptionController.text.trim(),
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String botUserId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Delete bot?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This will permanently remove the bot account.',
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
              dialogContext.read<BotsBloc>().add(DeleteBotEvent(botUserId));
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
