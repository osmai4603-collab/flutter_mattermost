import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/data/models/log_entry_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة سجلات الخادم (GET /logs/query + /logs/download).
class AdminConsoleServerLogsPage extends StatefulWidget {
  const AdminConsoleServerLogsPage({super.key});

  @override
  State<AdminConsoleServerLogsPage> createState() => _AdminConsoleServerLogsPageState();
}

class _AdminConsoleServerLogsPageState extends State<AdminConsoleServerLogsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();
  final _levelController = TextEditingController();
  final _filterController = TextEditingController();

  List<LogEntryModel> _logs = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final logs = await _repository.getLogs(
        perPage: 200,
        level: _levelController.text.trim().isEmpty
            ? null
            : _levelController.text.trim(),
        filter: _filterController.text.trim().isEmpty
            ? null
            : _filterController.text.trim(),
      );
      setState(() => _logs = logs);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _levelController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'error':
        return Colors.redAccent;
      case 'warning':
        return Colors.orangeAccent;
      case 'info':
        return Colors.blueAccent;
      case 'debug':
        return Colors.white54;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(child: _buildBody()),
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
          Icon(Icons.article_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Server Logs',
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  controller: _levelController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Level (e.g. error)'),
                  onSubmitted: (_) => _loadLogs(),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _filterController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Filter (search terms)'),
                  onSubmitted: (_) => _loadLogs(),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: _loadLogs,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.search, size: 16),
                label: const Text('Filter'),
              ),
              const Spacer(),
              if (_logs.isNotEmpty)
                Text(
                  '${_logs.length} entries',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_error != null) ...[
            Text(
              'Error loading logs: $_error',
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  )
                : _logs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs found',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : _buildLogList(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF181825),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _buildLogList() {
    return ListView.separated(
      itemCount: _logs.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        final log = _logs[index];
        final level = log.level ?? 'info';
        final message = log.message ?? log.toString();
        final caller = log.caller ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  level.toUpperCase(),
                  style: TextStyle(
                    color: _levelColor(level),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                caller,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        );
      },
    );
  }
}
