import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// صفحة التحكم في الوصول القائم على السمات (Attribute-Based Access Control Page)
/// تدير إعدادات ABAC بما في ذلك التنشيط وتسجيل التدقيق ومؤشرات سياسة القناة.
class AttributeBasedAccessControlPage extends StatefulWidget {
  const AttributeBasedAccessControlPage({super.key});

  @override
  State<AttributeBasedAccessControlPage> createState() =>
      _AttributeBasedAccessControlPageState();
}

class _AttributeBasedAccessControlPageState
    extends State<AttributeBasedAccessControlPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  bool _enableABAC = false;
  bool _enableAuditLogging = false;
  bool _enableChannelPolicyIndicators = false;

  bool _originalEnableABAC = false;
  bool _originalEnableAuditLogging = false;
  bool _originalEnableChannelPolicyIndicators = false;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final config = await _repository.getConfig();
      final accessControlSettings =
          (config['AccessControlSettings'] as Map<String, dynamic>?) ?? const {};

      _enableABAC =
          accessControlSettings['EnableAttributeBasedAccessControl'] as bool? ??
              false;
      _enableAuditLogging =
          accessControlSettings['EnableAccessControlAuditLogging'] as bool? ??
              false;
      _enableChannelPolicyIndicators =
          accessControlSettings['EnableChannelPolicyIndicators'] as bool? ??
              false;

      _originalEnableABAC = _enableABAC;
      _originalEnableAuditLogging = _enableAuditLogging;
      _originalEnableChannelPolicyIndicators = _enableChannelPolicyIndicators;

      if (mounted) {
        setState(() => _hasChanges = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _checkChanges() {
    _hasChanges = _enableABAC != _originalEnableABAC ||
        _enableAuditLogging != _originalEnableAuditLogging ||
        _enableChannelPolicyIndicators != _originalEnableChannelPolicyIndicators;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final patch = {
        'AccessControlSettings': {
          'EnableAttributeBasedAccessControl': _enableABAC,
          'EnableAccessControlAuditLogging': _enableAuditLogging,
          'EnableChannelPolicyIndicators': _enableChannelPolicyIndicators,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        setState(() {
          _originalEnableABAC = _enableABAC;
          _originalEnableAuditLogging = _enableAuditLogging;
          _originalEnableChannelPolicyIndicators = _enableChannelPolicyIndicators;
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Access control settings saved successfully'),
            backgroundColor: AppTheme.of(context).onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: AppTheme.of(context).errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _cancelChanges() {
    setState(() {
      _enableABAC = _originalEnableABAC;
      _enableAuditLogging = _originalEnableAuditLogging;
      _enableChannelPolicyIndicators = _originalEnableChannelPolicyIndicators;
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header bar
        _buildHeader(context, colors),
        // Body
        Expanded(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(color: colors.buttonBg),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              color: colors.errorTextColor, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Error loading access control settings',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: TextStyle(
                              color: colors.centerChannelColor
                                  .withValues(alpha: 0.54),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Retry'),
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.buttonBg,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _buildForm(context, colors),
        ),
        // Save Changes Panel
        if (_hasChanges)
          SaveChangesPanel(
            isSaving: _isSaving,
            onSave: _save,
            onCancel: _cancelChanges,
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, MattermostColors colors) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border(
          bottom: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            color: colors.buttonBg,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Attribute-Based Access',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, MattermostColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enable ABAC Toggle
          AdminSettingSection(
            title: 'Attribute-Based Access Control',
            subtitle:
                'Allow access restrictions based on user attributes using custom access policies.',
            children: [
              AdminSettingField(
                label: 'Allow attribute based access controls on this server',
                description:
                    'When enabled, access restrictions can be enforced based on user attributes. '
                    'To effectively use this feature, you must define user attributes in the '
                    'User Attributes section.',
                child: Switch(
                  value: _enableABAC,
                  onChanged: (val) {
                    setState(() {
                      _enableABAC = val;
                      if (!val) {
                        _enableAuditLogging = false;
                        _enableChannelPolicyIndicators = false;
                      }
                      _checkChanges();
                    });
                  },
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          // Audit Logging Toggle
          AdminSettingSection(
            title: 'Audit Logging',
            subtitle: 'Configure audit logging for access control decisions.',
            children: [
              AdminSettingField(
                label:
                    'Enable audit logging for access control decisions',
                description: !_enableABAC
                    ? 'Requires attribute-based access control to be enabled and server audit logging to be active.'
                    : 'When enabled, attribute-based access control policy decisions are written to the server audit log. Requires server audit logging to be active.',
                child: Switch(
                  value: _enableAuditLogging,
                  onChanged: _enableABAC
                      ? (val) {
                          setState(() {
                            _enableAuditLogging = val;
                            _checkChanges();
                          });
                        }
                      : null,
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          // Channel Policy Indicators Toggle
          AdminSettingSection(
            title: 'Channel Access Indicators',
            subtitle: 'Configure visibility of channel access restrictions.',
            children: [
              AdminSettingField(
                label: 'Show channel access indicators to end users',
                description:
                    'When enabled, channels restricted by a membership access policy display '
                    'the matching user attributes as tags in the channel members list and the '
                    'invite dialog. Disable this to avoid revealing policy details to end users.',
                child: Switch(
                  value: _enableChannelPolicyIndicators,
                  onChanged: _enableABAC
                      ? (val) {
                          setState(() {
                            _enableChannelPolicyIndicators = val;
                            _checkChanges();
                          });
                        }
                      : null,
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.linkColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.linkColor.withValues(alpha: 0.24),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colors.linkColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Attribute-Based Access Control',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ABAC allows you to create policies that control channel access '
                        'based on user attributes. Define user attributes first, then create '
                        'membership policies to restrict channel membership. This feature '
                        'requires an Enterprise Advanced license.',
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(alpha: 0.60),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
