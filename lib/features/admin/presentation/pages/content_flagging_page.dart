import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_field_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_content_flagging_repository.dart';

/// صفحة تأشير المحتوى: الإعدادات + الحقول + حالة الفرق.
class AdminConsoleContentFlaggingPage extends StatefulWidget {
  const AdminConsoleContentFlaggingPage({super.key});

  @override
  State<AdminConsoleContentFlaggingPage> createState() => _AdminConsoleContentFlaggingPageState();
}

class _AdminConsoleContentFlaggingPageState extends State<AdminConsoleContentFlaggingPage> {
  final AdminContentFlaggingRepository _repository =
      getIt<AdminContentFlaggingRepository>();

  Map<String, dynamic>? _config;
  List<CustomAttributeFieldModel> _fields = [];
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
        _repository.getConfig(),
        _repository.getFields(),
      ]);
      if (!mounted) return;
      setState(() {
        _config = results[0] as Map<String, dynamic>?;
        _fields = results[1] as List<CustomAttributeFieldModel>;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _checkPost() async {
    final postController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF181825),
        title: const Text('Review Post', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: postController,
          decoration: const InputDecoration(
            labelText: 'Post ID',
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
            child: const Text('Review'),
          ),
        ],
      ),
    );
    final postId = postController.text.trim();
    if (ok != true || postId.isEmpty) return;
    try {
      final post = await _repository.getPost(postId);
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF181825),
          title: const Text('Post', style: TextStyle(color: Colors.white)),
          content: Text(
            'Message: ${post['message'] ?? '—'}\n'
            'User: ${post['user_id'] ?? '—'}\n'
            'Channel: ${post['channel_id'] ?? '—'}\n'
            'Created: ${post['create_at'] ?? '—'}',
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
                      'Could not load flagging data: $_error',
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
          Icon(Icons.flag_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Content Flagging',
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
    final enabled = _config?['enabled'];
    final teamReviewersEnabled = _config?['team_reviewers_enabled'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: _checkPost,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.search_outlined, size: 16),
                label: const Text('Review Post'),
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
          _buildInfoCard('Feature status', [
            ('Enabled', enabled == null ? '—' : '$enabled'),
            (
              'Team reviewers',
              teamReviewersEnabled == null ? '—' : '$teamReviewersEnabled',
            ),
            ('Default reviewers', '${_config?['default_reviewers'] ?? '—'}'),
          ]),
          const SizedBox(height: 20),
          Text(
            'Custom Fields',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_fields.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No custom fields configured',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            for (final field in _fields)
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
                      Icons.label_outline,
                      color: Colors.lightGreenAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        field.name ?? field.id ?? '—',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      field.type ?? '',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<(String, String)> rows) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
