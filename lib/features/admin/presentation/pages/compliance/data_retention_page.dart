import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_data_retention_repository.dart';

/// صفحة الاحتفاظ بالبيانات: السياسات + السياسة العامة.
class AdminConsoleDataRetentionPage extends StatefulWidget {
  const AdminConsoleDataRetentionPage({super.key});

  @override
  State<AdminConsoleDataRetentionPage> createState() =>
      _AdminConsoleDataRetentionPageState();
}

class _AdminConsoleDataRetentionPageState
    extends State<AdminConsoleDataRetentionPage> {
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
            results[0]
                as List<DataRetentionPolicyWithTeamAndChannelCountsModel>;
        _global = results[1] as Map<String, dynamic>?;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createPolicy() async {
    final colors = AppTheme.of(context);
    final nameController = TextEditingController();
    final daysController = TextEditingController(text: '90');
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.mentionHighlightBg,
        title: Text(
          'New Retention Policy',
          style: TextStyle(color: colors.centerChannelColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Policy name',
                hintText: 'e.g. Legal hold 90 days',
                labelStyle: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
                hintStyle: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.24),
                  ),
                ),
              ),
              style: TextStyle(color: colors.centerChannelColor),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Message retention days',
                labelStyle: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.24),
                  ),
                ),
              ),
              style: TextStyle(color: colors.centerChannelColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
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
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _deletePolicy(
    DataRetentionPolicyWithTeamAndChannelCountsModel policy,
  ) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.deletePolicy(policy.id ?? '');
      if (!mounted) return;
      _load();
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

  Future<void> _updateGlobalPolicy() async {
    final colors = AppTheme.of(context);
    final daysController = TextEditingController(
      text: (_global?['message_retention_days'] ?? 365).toString(),
    );
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.mentionHighlightBg,
        title: Text(
          'Global Retention Policy',
          style: TextStyle(color: colors.centerChannelColor),
        ),
        content: TextField(
          controller: daysController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Message retention days',
            labelStyle: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colors.centerChannelColor.withValues(alpha: 0.24),
              ),
            ),
          ),
          style: TextStyle(color: colors.centerChannelColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
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
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
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
              'Data Retention',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        'Could not load retention data: $_error',
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
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = AppTheme.of(context);
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
                style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
                icon: const Icon(Icons.add_outlined, size: 16),
                label: const Text('New Policy'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _load,
                icon: Icon(
                  Icons.refresh,
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Global Retention Policy',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.mentionHighlightBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.centerChannelColor.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.public, color: colors.buttonBg, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    globalDays == null
                        ? 'Applies to all teams and channels by default'
                        : 'Messages retained for $globalDays days, then permanently deleted',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _updateGlobalPolicy,
                  child: Text('Edit', style: TextStyle(color: colors.buttonBg)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Policies',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_policies.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'No retention policies yet',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                ),
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
                  color: colors.mentionHighlightBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.centerChannelColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: colors.awayIndicator,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.display_name ?? policy.id ?? '—',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Message retention: ${policy.post_duration ?? '—'} days',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.38,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _deletePolicy(policy),
                      icon: Icon(
                        Icons.delete_outline,
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
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
