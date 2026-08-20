import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات حسابات الضيوف (Guest Access Settings Page)
class AdminConsoleAuthGuestAccessPage extends StatefulWidget {
  const AdminConsoleAuthGuestAccessPage({super.key});

  @override
  State<AdminConsoleAuthGuestAccessPage> createState() =>
      _AdminConsoleAuthGuestAccessPageState();
}

class _AdminConsoleAuthGuestAccessPageState
    extends State<AdminConsoleAuthGuestAccessPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableGuests = false;
  bool _allowGuestsToInvite = false;
  final TextEditingController _restrictDomainsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final guestSettings =
          (config['GuestAccountsSettings'] as Map<String, dynamic>?) ??
          const {};

      _enableGuests = guestSettings['Enable'] as bool? ?? false;
      _allowGuestsToInvite =
          guestSettings['AllowGuestsToInvite'] as bool? ?? false;
      _restrictDomainsController.text =
          guestSettings['RestrictCreationToDomains'] as String? ?? '';
    } catch (_) {
      // الاحتفاظ بالقيم الافتراضية
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      final patch = {
        'GuestAccountsSettings': {
          'Enable': _enableGuests,
          'AllowGuestsToInvite': _allowGuestsToInvite,
          'RestrictCreationToDomains': _restrictDomainsController.text.trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Guest Access settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save Guest Access settings: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _restrictDomainsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Guest Access',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  // Settings Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.centerChannelBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          value: _enableGuests,
                          onChanged: (val) =>
                              setState(() => _enableGuests = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Guest Access',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, external contractors and guests can be invited to specific channels only.',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Divider(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.10,
                          ),
                          height: 24,
                        ),
                        SwitchListTile(
                          value: _allowGuestsToInvite,
                          onChanged: _enableGuests
                              ? (val) =>
                                    setState(() => _allowGuestsToInvite = val)
                              : null,
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Allow Guests to Invite Users',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, guests can send channel invitations to other users.',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Divider(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.10,
                          ),
                          height: 24,
                        ),
                        Text(
                          'Restrict Guest Email Domains:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _restrictDomainsController,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. partner.com, vendor.org',
                            hintStyle: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.38,
                              ),
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: colors.centerChannelBg.withValues(
                              alpha: 0.60,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
