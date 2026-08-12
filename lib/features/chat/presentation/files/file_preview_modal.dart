import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:path_provider/path_provider.dart';

/// معاينة الملف — مطابقة FilePreviewModal في webapp (المرحلة 2):
/// ملء الشاشة بخلفية سوداء + هيدر 72px داكن + أسهم تنقّل بين ملفات المنشور
/// + تكبير/تحريك (zoom/pan) للصور + زر تحميل.
class FilePreviewModal extends StatefulWidget {
  final List<FileInfoEntity> files;
  final int initialIndex;
  final bool autoDownload;

  const FilePreviewModal({
    super.key,
    required this.files,
    this.initialIndex = 0,
    this.autoDownload = false,
  });

  @override
  State<FilePreviewModal> createState() => _FilePreviewModalState();
}

class _FilePreviewModalState extends State<FilePreviewModal> {
  late int _index = widget.initialIndex;
  bool _saving = false;
  final Map<String, Uint8List> _imageCache = {};
  final Map<String, bool> _imageErrors = {};

  FileInfoEntity get _file => widget.files[_index];
  bool get _isImage => _file.mimeType.startsWith('image/');
  bool get _isVideo => _file.mimeType.startsWith('video/');
  bool get _isAudio => _file.mimeType.startsWith('audio/');

  Future<void> _download() async {
    setState(() => _saving = true);
    try {
      final bytes = await getIt<PostRepository>().getFile(_file.id);
      final dir = await _downloadsDir();
      final file = File('${dir.path}/${_file.name}');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${_file.name} → ${file.path}')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Download failed')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<Directory> _downloadsDir() async {
    try {
      final dir = await getDownloadsDirectory();
      if (dir != null) return dir;
    } catch (_) {}
    return getApplicationDocumentsDirectory();
  }

  void _goTo(int index) {
    if (index < 0 || index >= widget.files.length) return;
    setState(() => _index = index);
  }

  void _goPrev() => _goTo(_index - 1);
  void _goNext() => _goTo(_index + 1);

  @override
  void initState() {
    super.initState();
    if (widget.autoDownload) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _download());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final details = <String>[
      _file.mimeType,
      _formatSize(_file.size),
      if (_file.width > 0 && _file.height > 0)
        '${_file.width} × ${_file.height}',
    ];

    return Material(
      color: const Color(0xFF111111),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(l10n),
            Expanded(child: _buildPreview(l10n)),
            _buildFooter(theme, l10n, details),
          ],
        ),
      ),
    );
  }

  /// هيدر 72px داكن — الاسم + العدّاد + أسهم التنقل + تحميل + إغلاق.
  Widget _buildHeader(AppLocalizations l10n) {
    final canPrev = _index > 0;
    final canNext = _index < widget.files.length - 1;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF000000),
      child: Row(
        children: [
          const Icon(Icons.image_outlined, size: 22, color: Color(0xFFDDDDDD)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.files.length > 1)
                  Text(
                    l10n.filePreviewCounter(
                      (_index + 1).toString(),
                      widget.files.length.toString(),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 26),
            color: canPrev ? const Color(0xFFDDDDDD) : const Color(0xFF555555),
            tooltip: l10n.filePreviewPrevious,
            onPressed: canPrev ? _goPrev : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 26),
            color: canNext ? const Color(0xFFDDDDDD) : const Color(0xFF555555),
            tooltip: l10n.filePreviewNext,
            onPressed: canNext ? _goNext : null,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download_outlined, size: 20),
            color: const Color(0xFFDDDDDD),
            tooltip: l10n.file_search_result_itemDownload,
            onPressed: _saving ? null : _download,
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 22),
            color: const Color(0xFFDDDDDD),
            tooltip: l10n.filePreviewClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {},
      child: _isImage ? _buildImagePreview() : _buildGenericPreview(l10n),
    );
  }

  Widget _buildImagePreview() {
    final cached = _imageCache[_file.id];
    if (cached != null) {
      return _previewArea(Image.memory(cached, fit: BoxFit.contain));
    }
    if (_imageErrors[_file.id] == true) {
      return _previewArea(
        Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    }
    return FutureBuilder<Uint8List>(
      future: getIt<PostRepository>().getFile(_file.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _imageCache[_file.id] = snapshot.data!;
          return _previewArea(
            Image.memory(snapshot.data!, fit: BoxFit.contain),
          );
        }
        if (snapshot.hasError) {
          _imageErrors[_file.id] = true;
          return _previewArea(
            Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.white70),
        );
      },
    );
  }

  /// مساحة العرض السوداء مع zoom/pan وإعادة ضبط عند تغيير الملف.
  Widget _previewArea(Widget child) {
    return Container(
      color: const Color(0xFF111111),
      child: InteractiveViewer(
        key: ValueKey(_file.id),
        maxScale: 8,
        minScale: 1,
        child: Center(child: child),
      ),
    );
  }

  Widget _buildGenericPreview(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _fileIcon(_file.extension, _isVideo, _isAudio),
            size: 64,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            _isVideo || _isAudio
                ? l10n.filePreviewUnsupported(
                    _isVideo ? 'video' : 'audio',
                  )
                : l10n.filePreviewUnsupported(_file.extension.toUpperCase()),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// شريط المعلومات السفلي — التفاصيل + زر تحميل.
  Widget _buildFooter(
    MattermostColors theme,
    AppLocalizations l10n,
    List<String> details,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: const Color(0xFF000000),
      child: Row(
        children: [
          Expanded(
            child: Text(
              details.join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF999999), fontSize: 12.5),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _saving ? null : _download,
            icon: _saving
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_outlined, size: 18),
            label: Text(l10n.file_search_result_itemDownload),
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF777777)),
              textStyle: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  IconData _fileIcon(String extension, bool isVideo, bool isAudio) {
    if (isVideo) return Icons.movie_outlined;
    if (isAudio) return Icons.audiotrack_outlined;
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return Icons.folder_zip_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
