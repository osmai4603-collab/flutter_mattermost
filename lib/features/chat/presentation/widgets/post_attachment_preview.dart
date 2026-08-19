import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/files/file_display_utils.dart';
import 'package:flutter_mattermost/features/chat/presentation/files/file_preview_modal.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/auth_cached_image.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/media_attachment_player.dart';

/// يعرض مرفقات الرسالة (الصور والملفات والوسائط) بشكل تفاعلي.
class PostAttachmentPreview extends StatelessWidget {
  final List<FileInfoEntity> files;

  const PostAttachmentPreview({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    final images = files.where((f) => isImageFile(f)).toList();
    final media = files
        .where((f) => isMediaExtension(f.extension) && !isImageFile(f))
        .toList();
    final otherFiles = files
        .where(
          (f) =>
              !isImageFile(f) &&
              !isMediaExtension(f.extension),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _ImageGrid(files: images, allFiles: files),
          ),
        if (media.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: media.map((f) => MediaAttachmentPlayer(file: f)).toList(),
            ),
          ),
        if (otherFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: otherFiles.map((f) => _FileCard(
                file: f,
                allFiles: files,
                index: files.indexOf(f),
              )).toList(),
            ),
          ),
      ],
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<FileInfoEntity> files;
  final List<FileInfoEntity> allFiles;

  const _ImageGrid({required this.files, required this.allFiles});

  @override
  Widget build(BuildContext context) {
    if (files.length == 1) {
      return _SingleImage(
        file: files.first,
        allFiles: allFiles,
        index: allFiles.indexOf(files.first),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, i) {
        final f = files[i];
        return _Thumbnail(
          file: f,
          allFiles: allFiles,
          index: allFiles.indexOf(f),
        );
      },
    );
  }
}

class _SingleImage extends StatelessWidget {
  final FileInfoEntity file;
  final List<FileInfoEntity> allFiles;
  final int index;

  const _SingleImage({required this.file, required this.allFiles, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final hasSize = file.width > 0 && file.height > 0;

    return GestureDetector(
      onTap: () => _showPreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: hasSize
            ? AspectRatio(
                aspectRatio: file.width / file.height,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: AuthCachedImage(
                    url: fileApiUrl(file),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) => _errorWidget(theme),
                  ),
                ),
              )
            : ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: AuthCachedImage(
                  url: fileApiUrl(file),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) => _errorWidget(theme),
                ),
              ),
      ),
    );
  }

  Widget _errorWidget(MattermostColors theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.image_outlined,
            size: 24,
            color: theme.centerChannelColor.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilePreviewModal(files: allFiles, initialIndex: index),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final FileInfoEntity file;
  final List<FileInfoEntity> allFiles;
  final int index;

  const _Thumbnail({required this.file, required this.allFiles, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GestureDetector(
      onTap: () => _showPreview(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AuthCachedImage(
          url: fileApiUrl(file, suffix: '/thumbnail'),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Container(
            color: theme.centerChannelColor.withValues(alpha: 0.05),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 32,
                color: theme.centerChannelColor.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FilePreviewModal(files: allFiles, initialIndex: index),
    );
  }
}

class _FileCard extends StatelessWidget {
  final FileInfoEntity file;
  final List<FileInfoEntity> allFiles;
  final int index;

  const _FileCard({required this.file, required this.allFiles, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => FilePreviewModal(files: allFiles, initialIndex: index),
      ),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.centerChannelColor.withValues(alpha: 0.05),
          border: Border.all(color: theme.centerChannelColor.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file_outlined, size: 20, color: theme.linkColor),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: theme.centerChannelColor),
                  ),
                  Text(
                    _formatFileSize(file.size),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.centerChannelColor.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
