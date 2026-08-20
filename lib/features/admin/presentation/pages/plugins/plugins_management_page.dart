import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_plugins_bloc.dart';

/// صفحة إدارة الإضافات: قائمة المثبّتة + السوق.
class AdminConsolePluginsManagementPage extends StatefulWidget {
  const AdminConsolePluginsManagementPage({super.key});

  @override
  State<AdminConsolePluginsManagementPage> createState() =>
      _AdminConsolePluginsManagementPageState();
}

class _AdminConsolePluginsManagementPageState
    extends State<AdminConsolePluginsManagementPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return BlocProvider(
      create: (_) => getIt<AdminPluginsBloc>()..add(LoadPluginsEvent()),
      child: BlocConsumer<AdminPluginsBloc, AdminPluginsState>(
        listener: (context, state) {
          if (state is PluginsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.errorTextColor,
              ),
            );
          } else if (state is PluginsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.onlineIndicator,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: Container(
                color: colors.centerChannelBg,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Plugins',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: switch (state) {
                    PluginsLoading() => Center(
                      child: CircularProgressIndicator(color: colors.buttonBg),
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PluginsLoaded state) {
    return _tabIndex == 0
        ? _buildInstalled(context, state.installed)
        : _buildMarketplace(context);
  }

  Widget _buildInstalled(BuildContext context, List<PluginEntity> plugins) {
    final colors = AppTheme.of(context);

    if (plugins.isEmpty) {
      return Center(
        child: Text(
          'No plugins installed',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.38),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: plugins.length,
      separatorBuilder: (_, _) => Divider(
        color: colors.centerChannelColor.withValues(alpha: 0.10),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final plugin = plugins[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                plugin.active ? Icons.extension : Icons.extension_off_outlined,
                color: plugin.active
                    ? colors.onlineIndicator
                    : colors.centerChannelColor.withValues(alpha: 0.38),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plugin.name,
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      plugin.id +
                          (plugin.version.isNotEmpty
                              ? ' v${plugin.version}'
                              : ''),
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
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
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Uninstall',
                onPressed: () => context.read<AdminPluginsBloc>().add(
                  RemovePluginEvent(plugin.id),
                ),
                icon: Icon(
                  Icons.delete_outline,
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  size: 18,
                ),
              ),
              Switch(
                value: plugin.active,
                onChanged: (_) => context.read<AdminPluginsBloc>().add(
                  TogglePluginEvent(plugin),
                ),
                activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMarketplace(BuildContext context) {
    final colors = AppTheme.of(context);
    final state = context.read<AdminPluginsBloc>().state;
    if (state is! PluginsLoaded || state.marketplace.isEmpty) {
      return Center(
        child: Text(
          'Marketplace is not available (server marketplace not configured)',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.38),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.marketplace.length,
      separatorBuilder: (_, _) => Divider(
        color: colors.centerChannelColor.withValues(alpha: 0.10),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final plugin = state.marketplace[index];
        final installed = state.installed.any((p) => p.id == plugin.manifestId);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.extension_outlined, color: colors.buttonBg, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plugin.manifestName.isNotEmpty
                          ? plugin.manifestName
                          : (plugin.manifestId.isNotEmpty
                                ? plugin.manifestId
                                : 'Unknown plugin'),
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      plugin.manifestDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (installed)
                Text(
                  'Installed',
                  style: TextStyle(color: colors.onlineIndicator, fontSize: 12),
                )
              else
                OutlinedButton(
                  onPressed: () => context.read<AdminPluginsBloc>().add(
                    InstallPluginEvent(plugin.manifestId),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.buttonBg,
                    side: BorderSide(color: colors.buttonBg),
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
    final colors = AppTheme.of(context);

    return Center(
      child: Text(
        'Could not load plugins: $message',
        style: TextStyle(color: colors.errorTextColor),
      ),
    );
  }
}
