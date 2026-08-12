import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

class LoadingScreen extends StatelessWidget {
  final bool centered;
  final double size;

  const LoadingScreen({super.key, this.centered = true, this.size = 32});

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
        strokeWidth: 2.5,
      ),
    );

    if (!centered) return indicator;
    return Center(child: indicator);
  }
}

class NoResultsIndicator extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const NoResultsIndicator({super.key, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final muted = theme.centerChannelColor;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: muted.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            if (title != null)
              Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted.withValues(alpha: 0.75),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
