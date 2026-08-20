import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة علامات الميزات (Feature Flags) - للقراءة فقط.
/// تطابق صفحة FeatureFlags في Mattermost webapp.
/// تعرض جميع علامات الميزات المفعلة على الخادم لأغراض التصحيح.
class FeatureFlagsPage extends StatefulWidget {
  const FeatureFlagsPage({super.key});

  @override
  State<FeatureFlagsPage> createState() => _FeatureFlagsPageState();
}

class _FeatureFlagsPageState extends State<FeatureFlagsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _loading = true;
  String? _error;
  Map<String, dynamic> _featureFlags = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final config = await _repository.getConfig();
      if (!mounted) return;
      final flags =
          (config['FeatureFlags'] as Map<String, dynamic>?) ?? const {};
      setState(() => _featureFlags = flags);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(color: colors.buttonBg),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load feature flags: $_error',
                    style: TextStyle(color: colors.errorTextColor),
                  ),
                )
              : _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = AppTheme.of(context);

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_outlined, color: colors.buttonBg, size: 20),
          const SizedBox(width: 10),
          Text(
            'Feature Flags',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = AppTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.linkColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.linkColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.linkColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'The following feature flag values show the status of features enabled on this instance. The values are used for debugging purposes by the Mattermost support team.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.centerChannelColor.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              border: Border.all(
                color: colors.centerChannelColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Flag',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Value',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table rows
          if (_featureFlags.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.mentionHighlightBg,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
                border: Border.all(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              child: Text(
                'No feature flags available',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  fontSize: 13,
                ),
              ),
            )
          else
            ..._featureFlags.entries.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final flag = entry.value;
              final isLast = index == _featureFlags.length - 1;
              final isEven = index.isEven;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isEven
                      ? colors.centerChannelColor.withValues(alpha: 0.03)
                      : colors.mentionHighlightBg,
                  borderRadius: isLast
                      ? const BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        )
                      : null,
                  border: Border(
                    bottom: isLast
                        ? BorderSide.none
                        : BorderSide(
                            color: colors.centerChannelColor.withValues(
                              alpha: 0.06,
                            ),
                          ),
                    left: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                    right: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Text(
                        flag.key,
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.70,
                          ),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getFlagValueColor(
                            flag.value,
                            colors,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${flag.value}',
                          style: TextStyle(
                            color: _getFlagValueColor(flag.value, colors),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 16),

          // Refresh button
          Row(
            children: [
              FilledButton.icon(
                onPressed: _loading ? null : _load,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.buttonBg,
                ),
                icon: Icon(
                  Icons.refresh,
                  size: 16,
                  color: colors.buttonColor,
                ),
                label: Text(
                  'Refresh',
                  style: TextStyle(color: colors.buttonColor),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_featureFlags.length} flags',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getFlagValueColor(dynamic value, MattermostColors colors) {
    if (value == true) return colors.onlineIndicator;
    if (value == false) return colors.awayIndicator;
    return colors.linkColor;
  }
}
