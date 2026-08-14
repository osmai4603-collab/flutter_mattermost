import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/data/models/log_entry_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة سجلات الخادم المطابقة لمواصفات وتصميم Mattermost WebApp
/// (Header ثابت, Log Format: JSON/Plain text, Reload Logs, Download Logs,
/// حقل بحث, زر Show last X errors, جدول الأعمدة الـ 5, و modal التفاصيل).
class AdminConsoleServerLogsPage extends StatefulWidget {
  const AdminConsoleServerLogsPage({super.key});

  @override
  State<AdminConsoleServerLogsPage> createState() =>
      _AdminConsoleServerLogsPageState();
}

class _AdminConsoleServerLogsPageState
    extends State<AdminConsoleServerLogsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  List<LogEntryModel> _logs = [];
  List<String> _plainLogs = [];
  bool _isPlainLogs = false;
  bool _loading = false;
  String? _error;

  String _searchQuery = '';
  bool _onlyShowErrors = false;
  bool _dateAsc = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_isPlainLogs) {
        final plain = await _repository.getPlainLogs(page: 0, perPage: 200);
        if (mounted) setState(() => _plainLogs = plain);
      } else {
        final logs = await _repository.getLogs(perPage: 200);
        if (mounted) setState(() => _logs = logs);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _downloadLogs() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Downloading server logs...'),
        duration: Duration(seconds: 2),
      ),
    );
    try {
      await _repository.downloadLogs('server_logs.log');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logs download completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  int get _errorCount {
    return _logs.where((l) => (l.level ?? '').toLowerCase() == 'error').length;
  }

  List<LogEntryModel> get _processedLogs {
    var result = List<LogEntryModel>.from(_logs);

    if (_onlyShowErrors) {
      result = result
          .where((l) => (l.level ?? '').toLowerCase() == 'error')
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      result = result.where((l) {
        final msg = (l.message ?? '').toLowerCase();
        final caller = (l.caller ?? '').toLowerCase();
        return msg.contains(q) || caller.contains(q);
      }).toList();
    }

    result.sort((a, b) {
      final timeA = a.time ?? '';
      final timeB = b.time ?? '';
      return _dateAsc ? timeA.compareTo(timeB) : timeB.compareTo(timeA);
    });

    return result;
  }

  Color _levelColor(String? level) {
    switch ((level ?? '').toLowerCase()) {
      case 'error':
        return Colors.redAccent;
      case 'warn':
      case 'warning':
        return Colors.amber;
      case 'info':
        return Colors.lightBlueAccent;
      case 'debug':
        return Colors.grey;
      default:
        return Colors.white70;
    }
  }

  void _showFullLogEventModal(LogEntryModel log) {
    final mapData = log.toMap();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(mapData);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white12),
          ),
          title: Row(
            children: [
              const Icon(Icons.code, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text(
                'Full Log Event',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF11111B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: SelectableText(
                  jsonStr,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.lightGreenAccent,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Log JSON copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy JSON'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181825),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerAndActions(),
                  const SizedBox(height: 16),
                  if (!_isPlainLogs) _buildSearchAndFilterToolbar(),
                  const SizedBox(height: 12),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.redAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Error loading logs: $_error',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          )
                        : _isPlainLogs
                        ? _buildPlainLogsView()
                        : _buildLogsTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2E),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: const Row(
        children: [
          Icon(Icons.article_outlined, color: Colors.blueAccent, size: 22),
          SizedBox(width: 10),
          Text(
            'Server Logs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerAndActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'To look up users by User ID or Token ID, go to User Management > Users and paste the ID into the search filter.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Log Format selection
              const Text(
                'Log Format: ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: _isPlainLogs,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      if (val != null && val != _isPlainLogs) {
                        setState(() => _isPlainLogs = val);
                        _reload();
                      }
                    },
                  ),
                  const Text(
                    'JSON',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Radio<bool>(
                    value: true,
                    groupValue: _isPlainLogs,
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      if (val != null && val != _isPlainLogs) {
                        setState(() => _isPlainLogs = val);
                        _reload();
                      }
                    },
                  ),
                  const Text(
                    'Plain text',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              // Reload Logs button
              OutlinedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reload Logs'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                ),
              ),
              const SizedBox(width: 10),
              // Download Logs button
              FilledButton.icon(
                onPressed: _downloadLogs,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Download Logs'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterToolbar() {
    return Row(
      children: [
        // Search Input
        SizedBox(
          width: 320,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search logs...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white54,
                size: 18,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white54,
                        size: 16,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1E1E2E),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Show last X errors button
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _onlyShowErrors = !_onlyShowErrors);
          },
          icon: Icon(
            _onlyShowErrors ? Icons.filter_alt : Icons.filter_alt_outlined,
            size: 16,
            color: _onlyShowErrors ? Colors.redAccent : Colors.white70,
          ),
          label: Text(
            'Show last $_errorCount errors',
            style: TextStyle(
              color: _onlyShowErrors ? Colors.redAccent : Colors.white70,
              fontWeight: _onlyShowErrors ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _onlyShowErrors ? Colors.redAccent : Colors.white24,
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Showing ${_processedLogs.length} of ${_logs.length} entries',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildLogsTable() {
    final logs = _processedLogs;

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.find_in_page_outlined,
              color: Colors.white24,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty || _onlyShowErrors
                  ? 'No logs match your filter criteria'
                  : 'No logs found',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1100,
              child: Column(
                children: [
                  // Fixed Header
                  _buildTableHeader(),
                  const Divider(height: 1, color: Colors.white10),
                  // Scrollable Body Rows
                  Expanded(
                    child: Scrollbar(
                      controller: _verticalScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _verticalScrollController,
                        itemCount: logs.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Colors.white10),
                        itemBuilder: (context, index) {
                          return _buildTableRow(logs[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 44,
      color: const Color(0xFF252538),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Timestamp Column (1.5 / 7) -> 240px
          SizedBox(
            width: 240,
            child: InkWell(
              onTap: () => setState(() => _dateAsc = !_dateAsc),
              child: Row(
                children: [
                  const Text(
                    'Timestamp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _dateAsc ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
          // Level Column -> 100px
          const SizedBox(
            width: 100,
            child: Text(
              'Level',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Message Column -> 420px
          const Expanded(
            child: Text(
              'Message',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Caller Column -> 200px
          const SizedBox(
            width: 200,
            child: Text(
              'Caller',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Options Column -> 140px
          const SizedBox(
            width: 140,
            child: Text(
              'Options',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(LogEntryModel log) {
    final level = log.level ?? 'info';
    final message = log.message ?? '';
    final caller = log.caller ?? '';
    final timeStr = log.time ?? '';

    return InkWell(
      onTap: () => _showFullLogEventModal(log),
      hoverColor: Colors.white.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Timestamp
            SizedBox(
              width: 240,
              child: Text(
                timeStr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Level
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _levelColor(level).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _levelColor(level).withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    level.toUpperCase(),
                    style: TextStyle(
                      color: _levelColor(level),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Caller
            SizedBox(
              width: 200,
              child: Text(
                caller,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Options Button
            Container(
              alignment: .centerLeft,
              width: 140,
              child: OutlinedButton(
                onPressed: () => _showFullLogEventModal(log),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                ),
                child: const Text(
                  'Full Log event',
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlainLogsView() {
    if (_plainLogs.isEmpty) {
      return const Center(
        child: Text(
          'No plain logs found',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11111B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.builder(
        itemCount: _plainLogs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: SelectableText(
              _plainLogs[index],
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.greenAccent,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
