import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/bots_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/incoming_webhooks_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/oauth_apps_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/outgoing_webhooks_page.dart';
import 'package:flutter_mattermost/features/integrations/presentation/pages/slash_commands_page.dart';

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
    this.initialSection = IntegrationSection.incomingWebhooks,
  });

  final String? teamId;
  final IntegrationSection initialSection;

  @override
  State<IntegrationsPage> createState() => _IntegrationsPageState();
}

class _IntegrationsPageState extends State<IntegrationsPage> {
  late IntegrationSection _selectedSection;

  @override
  void initState() {
    super.initState();
    _selectedSection = widget.initialSection;
  }

  @override
  Widget build(BuildContext context) {
    final teamId = widget.teamId;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Row(
        children: [
          _buildSidebar(),
          const VerticalDivider(width: 1, color: Colors.white12),
          Expanded(
            child: IndexedStack(
              index: _selectedSection.index,
              children: [
                IncomingWebhooksPage(teamId: teamId),
                OutgoingWebhooksPage(teamId: teamId),
                SlashCommandsPage(teamId: teamId ?? ''),
                BotsPage(),
                OAuthAppsPage(),
              ],
            ),
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
            child: const Row(
              children: [
                Icon(
                  Icons.extension_outlined,
                  color: Colors.blueAccent,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
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
                ),
                _buildSectionTile(
                  IntegrationSection.outgoingWebhooks,
                  'Outgoing Webhooks',
                  Icons.call_made_outlined,
                ),
                _buildSectionTile(
                  IntegrationSection.slashCommands,
                  'Slash Commands',
                  Icons.terminal_outlined,
                ),
                _buildSectionTile(
                  IntegrationSection.bots,
                  'Bot Accounts',
                  Icons.smart_toy_outlined,
                ),
                _buildSectionTile(
                  IntegrationSection.oauthApps,
                  'OAuth Apps',
                  Icons.lock_outline,
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
  ) {
    final isSelected = _selectedSection == section;
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
        setState(() {
          _selectedSection = section;
        });
      },
    );
  }
}
