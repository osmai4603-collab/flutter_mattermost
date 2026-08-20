import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';

/// بطاقة قسم إعدادات: عنوان + وصف + محتوى اختياري.
class AdminSettingSection extends StatelessWidget {
  const AdminSettingSection({
    super.key,
    required this.title,
    this.subtitle,
    this.children = const [],
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.centerChannelColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54), fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

/// صف إعداد واحد: تسمية + وصف + وحدة تحكم.
class AdminSettingField extends StatelessWidget {
  const AdminSettingField({
    super.key,
    required this.label,
    this.description,
    required this.child,
  });

  final String label;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54), fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: child,
          ),
        ],
      ),
    );
  }
}
