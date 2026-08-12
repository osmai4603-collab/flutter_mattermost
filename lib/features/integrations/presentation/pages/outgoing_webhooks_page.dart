import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_webhook_entity.dart';
import 'package:flutter_mattermost/features/integrations/presentation/blocs/webhooks_bloc.dart';

class OutgoingWebhooksPage extends StatelessWidget {
  const OutgoingWebhooksPage({super.key, this.teamId});

  final String? teamId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WebhooksBloc>()..add(LoadOutgoingWebhooksEvent(teamId: teamId)),
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
            Icons.call_made_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Outgoing Webhooks',
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
    if (state is! OutgoingWebhooksLoadedState) {
      return const Center(
        child: Text(
          'No outgoing webhooks yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final webhooks = state.webhooks;
    if (webhooks.isEmpty) {
      return const Center(
        child: Text(
          'No outgoing webhooks yet',
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

  Widget _buildWebhookTile(BuildContext context, OutgoingWebhookEntity webhook) {
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
            backgroundColor: Colors.purpleAccent.withValues(alpha: 0.2),
            child: const Icon(Icons.link, color: Colors.purpleAccent, size: 18),
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
                  'Tokens: ${webhook.triggerWords.join(', ')}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                Text(
                  '→ ${webhook.callbackUrls.firstOrNull ?? 'No callback URL'}',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.autorenew, color: Colors.white54, size: 18),
            tooltip: 'Regenerate token',
            onPressed: () => context.read<WebhooksBloc>().add(
              RegenerateOutgoingWebhookTokenEvent(webhook.id),
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
    final nameController = TextEditingController();
    final tokensController = TextEditingController();
    final callbackController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Outgoing Webhook',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: nameController, label: 'Display Name'),
            const SizedBox(height: 12),
            _DialogField(
              controller: callbackController,
              label: 'Callback URLs (comma separated) *',
            ),
            const SizedBox(height: 12),
            _DialogField(
              controller: tokensController,
              label: 'Trigger Words (comma separated)',
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
              final callbacks = _commaSeparated(callbackController.text);
              if (callbacks.isNotEmpty) {
                dialogContext.read<WebhooksBloc>().add(
                  CreateOutgoingWebhookEvent(
                    teamId: teamId ?? '',
                    displayName: nameController.text.trim(),
                    callbackUrls: callbacks,
                    triggerWords: _commaSeparated(tokensController.text),
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

  void _showEditDialog(BuildContext context, OutgoingWebhookEntity webhook) {
    final nameController = TextEditingController(text: webhook.displayName);
    final tokensController = TextEditingController(
      text: webhook.triggerWords.join(', '),
    );
    final callbackController = TextEditingController(
      text: webhook.callbackUrls.join(', '),
    );
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Edit Outgoing Webhook',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: nameController, label: 'Display Name'),
            const SizedBox(height: 12),
            _DialogField(
              controller: callbackController,
              label: 'Callback URLs (comma separated) *',
            ),
            const SizedBox(height: 12),
            _DialogField(
              controller: tokensController,
              label: 'Trigger Words (comma separated)',
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
              final callbacks = _commaSeparated(callbackController.text);
              if (callbacks.isNotEmpty) {
                dialogContext.read<WebhooksBloc>().add(
                  UpdateOutgoingWebhookEvent(
                    hookId: webhook.id,
                    displayName: nameController.text.trim(),
                    callbackUrls: callbacks,
                    triggerWords: _commaSeparated(tokensController.text),
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
              Navigator.of(dialogContext).pop();
              context.read<WebhooksBloc>().add(
                DeleteOutgoingWebhookEvent(hookId),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<String> _commaSeparated(String text) =>
      text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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
