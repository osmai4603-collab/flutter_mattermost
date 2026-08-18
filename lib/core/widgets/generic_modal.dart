import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';

/// نافذة منبثقة عامة — مطابقة components/GenericModal في webapp:
/// header (عنوان + زر إغلاق) + body + footer اختياري بأزرار.
/// تُفتح عادة عبر ModalRegistry (خلفية داكنة + fade 200ms).
class GenericModal extends StatelessWidget {
  final String title;
  final Widget body;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? dismissLabel;
  final VoidCallback? onDismiss;
  final double width;
  final double fontSize;
  final Widget? extraFooter;

  const GenericModal({
    super.key,
    required this.title,
    required this.body,
    this.confirmLabel,
    this.onConfirm,
    this.dismissLabel,
    this.onDismiss,
    this.width = 600,
    this.fontSize = 16,
    this.extraFooter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasFooter =
        confirmLabel != null || onDismiss != null || dismissLabel != null;

    return Center(
      child: Material(
        color: theme.centerChannelBg,
        elevation: 8,
        borderRadius: BorderRadius.circular(DesignTokens.dialogRadius),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.centerChannelColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: body,
                ),
              ),
              if (hasFooter || extraFooter != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Row(
                    children: [
                      if (extraFooter != null) extraFooter!,
                      const Spacer(),
                      if (dismissLabel != null || onDismiss != null)
                        TextButton(
                          onPressed:
                              onDismiss ?? () => Navigator.of(context).pop(),
                          child: Text(
                            dismissLabel ?? l10n.generic_modalConfirm,
                          ),
                        ),
                      if (confirmLabel != null) ...[
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.buttonBg,
                            foregroundColor: theme.buttonColor,
                          ),
                          onPressed:
                              onConfirm ?? () => Navigator.of(context).pop(),
                          child: Text(confirmLabel!),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
