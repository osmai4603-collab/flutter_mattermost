import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

/// صفحة تحضير مساحة العمل — مطابقة لـ PreparingWorkspace في webapp
class PreparingWorkspacePage extends StatefulWidget {
  const PreparingWorkspacePage({super.key});

  @override
  State<PreparingWorkspacePage> createState() => _PreparingWorkspacePageState();
}

class _PreparingWorkspacePageState extends State<PreparingWorkspacePage> {
  @override
  void initState() {
    super.initState();
    _startSetup();
  }

  Future<void> _startSetup() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: theme.centerChannelBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.buttonBg),
            const SizedBox(height: 32),
            Text(
              'Preparing your workspace...',
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Setting up your workspace and channels.',
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.64),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
