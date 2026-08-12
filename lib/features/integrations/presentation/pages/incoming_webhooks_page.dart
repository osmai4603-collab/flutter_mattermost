import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/incoming_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/presentation/blocs/webhooks_bloc.dart';

class IncomingWebhooksPage extends StatelessWidget {
  const IncomingWebhooksPage({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WebhooksBloc>()..add(LoadIncomingWebhooksEvent(teamId: teamId)),
      child: BlocConsumer<WebhooksBloc, WebhooksState>(
        listener: (context, state) {
          if (state is WebhooksErrorState) {
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

  Widget _buildHeader(BuildContext context, WebhooksState state) {
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
            Icons.call_received_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Incoming Webhooks',
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
            label: const Text('New Webhook'),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WebhooksState state) {
    if (state is WebhooksLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }
    if (state is! IncomingWebhooksLoadedState) {
      return const Center(
        child: Text(
          'No incoming webhooks yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final webhooks = state.webhooks;
    if (webhooks.isEmpty) {
      return const Center(
        child: Text(
          'No incoming webhooks yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: webhooks.length,
      itemBuilder: (context, index) =>
          _buildWebhookTile(context, webhooks[index]),
    );
  }

  Widget _buildWebhookTile(BuildContext context, IncomingWebhookEntity webhook) {
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
            backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
            child: const Icon(Icons.link, color: Colors.blueAccent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  webhook.displayName.isEmpty
                      ? webhook.id
                      : webhook.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Channel: ${webhook.channelId}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 18,
            ),
            onPressed: () => _showEditDialog(context, webhook),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 18,
            ),
            onPressed: () => _showDeleteDialog(context, webhook.id),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final channelController = TextEditingController();
    final nameController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Incoming Webhook',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: channelController, label: 'Channel ID *'),
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
              if (channelController.text.trim().isNotEmpty) {
                dialogContext.read<WebhooksBloc>().add(
                  CreateIncomingWebhookEvent(
                    channelId: channelController.text.trim(),
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

  void _showEditDialog(BuildContext context, IncomingWebhookEntity webhook) {
    final channelController = TextEditingController(text: webhook.channelId);
    final nameController = TextEditingController(text: webhook.displayName);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Edit Incoming Webhook',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: channelController, label: 'Channel ID *'),
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
              if (channelController.text.trim().isNotEmpty) {
                dialogContext.read<WebhooksBloc>().add(
                  UpdateIncomingWebhookEvent(
                    hookId: webhook.id,
                    channelId: channelController.text.trim(),
                    displayName: nameController.text.trim(),
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

  void _showDeleteDialog(BuildContext context, String hookId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Delete webhook?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This will permanently remove the webhook.',
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
              dialogContext.read<WebhooksBloc>().add(
                DeleteIncomingWebhookEvent(hookId),
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
