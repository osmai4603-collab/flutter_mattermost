import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/app/routes/channel_route.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        context.go(ChatRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/admin-onboarding-background.jpg',
            fit: BoxFit.cover,
          ),
          // Transparency Overlay
          Container(
            color: colors.centerChannelBg.withValues(alpha: isDark ? 0.7 : 0.3),
          ),
          // Progress Indicator
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
