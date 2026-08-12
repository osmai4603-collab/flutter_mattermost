import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
    final remoteController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text('Remote Info', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: remoteController,
          decoration: const InputDecoration(
            labelText: 'Remote ID',
            labelStyle: TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
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
          backgroundColor: const Color(0xFF181825),
          title: const Text('Remote', style: TextStyle(color: Colors.white)),
          content: Text(
            'Display name: ${info.display_name ?? '—'}\n'
            'Last ping: ${info.last_ping_at ?? '—'}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white54),
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
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Shared channels require an Enterprise license: $_error',
                      style: const TextStyle(
                        color: Colors.redAccent,
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
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Shared Channels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
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
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.search_outlined, size: 16),
                label: const Text('Remote Info'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _check,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                icon: const Icon(Icons.sync_outlined, size: 16),
                label: const Text('DM Connectivity Check'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _check,
                icon: const Icon(Icons.refresh, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF181825),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Shared channels let teams on different Mattermost servers collaborate '
                  'in the same channel. Use Remote Info to inspect a connected remote server, '
                  'and the connectivity check to verify whether direct messages can pass '
                  'between two servers.',
                  style: TextStyle(
                    color: Colors.white70,
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
