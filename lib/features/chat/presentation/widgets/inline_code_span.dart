import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

/// كود سطري (`backtick`) — خلفية رمادية + خط monospace
/// (نظير InlineCodeSpan في webapp).
class InlineCodeSpan extends StatelessWidget {
  final String code;

  const InlineCodeSpan({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final onSurface = theme.centerChannelColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 12.5,
          color: onSurface.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}