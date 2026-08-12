import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_access_control_repository.dart';

/// صفحة سياسات التحكم بالوصول: قائمة السياسات + أدوات CEL.
class AdminConsoleAccessControlPage extends StatefulWidget {
  const AdminConsoleAccessControlPage({super.key});

  @override
  State<AdminConsoleAccessControlPage> createState() => _AdminConsoleAccessControlPageState();
}

class _AdminConsoleAccessControlPageState extends State<AdminConsoleAccessControlPage> {
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
    final nameController = TextEditingController();
    final exprController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text(
          'New Access Control Policy',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Policy name',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: exprController,
              decoration: const InputDecoration(
                labelText: 'CEL expression',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
              ),
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
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _activatePolicy(AccessControlPolicyEntity policy) async {
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
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _deletePolicy(AccessControlPolicyEntity policy) async {
    try {
      await _repository.deletePolicy(policy.id!);
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

  Future<void> _runCelCheck() async {
    final exprController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text('CEL Check', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: exprController,
          decoration: const InputDecoration(
            labelText: 'CEL expression',
            labelStyle: TextStyle(color: Colors.white54),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
          style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
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
                      'Could not load access control policies: $_error',
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
          Icon(
            Icons.admin_panel_settings_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Access Control',
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
                onPressed: _createPolicy,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.add_outlined, size: 16),
                label: const Text('New Policy'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _runCelCheck,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                icon: const Icon(Icons.code_outlined, size: 16),
                label: const Text('CEL Check'),
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
                'No access control policies yet',
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
                    Icon(
                      policy.is_active == true
                          ? Icons.shield_outlined
                          : Icons.shield_outlined,
                      color: policy.is_active == true
                          ? Colors.lightGreenAccent
                          : Colors.orangeAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.display_name ?? '-',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            policy.expression != null
                                ? policy.expression!
                                : 'Active: ${policy.is_active == true ? 'Active' : 'Inactive'}',
                            style: const TextStyle(
                              color: Colors.white38,
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
                        icon: const Icon(
                          Icons.power_settings_new,
                          color: Colors.lightGreenAccent,
                          size: 18,
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
