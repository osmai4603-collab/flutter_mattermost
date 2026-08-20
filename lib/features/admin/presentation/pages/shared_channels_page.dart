import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_shared_channels_repository.dart';

/// صفحة القنوات المشتركة: حالة الـ remotes + فحص DM بين مستخدمين.
class AdminConsoleSharedChannelsPage extends StatefulWidget {
  const AdminConsoleSharedChannelsPage({super.key});

  @override
  State<AdminConsoleSharedChannelsPage> createState() => _AdminConsoleSharedChannelsPageState();
}

class _AdminConsoleSharedChannelsPageState extends State<AdminConsoleSharedChannelsPage> {
  final AdminSharedChannelsRepository _repository =
      getIt<AdminSharedChannelsRepository>();

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _repository.canUserDm('me', 'me');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('DM check ok: ${result['allowed'] ?? result}')),
      );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _lookupRemote() async {
    final colors = AppTheme.of(context);
    final remoteController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.mentionHighlightBg,
        title: Text('Remote Info', style: TextStyle(color: colors.centerChannelColor)),
        content: TextField(
          controller: remoteController,
          decoration: InputDecoration(
            labelText: 'Remote ID',
            labelStyle: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.centerChannelColor.withValues(alpha: 0.24)),
            ),
          ),
          style: TextStyle(color: colors.centerChannelColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54)),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
            child: const Text('Lookup'),
          ),
        ],
      ),
    );
    final remoteId = remoteController.text.trim();
    if (ok != true || remoteId.isEmpty) return;
    try {
      final info = await _repository.getRemoteInfo(remoteId);
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: colors.mentionHighlightBg,
          title: Text('Remote', style: TextStyle(color: colors.centerChannelColor)),
          content: Text(
            'Display name: ${info.display_name ?? '—'}\n'
            'Last ping: ${info.last_ping_at ?? '—'}',
            style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.70), fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: colors.centerChannelColor.withValues(alpha: 0.54)),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: colors.errorTextColor,
        ),
      );
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Shared channels require an Enterprise license: $_error',
                      style: TextStyle(
                        color: colors.errorTextColor,
                        fontSize: 13,
                      ),
                    ),
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
        border: Border(bottom: BorderSide(color: colors.centerChannelColor.withValues(alpha: 0.12))),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: colors.buttonBg, size: 20),
          const SizedBox(width: 10),
          Text(
            'Shared Channels',
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
          Row(
            children: [
              FilledButton.icon(
                onPressed: _lookupRemote,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.buttonBg,
                ),
                icon: const Icon(Icons.search_outlined, size: 16),
                label: const Text('Remote Info'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _check,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.buttonBg,
                  side: BorderSide(color: colors.buttonBg),
                ),
                icon: const Icon(Icons.sync_outlined, size: 16),
                label: const Text('DM Connectivity Check'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _check,
                icon: Icon(Icons.refresh, color: colors.centerChannelColor.withValues(alpha: 0.54)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.mentionHighlightBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.centerChannelColor.withValues(alpha: 0.12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Shared channels let teams on different Mattermost servers collaborate '
                  'in the same channel. Use Remote Info to inspect a connected remote server, '
                  'and the connectivity check to verify whether direct messages can pass '
                  'between two servers.',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 13,
                    height: 1.5,
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
