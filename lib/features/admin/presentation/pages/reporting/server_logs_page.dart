import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
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
    final colors = AppTheme.of(context);
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
        SnackBar(
          content: Text('Logs download completed!'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: colors.errorTextColor,
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
    final colors = AppTheme.of(context);
    switch ((level ?? '').toLowerCase()) {
      case 'error':
        return colors.errorTextColor;
      case 'warn':
      case 'warning':
        return colors.awayIndicator;
      case 'info':
        return Colors.lightBlueAccent;
      case 'debug':
        return colors.centerChannelColor.withValues(alpha: 0.40);
      default:
        return colors.centerChannelColor.withValues(alpha: 0.70);
    }
  }

  void _showFullLogEventModal(LogEntryModel log) {
    final colors = AppTheme.of(context);
    final mapData = log.toMap();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(mapData);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.centerChannelBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colors.centerChannelColor.withValues(alpha: 0.12),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.code, color: colors.buttonBg),
                  SizedBox(width: 8),
                  Text(
                    'Full Log Event',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.centerChannelBg.withValues(alpha: 0.80),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.centerChannelColor.withValues(alpha: 0.10),
                  ),
                ),
                child: SelectableText(
                  jsonStr,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: colors.onlineIndicator,
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
              icon: Icon(Icons.copy, size: 16),
              label: Text('Copy JSON'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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
            alignment: Alignment.centerLeft,
            child: Text(
              'Server Logs',
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerAndActions(),
                  SizedBox(height: 16),
                  if (!_isPlainLogs) _buildSearchAndFilterToolbar(),
                  SizedBox(height: 12),
                  if (_error != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.errorTextColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colors.errorTextColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: colors.errorTextColor,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Error loading logs: $_error',
                              style: TextStyle(
                                color: colors.errorTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                  ],
                  Expanded(
                    child: _loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colors.buttonBg,
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

  Widget _buildBannerAndActions() {
    final colors = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To look up users by User ID or Token ID, go to User Management > Users and paste the ID into the search filter.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.70),
              fontSize: 13,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              // Log Format selection
              Text(
                'Log Format: ',
                style: TextStyle(
                  color: colors.centerChannelColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 150,
                    child: RadioListTile(
                      controlAffinity: .leading,
                      dense: true,
                      minTileHeight: 35,
                      value: false,
                      activeColor: colors.buttonBg,
                      groupValue: _isPlainLogs,
                      title: Text(
                        'Json',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null && val != _isPlainLogs) {
                          _isPlainLogs = val;
                          _reload();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: RadioListTile(
                      controlAffinity: .leading,
                      dense: true,
                      minTileHeight: 35,
                      value: true,
                      activeColor: colors.buttonBg,
                      groupValue: _isPlainLogs,
                      title: Text(
                        'Plain text',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null && val != _isPlainLogs) {
                          setState(() => _isPlainLogs = val);
                          _reload();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
              Spacer(),
              // Reload Logs button
              FilledButton(onPressed: _reload, child: Text('Reload Logs')),
              SizedBox(width: 10),
              // Download Logs button
              FilledButton(
                onPressed: _downloadLogs,
                child: Text('Download Logs'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterToolbar() {
    final colors = AppTheme.of(context);
    return Row(
      children: [
        // Search Input
        SizedBox(
          width: 320,
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search logs...',
              hintStyle: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                size: 18,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        size: 16,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: colors.centerChannelBg,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colors.buttonBg),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Show last X errors button
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _onlyShowErrors = !_onlyShowErrors);
          },
          icon: Icon(
            _onlyShowErrors ? Icons.filter_alt : Icons.filter_alt_outlined,
            size: 16,
            color: _onlyShowErrors
                ? colors.errorTextColor
                : colors.centerChannelColor.withValues(alpha: 0.70),
          ),
          label: Text(
            'Show last $_errorCount errors',
            style: TextStyle(
              color: _onlyShowErrors
                  ? colors.errorTextColor
                  : colors.centerChannelColor.withValues(alpha: 0.70),
              fontWeight: _onlyShowErrors ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _onlyShowErrors
                  ? colors.errorTextColor
                  : colors.centerChannelColor.withValues(alpha: 0.24),
            ),
          ),
        ),
        Spacer(),
        Text(
          'Showing ${_processedLogs.length} of ${_logs.length} entries',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLogsTable() {
    final colors = AppTheme.of(context);
    final logs = _processedLogs;

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.find_in_page_outlined,
              color: colors.centerChannelColor.withValues(alpha: 0.24),
              size: 48,
            ),
            SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty || _onlyShowErrors
                  ? 'No logs match your filter criteria'
                  : 'No logs found',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
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
                  Divider(
                    height: 1,
                    color: colors.centerChannelColor.withValues(alpha: 0.10),
                  ),
                  // Scrollable Body Rows
                  Expanded(
                    child: Scrollbar(
                      controller: _verticalScrollController,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _verticalScrollController,
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.10,
                          ),
                        ),
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
    final colors = AppTheme.of(context);
    return Container(
      height: 44,
      color: colors.centerChannelColor.withValues(alpha: 0.12),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Timestamp Column (1.5 / 7) -> 240px
          SizedBox(
            width: 240,
            child: InkWell(
              onTap: () => setState(() => _dateAsc = !_dateAsc),
              child: Row(
                children: [
                  Text(
                    'Timestamp',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    _dateAsc ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: colors.buttonBg,
                  ),
                ],
              ),
            ),
          ),
          // Level Column -> 100px
          SizedBox(
            width: 100,
            child: Text(
              'Level',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Message Column -> 420px
          Expanded(
            child: Text(
              'Message',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          // Caller Column -> 200px
          SizedBox(
            width: 200,
            child: Text(
              'Caller',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(
              'Options',
              style: TextStyle(
                color: colors.centerChannelColor,
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
    final colors = AppTheme.of(context);
    final level = log.level ?? 'info';
    final message = log.message ?? '';
    final caller = log.caller ?? '';
    final timeStr = log.time ?? '';

    return InkWell(
      onTap: () => _showFullLogEventModal(log),
      hoverColor: colors.centerChannelColor.withValues(alpha: 0.04),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Timestamp
            SizedBox(
              width: 240,
              child: Text(
                timeStr,
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.70),
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _levelColor(level).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: _levelColor(level).withValues(alpha: 0.4),
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
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.70),
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Caller
            SizedBox(
              width: 200,
              child: Text(
                caller,
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                  fontSize: 13,
                  fontWeight: .bold,
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
                  foregroundColor: colors.buttonBg,
                  side: BorderSide(color: colors.buttonBg, width: 1),
                  backgroundColor: colors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(4.0),
                    side: BorderSide(color: colors.buttonBg, width: 1),
                  ),
                ),
                child: Text('Full Log event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlainLogsView() {
    final colors = AppTheme.of(context);
    if (_plainLogs.isEmpty) {
      return Center(
        child: Text(
          'No plain logs found',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.38),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: ListView.builder(
        itemCount: _plainLogs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: SelectableText(
              _plainLogs[index],
              style: TextStyle(
                fontFamily: 'monospace',
                color: colors.onlineIndicator,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
