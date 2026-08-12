import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';

/// صفحة إنشاء فريق جديد — مطابقة لـ CreateTeam في webapp
class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      appBar: AppBar(
        backgroundColor: theme.centerChannelBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.centerChannelColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a new team',
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Team name and URL help your teammates find your workspace.',
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.72),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLabel(theme, 'Team Name'),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: theme.centerChannelColor),
                    decoration: InputDecoration(
                      hintText: 'e.g. Engineering',
                      filled: true,
                      fillColor: theme.centerChannelColor.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel(theme, 'Team URL'),
                  TextField(
                    controller: _urlController,
                    style: TextStyle(color: theme.centerChannelColor),
                    decoration: InputDecoration(
                      prefixText: 'mattermost.com/',
                      hintText: 'engineering',
                      filled: true,
                      fillColor: theme.centerChannelColor.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement team creation logic
                        context.go('/${_urlController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonBg,
                        foregroundColor: theme.buttonColor,
                      ),
                      child: const Text(
                        'Finish',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(MattermostColors theme, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
