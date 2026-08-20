import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_access_control_repository.dart';

/// صفحة سياسات التحكم بالوصول: قائمة السياسات + أدوات CEL.
class AdminConsoleAccessControlPage extends StatefulWidget {
  const AdminConsoleAccessControlPage({super.key});

  @override
  State<AdminConsoleAccessControlPage> createState() =>
      _AdminConsoleAccessControlPageState();
}

class _AdminConsoleAccessControlPageState
    extends State<AdminConsoleAccessControlPage> {
  final AdminAccessControlRepository _repository =
      getIt<AdminAccessControlRepository>();

  List<AccessControlPolicyEntity> _policies = [];
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
      final policies = await _repository.getPolicies(perPage: 100);
      if (!mounted) return;
      setState(() => _policies = policies);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createPolicy() async {
    final colors = AppTheme.of(context);
    final nameController = TextEditingController();
    final exprController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.mentionHighlightBg,
        title: Text(
          'New Access Control Policy',
          style: TextStyle(color: colors.centerChannelColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Policy name',
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
            const SizedBox(height: 12),
            TextField(
              controller: exprController,
              decoration: InputDecoration(
                labelText: 'CEL expression',
                labelStyle: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.24),
                  ),
                ),
              ),
              style: TextStyle(
                color: colors.centerChannelColor,
                fontFamily: 'monospace',
              ),
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
        'name': nameController.text.trim(),
        'cel_expression': exprController.text.trim(),
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

  Future<void> _activatePolicy(AccessControlPolicyEntity policy) async {
    final colors = AppTheme.of(context);
    try {
      final result = await _repository.activatePolicy({'name': policy.name});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activated: ${result['status'] ?? 'ok'}')),
      );
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

  Future<void> _deletePolicy(AccessControlPolicyEntity policy) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.deletePolicy(policy.id!);
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

  Future<void> _runCelCheck() async {
    final colors = AppTheme.of(context);
    final exprController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.mentionHighlightBg,
        title: Text(
          'CEL Check',
          style: TextStyle(color: colors.centerChannelColor),
        ),
        content: TextField(
          controller: exprController,
          decoration: InputDecoration(
            labelText: 'CEL expression',
            labelStyle: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colors.centerChannelColor.withValues(alpha: 0.24),
              ),
            ),
          ),
          style: TextStyle(
            color: colors.centerChannelColor,
            fontFamily: 'monospace',
          ),
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
            child: const Text('Run'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final result = await _repository.celCheck({
        'cel_expression': exprController.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEL check OK: ${result['valid'] ?? result}')),
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
              'Access Control',
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
                        'Could not load access control policies: $_error',
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
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _runCelCheck,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.buttonBg,
                  side: BorderSide(color: colors.buttonBg),
                ),
                icon: const Icon(Icons.code_outlined, size: 16),
                label: const Text('CEL Check'),
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
                'No access control policies yet',
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
                      policy.is_active == true
                          ? Icons.shield_outlined
                          : Icons.shield_outlined,
                      color: policy.is_active == true
                          ? colors.onlineIndicator
                          : colors.awayIndicator,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.display_name ?? '-',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            policy.expression != null
                                ? policy.expression!
                                : 'Active: ${policy.is_active == true ? 'Active' : 'Inactive'}',
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
                    if (policy.is_active != true)
                      IconButton(
                        tooltip: 'Activate',
                        onPressed: () => _activatePolicy(policy),
                        icon: Icon(
                          Icons.power_settings_new,
                          color: colors.onlineIndicator,
                          size: 18,
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
