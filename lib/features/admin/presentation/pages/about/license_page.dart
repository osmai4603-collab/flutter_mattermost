import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/license_info_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_license_bloc.dart';

/// صفحة الترخيص: عرض الترخيص الحالي + رفع/إزالة ترخيص + الترقية.
class AdminConsoleLicensePage extends StatelessWidget {
  const AdminConsoleLicensePage({super.key});

  Future<void> _pickAndUpload(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mlt', 'lic'],
      allowMultiple: false,
    );
    if (!context.mounted) return;
    if (result == null || result.files.isEmpty) {
      return;
    }
    final path = result.files.first.path;
    if (path == null) return;
    context.read<AdminLicenseBloc>().add(UploadLicenseEvent(path));
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return BlocProvider(
      create: (_) => getIt<AdminLicenseBloc>()..add(LoadLicenseEvent()),
      child: BlocConsumer<AdminLicenseBloc, AdminLicenseState>(
        listener: (context, state) {
          if (state is AdminLicenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.errorTextColor,
              ),
            );
          } else if (state is AdminLicenseActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.onlineIndicator,
              ),
            );
          } else if (state is AdminLicenseLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('License loaded'),
                backgroundColor: colors.onlineIndicator,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: switch (state) {
                  AdminLicenseLoading() => Center(
                    child: CircularProgressIndicator(color: colors.buttonBg),
                  ),
                  AdminLicenseLoaded() => _buildLicense(context, state.license),
                  AdminLicenseError() && final error => _buildEmpty(
                    context,
                    error.message,
                  ),
                  _ => _buildEmpty(context),
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = AppTheme.of(context);

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.centerChannelColor.withValues(alpha: 0.12))),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            color: colors.buttonBg,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'License',
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

  Widget _buildLicense(BuildContext context, LicenseInfoEntity license) {
    final colors = AppTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.centerChannelColor.withValues(alpha: 0.12)),
              gradient: license.licensed
                  ? LinearGradient(
                      colors: [colors.buttonBg.withValues(alpha: 0.3), colors.mentionHighlightBg],
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      license.licensed
                          ? Icons.verified_outlined
                          : Icons.lock_open_outlined,
                      color: license.licensed
                          ? colors.onlineIndicator
                          : colors.centerChannelColor.withValues(alpha: 0.38),
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      license.licensed
                          ? 'Enterprise License (E10/E20)'
                          : 'No License',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _infoRow('License ID', license.id, colors),
                _infoRow('Name', license.name, colors),
                _infoRow('Company', license.company, colors),
                _infoRow(
                  'Sku',
                  [
                    license.skuShortName,
                    license.skuEdition,
                  ].where((e) => e.isNotEmpty).join(' - '),
                  colors,
                ),
                _infoRow('Users', license.users.toString(), colors),
                _infoRow('Issued At', _dateString(license.issuedAt), colors),
                _infoRow('Starts At', _dateString(license.startsAt), colors),
                _infoRow('Expires At', _dateString(license.expiresAt), colors),
                _infoRow('Trial', license.trial ? 'Yes' : 'No', colors),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _pickAndUpload(context),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.buttonBg,
                ),
                icon: const Icon(Icons.upload_file_outlined, size: 16),
                label: const Text('Upload License File'),
              ),
              const SizedBox(width: 12),
              if (license.licensed)
                OutlinedButton.icon(
                  onPressed: () => context.read<AdminLicenseBloc>().add(
                    RemoveLicenseEvent(),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.errorTextColor,
                    side: BorderSide(color: colors.errorTextColor),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove License'),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => context.read<AdminLicenseBloc>().add(
                  UpgradeToEnterpriseEvent(),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.awayIndicator,
                  side: BorderSide(color: colors.awayIndicator),
                ),
                icon: const Icon(Icons.upgrade_outlined, size: 16),
                label: const Text('Upgrade to Enterprise'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, [String? error]) {
    final colors = AppTheme.of(context);

    return Center(
      child: Text(
        error ?? 'No license information available.',
        style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54)),
      ),
    );
  }

  Widget _infoRow(String label, String value, MattermostColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dateString(int epochSeconds) {
    if (epochSeconds == 0) return '—';
    return DateTime.fromMillisecondsSinceEpoch(
      epochSeconds * 1000,
    ).toLocal().toString().split('.').first;
  }
}
