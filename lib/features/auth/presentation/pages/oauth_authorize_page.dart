import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

/// صفحة تخويل OAuth — مطابقة لـ OAuthAuthorize في webapp
class OAuthAuthorizePage extends StatelessWidget {
  final String? appName;

  const OAuthAuthorizePage({super.key, this.appName});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 64, color: theme.buttonBg),
                  const SizedBox(height: 24),
                  Text(
                    'Authorize ${appName ?? 'App'}?',
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'The app "${appName ?? 'Application'}" would like the ability to access and modify your basic information.',
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.72),
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: theme.buttonBg),
                            foregroundColor: theme.buttonBg,
                          ),
                          child: const Text('Deny'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: theme.buttonBg,
                            foregroundColor: theme.buttonColor,
                          ),
                          child: const Text('Allow'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
