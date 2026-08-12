import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_plugins_bloc.dart';

/// صفحة إدارة الإضافات: قائمة المثبّتة + السوق.
class AdminConsolePluginsManagementPage extends StatefulWidget {
  const AdminConsolePluginsManagementPage({super.key});

  @override
  State<AdminConsolePluginsManagementPage> createState() => _AdminConsolePluginsManagementPageState();
}

class _AdminConsolePluginsManagementPageState extends State<AdminConsolePluginsManagementPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminPluginsBloc>()..add(LoadPluginsEvent()),
      child: BlocConsumer<AdminPluginsBloc, AdminPluginsState>(
        listener: (context, state) {
          if (state is PluginsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is PluginsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: switch (state) {
                  PluginsLoading() => const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  ),
                  PluginsLoaded() => _buildContent(context, state),
                  PluginsError() && final error => _buildError(
                    context,
                    error.message,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            Icons.extension_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Plugins Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text('Installed'),
                icon: Icon(Icons.check_circle_outline, size: 16),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Marketplace'),
                icon: Icon(Icons.store_outlined, size: 16),
              ),
            ],
            selected: {_tabIndex},
            onSelectionChanged: (selection) =>
                setState(() => _tabIndex = selection.first),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, PluginsLoaded state) {
    return _tabIndex == 0
        ? _buildInstalled(context, state.installed)
        : _buildMarketplace(context);
  }

  Widget _buildInstalled(BuildContext context, List<PluginEntity> plugins) {
    if (plugins.isEmpty) {
      return const Center(
        child: Text(
          'No plugins installed',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: plugins.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        final plugin = plugins[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                plugin.active ? Icons.extension : Icons.extension_off_outlined,
                color: plugin.active ? Colors.lightGreenAccent : Colors.white38,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plugin.name,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      plugin.id +
                          (plugin.version.isNotEmpty ? ' v${plugin.version}' : ''),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (plugin.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    plugin.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ),
              IconButton(
                tooltip: 'Uninstall',
                onPressed: () => context.read<AdminPluginsBloc>().add(
                  RemovePluginEvent(plugin.id),
                ),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white38,
                  size: 18,
                ),
              ),
              Switch(
                value: plugin.active,
                onChanged: (_) => context.read<AdminPluginsBloc>().add(
                  TogglePluginEvent(plugin),
                ),
                activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketplace(BuildContext context) {
    final state = context.read<AdminPluginsBloc>().state;
    if (state is! PluginsLoaded || state.marketplace.isEmpty) {
      return const Center(
        child: Text(
          'Marketplace is not available (server marketplace not configured)',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.marketplace.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        final plugin = state.marketplace[index];
        final installed = state.installed.any((p) => p.id == plugin.manifestId);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.extension_outlined,
                color: Colors.blueAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plugin.manifestName.isNotEmpty ? plugin.manifestName : (plugin.manifestId.isNotEmpty ? plugin.manifestId : 'Unknown plugin'),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      plugin.manifestDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (installed)
                const Text(
                  'Installed',
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 12,
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () => context.read<AdminPluginsBloc>().add(
                    InstallPluginEvent(plugin.manifestId),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                  child: const Text('Install'),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Text(
        'Could not load plugins: $message',
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
