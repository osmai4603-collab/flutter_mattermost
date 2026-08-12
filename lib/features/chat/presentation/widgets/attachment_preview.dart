import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_draft.dart';

/// معاينة المرفقات في المحرر — نظير FilePreview في webapp.
///
/// تعرض الملفات المرفوعة (مع إمكانية الإزالة) وملفات قيد الرفع
/// (مع نسبة التقدم وزر إلغاء).
class AttachmentPreview extends StatelessWidget {
  final ComposerDraft draft;
  final void Function(String idOrClientId) onRemove;

  const AttachmentPreview({
    super.key,
    required this.draft,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (draft.fileInfos.isEmpty && draft.uploadsInProgress.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final info in draft.fileInfos)
            _AttachmentChip(
              icon: _fileIcon(info.extension),
              title: info.name,
              subtitle: _formatFileSize(info.size),
              imagePath: _isImage(info.extension) ? info.localPath : null,
              onRemove: () => onRemove(info.id),
            ),
          for (final upload in draft.uploadsInProgress)
            _UploadingChip(
              upload: upload,
              onCancel: () => onRemove(upload.clientId),
            ),
        ],
      ),
    );
  }

  }

bool _isImage(String extension) {
  switch (extension.toLowerCase()) {
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
    case 'webp':
    case 'bmp':
    case 'svg':
      return true;
    default:
      return false;
  }
}

IconData _fileIcon(String extension) {
  switch (extension.toLowerCase()) {
    case 'png':
    case 'jpg':
    case 'jpeg':
    case 'gif':
    case 'webp':
    case 'bmp':
    case 'svg':
      return Icons.image_outlined;
    case 'pdf':
      return Icons.picture_as_pdf_outlined;
    case 'zip':
    case 'rar':
    case '7z':
    case 'tar':
    case 'gz':
      return Icons.folder_zip_outlined;
    case 'mp4':
    case 'mov':
    case 'avi':
    case 'mkv':
    case 'webm':
      return Icons.movie_outlined;
    case 'mp3':
    case 'wav':
    case 'ogg':
    case 'flac':
      return Icons.audiotrack_outlined;
    case 'doc':
    case 'docx':
      return Icons.description_outlined;
    default:
      return Icons.insert_drive_file_outlined;
  }
}

class _AttachmentChip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  /// مسار ملف الصورة للمعاينة المصغّرة (null → أيقونة).
  final String? imagePath;
  final VoidCallback? onRemove;

  const _AttachmentChip({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.04),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[
            _Thumbnail(imagePath: imagePath!, fallback: icon, theme: theme),
            const SizedBox(width: 8),
          ] else
            Icon(icon, size: 16, color: theme.linkColor),
          SizedBox(width: imagePath == null ? 8 : 0),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: theme.centerChannelColor.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: theme.centerChannelColor.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 4),
            // TODO(i18n): أضف مفتاح file_preview.remove إلى ملفات الترجمة.
            Tooltip(
              message: 'Remove',
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ملف قيد الرفع: شريط تقدم + نسبة + زر إلغاء (نظير uploadsInProgress
/// في FilePreview مع uploadsProgressPercent).
class _UploadingChip extends StatelessWidget {
  final UploadingFile upload;
  final VoidCallback onCancel;

  const _UploadingChip({required this.upload, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final percent = (upload.progress * 100).clamp(0, 100).round();
    final extension = upload.name.contains('.')
        ? upload.name.split('.').last
        : '';

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.04),
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Thumbnail(
            imagePath: upload.localPath,
            fallback: _fileIcon(extension),
            theme: theme,
            showProgress: true,
            progress: upload.progress,
            onCancel: onCancel,
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  upload.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: theme.centerChannelColor.withValues(alpha: 0.85),
                  ),
                ),
                Text(
                  // TODO(i18n): أضف مفتاح file_preview.uploading إلى الترجمة.
                  'Uploading $percent%',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: theme.centerChannelColor.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}

String _formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// صورة مصغّرة 40×40 لملفات الصور، مع شريط تقدم اختياري وزر إلغاء
/// أثناء الرفع، وسقوط على الأيقونة عند تعذر فك ترميزها.
class _Thumbnail extends StatelessWidget {
  final String? imagePath;
  final IconData fallback;
  final MattermostColors theme;
  final bool showProgress;
  final double progress;
  final VoidCallback? onCancel;

  const _Thumbnail({
    required this.imagePath,
    required this.fallback,
    required this.theme,
    this.showProgress = false,
    this.progress = 0,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imagePath == null
                ? Container(
                    color: theme.centerChannelColor.withValues(alpha: 0.05),
                    child: Icon(
                      fallback,
                      size: 16,
                      color: theme.centerChannelColor
                          .withValues(alpha: 0.45),
                    ),
                  )
                : Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.centerChannelColor.withValues(alpha: 0.05),
                      child: Icon(
                        fallback,
                        size: 16,
                        color: theme.centerChannelColor
                            .withValues(alpha: 0.45),
                      ),
                    ),
                  ),
          ),
          if (showProgress) ...[
            Container(
              color: theme.centerChannelBg.withValues(alpha: 0.55),
              alignment: Alignment.center,
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress > 0 ? progress : null,
                  color: theme.linkColor,
                ),
              ),
            ),
            if (onCancel != null)
              Positioned(
                top: -2,
                right: -2,
                child: InkWell(
                  onTap: onCancel,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.centerChannelBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.centerChannelColor
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 12,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
