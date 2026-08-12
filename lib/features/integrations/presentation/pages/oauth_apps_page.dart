import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/oauth_app_entity.dart';
import 'package:flutter_mattermost/features/integrations/presentation/blocs/oauth_apps_bloc.dart';

class OAuthAppsPage extends StatelessWidget {
  const OAuthAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OAuthAppsBloc>()..add(LoadOAuthAppsEvent()),
      child: BlocConsumer<OAuthAppsBloc, OAuthAppsState>(
        listener: (context, state) {
          if (state is OAuthAppsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is OAuthAppSecretState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('New client secret: ${state.clientSecret}'),
                duration: const Duration(seconds: 8),
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

  Widget _buildHeader(BuildContext context, OAuthAppsState state) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 10),
          const Text(
            'OAuth 2.0 Applications',
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
            label: const Text('Register App'),
            onPressed: () => _showRegisterDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, OAuthAppsState state) {
    if (state is OAuthAppsLoadingState) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      );
    }
    if (state is! OAuthAppsLoadedState) {
      return const Center(
        child: Text(
          'No OAuth apps yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    final apps = state.apps;
    if (apps.isEmpty) {
      return const Center(
        child: Text(
          'No OAuth apps yet',
          style: TextStyle(color: Colors.white54, fontSize: 13),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: apps.length,
      itemBuilder: (context, index) => _buildAppTile(context, apps[index]),
    );
  }

  Widget _buildAppTile(BuildContext context, OAuthAppEntity app) {
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
            backgroundColor: Colors.orangeAccent.withValues(alpha: 0.2),
            child: const Icon(Icons.lock, color: Colors.orangeAccent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name.isEmpty ? app.id : app.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Client ID: ${app.clientId}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                if (app.homepage.isNotEmpty)
                  Text(
                    app.homepage,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54, size: 18),
            tooltip: 'Regenerate secret',
            onPressed: () => context.read<OAuthAppsBloc>().add(
              RegenerateOAuthAppSecretEvent(app.id),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white54,
              size: 18,
            ),
            onPressed: () => _showEditDialog(context, app),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 18,
            ),
            onPressed: () => _showDeleteDialog(context, app.id),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final nameController = TextEditingController();
    final homepageController = TextEditingController();
    final callbacksController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Register OAuth App',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: nameController, label: 'App Name *'),
            const SizedBox(height: 12),
            _DialogField(controller: homepageController, label: 'Homepage URL'),
            const SizedBox(height: 12),
            _DialogField(
              controller: callbacksController,
              label: 'Callback URLs (comma separated) *',
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
              final callbacks = _commaSeparated(callbacksController.text);
              final name = nameController.text.trim();
              if (name.isNotEmpty && callbacks.isNotEmpty) {
                dialogContext.read<OAuthAppsBloc>().add(
                  RegisterOAuthAppEvent(
                    name: name,
                    homepage: homepageController.text.trim(),
                    callbackUrls: callbacks,
                  ),
                );
              }
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, OAuthAppEntity app) {
    final nameController = TextEditingController(text: app.name);
    final homepageController = TextEditingController(text: app.homepage);
    final callbacksController = TextEditingController(
      text: app.callbackUrls.join(', '),
    );
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Edit OAuth App',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogField(controller: nameController, label: 'App Name *'),
            const SizedBox(height: 12),
            _DialogField(controller: homepageController, label: 'Homepage URL'),
            const SizedBox(height: 12),
            _DialogField(
              controller: callbacksController,
              label: 'Callback URLs (comma separated) *',
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
              final callbacks = _commaSeparated(callbacksController.text);
              final name = nameController.text.trim();
              if (name.isNotEmpty && callbacks.isNotEmpty) {
                dialogContext.read<OAuthAppsBloc>().add(
                  UpdateOAuthAppEvent(
                    appId: app.id,
                    name: name,
                    homepage: homepageController.text.trim(),
                    callbackUrls: callbacks,
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

  void _showDeleteDialog(BuildContext context, String appId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Delete OAuth app?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This will permanently remove the OAuth application.',
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
              dialogContext.read<OAuthAppsBloc>().add(
                DeleteOAuthAppEvent(appId),
              );
              Navigator.of(dialogContext).pop();
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
