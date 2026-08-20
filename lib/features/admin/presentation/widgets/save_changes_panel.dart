import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

class SaveChangesPanel extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const SaveChangesPanel({
    super.key,
    required this.isSaving,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        border: Border(
          top: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.linkColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have unsaved changes',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: isSaving ? null : onCancel,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colors.centerChannelColor.withValues(alpha: 0.24),
              ),
              foregroundColor: colors.buttonColor.withValues(alpha: 0.70),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
            icon: isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.buttonColor,
                    ),
                  )
                : Icon(
                    Icons.save_outlined,
                    size: 16,
                    color: colors.buttonColor,
                  ),
            label: Text(isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}
