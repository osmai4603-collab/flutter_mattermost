import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/modals/modal_identifiers.dart';
import 'package:flutter_mattermost/core/modals/modal_registry.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/utils/timezone_offset.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:intl/intl.dart';

/// لوحة ملفات القناة — مطابقة rhs_channel_files في webapp:
/// بحث + قائمة ملفات القناة (أيقونة نوع/اسم/حجم/تاريخ) مع معاينة وتحميل.
class ChannelFilesPanel extends StatefulWidget {
  const ChannelFilesPanel({super.key});

  @override
  State<ChannelFilesPanel> createState() => _ChannelFilesPanelState();
}

class _ChannelFilesPanelState extends State<ChannelFilesPanel> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<FileInfoEntity>>? _filesFuture;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _teamId() {
    final teamState = context.read<TeamBloc>().state;
    if (teamState is! TeamsLoadedState) return null;
    return teamState.selectedTeam?.id ?? teamState.teams.firstOrNull?.id;
  }

  Future<List<FileInfoEntity>> _fetch() {
    final teamId = _teamId();
    final channelState = context.read<ChannelBloc>().state;
    final channel = channelState is ChannelsLoadedState
        ? channelState.selectedChannel
        : null;
    if (teamId == null || channel == null) {
      return Future.value(const []);
    }
    final scope = 'channel:${channel.name}';
    final terms = _query.isEmpty ? scope : '$scope $_query';
    return getIt<FilesRemoteDataSource>().searchFilesInTeam(teamId, {
      'terms': terms,
      'is_or_search': false,
      'include_deleted_channels': true,
      'time_zone_offset': TimeZoneOffset.deviceOffsetSeconds(),
      'page': 0,
      'per_page': 100,
    }).then((files) {
      return files.map((f) => f.toEntity()).toList();
    });
  }

  FileInfoEntity _toFileInfoEntity(Map<String, dynamic> json) {
    final dto = FileInfoModel.fromMap(json);
    return FileInfoEntity(
      serverId: '',
      id: dto.id,
      postId: dto.postId,
      userId: dto.userId,
      name: dto.name,
      extension: dto.extension,
      size: dto.size,
      mimeType: dto.mimeType,
      width: dto.width ?? 0,
      height: dto.height ?? 0,
    );
  }

  void _reload() {
    setState(() => _filesFuture = _fetch());
  }

  void _preview(List<FileInfoEntity> files, int index) {
    ModalRegistry.open(
      context,
      id: ModalIdentifiers.filePreview,
      args: {'files': files, 'initialIndex': index},
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    _filesFuture ??= _fetch();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              _query = value.trim();
              _reload();
            },
            style: TextStyle(color: theme.centerChannelColor, fontSize: 13),
            decoration: InputDecoration(
                            hintText: l10n.search_barSearch_files,              hintStyle: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.5),
                fontSize: 13,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 18,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<FileInfoEntity>>(
            future: _filesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final files = snapshot.data ?? const <FileInfoEntity>[];
              if (files.isEmpty) {
                return _FilesEmptyState(l10n: l10n);
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: files.length,
                itemBuilder: (context, index) => _FileRow(
                  file: files[index],
                  onTap: () => _preview(files, index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// صف ملف: أيقونة نوع + اسم + حجم/تاريخ + تحميل عند التحويم.
class _FileRow extends StatefulWidget {
  final FileInfoEntity file;
  final VoidCallback onTap;

  const _FileRow({required this.file, required this.onTap});

  @override
  State<_FileRow> createState() => _FileRowState();
}

class _FileRowState extends State<_FileRow> {
  bool _hovered = false;
  bool _downloading = false;

  Future<void> _download() async {
    final file = widget.file;
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      await ModalRegistry.open(
        context,
        id: ModalIdentifiers.filePreview,
        args: {
          'files': [file],
          'initialIndex': 0,
          'autoDownload': true,
        },
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final isVideo = widget.file.mimeType.startsWith('video');
    final isAudio = widget.file.mimeType.startsWith('audio');

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        hoverColor: theme.centerChannelColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              _fileIcon(widget.file.extension, isVideo, isAudio, theme),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _metaLabel(widget.file, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.45),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                opacity: _hovered ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: IconButton(
                  icon: _downloading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          Icons.download_outlined,
                          size: 18,
                          color: theme.centerChannelColor.withValues(alpha: 0.6),
                        ),
                  tooltip: l10n.file_search_result_itemDownload,
                  onPressed: _download,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _metaLabel(FileInfoEntity file, AppLocalizations l10n) {
    final size = _formatSize(file.size);
    final date = DateFormat('MMM d, yyyy').format(
      DateTime.now(),
    );
    return '$size · $date';
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Widget _fileIcon(
    String extension,
    bool isVideo,
    bool isAudio,
    MattermostColors theme,
  ) {
    final color = theme.centerChannelColor.withValues(alpha: 0.55);
    if (isVideo) return Icon(Icons.movie_outlined, size: 26, color: color);
    if (isAudio) return Icon(Icons.audiotrack_outlined, size: 26, color: color);
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf_outlined, size: 26, color: color);
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icon(Icons.folder_zip_outlined, size: 26, color: color);
      case 'doc':
      case 'docx':
        return Icon(Icons.description_outlined, size: 26, color: color);
      case 'xls':
      case 'xlsx':
        return Icon(Icons.table_chart_outlined, size: 26, color: color);
      case 'ppt':
      case 'pptx':
        return Icon(Icons.slideshow_outlined, size: 26, color: color);
      default:
        return Icon(Icons.insert_drive_file_outlined, size: 26, color: color);
    }
  }
}

class _FilesEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _FilesEmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.no_resultsChannel_filesTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.no_resultsChannel_filesSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.centerChannelColor.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
