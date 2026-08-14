import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guest Access settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save Guest Access settings: $e'),
            backgroundColor: Colors.redAccent,
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Title & Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Guest Access Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure external guest accounts and access permissions.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.purpleAccent.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: const Text(
                              'ENT',
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isSaving ? null : _saveConfig,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_rounded, size: 18),
                            label: Text(
                              _isSaving ? 'Saving...' : 'Save Changes',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Settings Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          value: _enableGuests,
                          onChanged: (val) =>
                              setState(() => _enableGuests = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Guest Access',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, external contractors and guests can be invited to specific channels only.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        SwitchListTile(
                          value: _allowGuestsToInvite,
                          onChanged: _enableGuests
                              ? (val) =>
                                    setState(() => _allowGuestsToInvite = val)
                              : null,
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Allow Guests to Invite Users',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, guests can send channel invitations to other users.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        const Text(
                          'Restrict Guest Email Domains:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _restrictDomainsController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. partner.com, vendor.org',
                            hintStyle: const TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                            filled: true,
                            fillColor: const Color(0xFF212433),
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
