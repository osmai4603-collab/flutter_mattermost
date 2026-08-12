import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

class TagPill extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? foreground;

  const TagPill({
    super.key,
    required this.label,
    this.background,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: background ?? theme.centerChannelColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foreground ?? theme.centerChannelColor.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}
