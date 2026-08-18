import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/features/channels/presentation/widgets/quick_switcher.dart';

/// واجهة متميزة تُعرض عند عدم تحديد أي قناة حالية أو عدم توفر قنوات —
/// تستخدم صورة توضيحية من assets/images مع خيارات للتنقل السريع.
class NoChannelSelectedView extends StatelessWidget {
  const NoChannelSelectedView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      color: theme.centerChannelBg,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 340, maxHeight: 240),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.centerChannelBg,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/welcome_illustration_new.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/cloud-laptop.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 96,
                      color: theme.centerChannelColor.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'مرحباً بك في مساحة العمل',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.centerChannelColor,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Text(
                  'اختر قناة من الشريط الجانبي لبدء المحادثة، أو استخدم التصفح السريع للانتقال المباشر لأي قناة.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: theme.centerChannelColor.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => showQuickSwitcher(context),
                icon: const Icon(Icons.search_rounded, size: 18),
                label: Text(l10n.sidebarLeftJumpTo),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.buttonBg,
                  foregroundColor: theme.buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  ),
                  elevation: 1,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
