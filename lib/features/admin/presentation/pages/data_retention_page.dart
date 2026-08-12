import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_data_retention_repository.dart';

/// صفحة الاحتفاظ بالبيانات: السياسات + السياسة العامة.
class AdminConsoleDataRetentionPage extends StatefulWidget {
  const AdminConsoleDataRetentionPage({super.key});

  @override
  State<AdminConsoleDataRetentionPage> createState() => _AdminConsoleDataRetentionPageState();
}

class _AdminConsoleDataRetentionPageState extends State<AdminConsoleDataRetentionPage> {
  final AdminDataRetentionRepository _repository =
      getIt<AdminDataRetentionRepository>();

  List<DataRetentionPolicyWithTeamAndChannelCountsModel> _policies = [];
  Map<String, dynamic>? _global;
  bool _loading = true;
  String? _error;

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
      final results = await Future.wait<dynamic>([
        _repository.getPolicies(perPage: 100),
        _repository.getGlobalPolicy(),
      ]);
      if (!mounted) return;
      setState(() {
        _policies =
            results[0] as List<DataRetentionPolicyWithTeamAndChannelCountsModel>;
        _global = results[1] as Map<String, dynamic>?;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createPolicy() async {
    final nameController = TextEditingController();
    final daysController = TextEditingController(text: '90');
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Retention Policy',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Policy name',
                hintText: 'e.g. Legal hold 90 days',
                labelStyle: TextStyle(color: Colors.white54),
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Message retention days',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
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
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (ok != true || nameController.text.trim().isEmpty) return;
    try {
      await _repository.createPolicy({
        'display_name': nameController.text.trim(),
        'message_retention_days':
            int.tryParse(daysController.text.trim()) ?? 90,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Policy created')));
      _load();
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

  Future<void> _deletePolicy(
    DataRetentionPolicyWithTeamAndChannelCountsModel policy,
  ) async {
    try {
      await _repository.deletePolicy(policy.id ?? '');
      if (!mounted) return;
      _load();
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

  Future<void> _updateGlobalPolicy() async {
    final daysController = TextEditingController(
      text: (_global?['message_retention_days'] ?? 365).toString(),
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'Global Retention Policy',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: daysController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Message retention days',
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _repository.updateGlobalPolicy({
        ...?_global,
        'message_retention_days':
            int.tryParse(daysController.text.trim()) ?? 365,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Global policy saved')));
      _load();
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
                      'Could not load retention data: $_error',
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
          Icon(Icons.history_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Data Retention',
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
    final globalDays = _global?['message_retention_days'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: _createPolicy,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.add_outlined, size: 16),
                label: const Text('New Policy'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _load,
                icon: const Icon(Icons.refresh, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Global Retention Policy',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF181825),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Icon(Icons.public, color: Colors.blueAccent, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    globalDays == null
                        ? 'Applies to all teams and channels by default'
                        : 'Messages retained for $globalDays days, then permanently deleted',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: _updateGlobalPolicy,
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Policies',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_policies.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No retention policies yet',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            for (final policy in _policies)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF181825),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      color: Colors.orangeAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.display_name ?? policy.id ?? '—',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Message retention: ${policy.post_duration ?? '—'} days',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _deletePolicy(policy),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white38,
                        size: 18,
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
