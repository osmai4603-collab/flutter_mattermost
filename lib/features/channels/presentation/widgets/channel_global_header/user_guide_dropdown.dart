import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';

/// قائمة دليل المستخدم (علامة ?) — يطابق user_guide_dropdown.tsx في webapp:
/// دليل المستخدم، وثائق المنتج، اختصارات اللوحة، مجتمع، والإبلاغ عن مشكلة.
class UserGuideDropdown extends StatelessWidget {
  final AppLocalizations l10n;
  const UserGuideDropdown({super.key, required this.l10n});

  static const String _docsUrl = 'https://docs.mattermost.com';
  static const String _communityUrl = 'https://mattermost.com/community/';
  static const String _reportUrl = 'https://mattermost.com/pl/report-a-bug';

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return MatterMenuScope(
      items: [
        MatterMenuItem(
          id: 'user_guide',
          label: 'Mattermost user Guide',
          icon: const Icon(Icons.document_scanner, size: 18),
          onTap: () => _openUrl(context, _docsUrl),
        ),
        MatterMenuItem(
          id: 'training_resources',
          label: 'Training resources',
          icon: const Icon(Icons.lightbulb_circle_outlined, size: 18),
          onTap: () => _openUrl(context, '$_docsUrl/guides/'),
        ),
        MatterMenuItem(
          id: 'ask_community',
          label: 'Ask Community',
          icon: const Icon(Icons.question_mark, size: 18),
          onTap: () => _openUrl(context, _communityUrl),
        ),
        MatterMenuItem(
          id: 'report_a_problem',
          label: 'Report a problem',
          icon: const Icon(Icons.warning_outlined, size: 18),
          onTap: () => _openUrl(context, _reportUrl),
        ),
        MatterMenuItem(
          id: 'shortcuts',
          label: 'Keyboard Shortcuts',
          icon: const Icon(Icons.keyboard_alt_outlined, size: 18),
          separatorBefore: true,
          onTap: () {
            ModalRegistry.open(
              context,
              id: ModalIdentifiers.keyboardShortcuts,
            );
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          Icons.help_outline,
          size: 18,
          color: theme.sidebarText.withValues(alpha: 0.64),
        ),
      ),
    );
  }
}