import 'package:flutter/material.dart';
import 'package:flutter_mattermost/app/routes/integration_route.dart';
import 'package:go_router/go_router.dart';

enum IntegrationSection {
  incomingWebhooks,
  outgoingWebhooks,
  slashCommands,
  bots,
  oauthApps,
}

class IntegrationsPage extends StatefulWidget {
  const IntegrationsPage({
    super.key,
    this.teamId,
    required this.navigationShell,
  });

  final String? teamId;
  final StatefulNavigationShell navigationShell;

  @override
  State<IntegrationsPage> createState() => _IntegrationsPageState();
}

class _IntegrationsPageState extends State<IntegrationsPage> {
  IntegrationSection get _currentSection =>
      IntegrationSection.values[widget.navigationShell.currentIndex];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Row(
        children: [
          _buildSidebar(),
          const VerticalDivider(width: 1, color: Colors.white12),
          Expanded(
            child: widget.navigationShell,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: const Color(0xFF181825),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white54, size: 18),
                  onPressed: () => context.go('/${widget.teamId ?? 'home'}'),
                ),
                const Icon(
                  Icons.extension_outlined,
                  color: Colors.blueAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Integrations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSectionTile(
                  IntegrationSection.incomingWebhooks,
                  'Incoming Webhooks',
                  Icons.call_received_outlined,
                  IntegrationRoutes.incoming,
                ),
                _buildSectionTile(
                  IntegrationSection.outgoingWebhooks,
                  'Outgoing Webhooks',
                  Icons.call_made_outlined,
                  IntegrationRoutes.outgoing,
                ),
                _buildSectionTile(
                  IntegrationSection.slashCommands,
                  'Slash Commands',
                  Icons.terminal_outlined,
                  IntegrationRoutes.commands,
                ),
                _buildSectionTile(
                  IntegrationSection.bots,
                  'Bot Accounts',
                  Icons.smart_toy_outlined,
                  IntegrationRoutes.bots,
                ),
                _buildSectionTile(
                  IntegrationSection.oauthApps,
                  'OAuth Apps',
                  Icons.lock_outline,
                  IntegrationRoutes.oauth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTile(
    IntegrationSection section,
    String label,
    IconData icon,
    String route,
  ) {
    final isSelected = _currentSection == section;
    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor: Colors.blueAccent.withValues(alpha: 0.2),
      leading: Icon(
        icon,
        color: isSelected ? Colors.blueAccent : Colors.white54,
        size: 18,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 13,
        ),
      ),
      onTap: () {
        final path = route.replaceAll(':team', widget.teamId ?? 'home');
        context.go(path);
      },
    );
  }
}
