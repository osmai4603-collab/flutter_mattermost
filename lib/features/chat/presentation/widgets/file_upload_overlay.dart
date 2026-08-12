import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/file_upload_controller.dart';

/// تراكب "أسقط الملف هنا" — نظير FileUploadOverlay في webapp
/// (webapp/channels/src/components/file_upload_overlay).
///
/// يعرض إطاراً نابضاً (pulsing) وعدد الملفات المتبقية حسب سعة المحرر.
class FileUploadOverlay extends StatefulWidget {
  final int remainingSlots;

  const FileUploadOverlay({super.key, this.remainingSlots = 10});

  @override
  State<FileUploadOverlay> createState() => _FileUploadOverlayState();
}

class _FileUploadOverlayState extends State<FileUploadOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _pulse =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return ColoredBox(
      color: theme.centerChannelBg.withValues(alpha: 0.92),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adjust padding and sizes for small available height to avoid overflow.
            final isSmall = constraints.maxHeight < 160;
            final verticalPadding = isSmall ? 12.0 : 28.0;
            final horizontalPadding = isSmall ? 20.0 : 40.0;
            final iconSize = isSmall ? 32.0 : 40.0;
            final gapHeight = isSmall ? 8.0 : 12.0;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final borderColor = Color.lerp(
                  theme.linkColor.withValues(alpha: 0.25),
                  theme.linkColor,
                  _pulse.value,
                )!;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: theme.centerChannelBg,
                    boxShadow: [
                      BoxShadow(
                        color: theme.linkColor
                            .withValues(alpha: 0.25 * _pulse.value),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: iconSize,
                          color: theme.linkColor,
                        ),
                        SizedBox(height: gapHeight),
                        Text(
                          l10n.upload_overlayInfo,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.centerChannelColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (widget.remainingSlots > 0) ...[
                          SizedBox(height: 4),
                          Text(
                            l10n.upload_overlayRemaining(
                              widget.remainingSlots,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.centerChannelColor
                                  .withValues(alpha: 0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// منطقة إسقاط الملفات حول المحرر — نظير dragster في file_upload.tsx.
///
/// تدير ظهور التراكم (مع تأخير إخفاء) وترسل الملفات المسقطة إلى
/// [FileUploadController.uploadFiles] بنفس قيود webapp
/// (منع المجلدات، منع روابط URI، إخفاء عند عدم السماح بالرفع).
class FileUploadDropArea extends StatefulWidget {
  final FileUploadController controller;
  final Widget child;
  final bool canUploadFiles;

  const FileUploadDropArea({
    super.key,
    required this.controller,
    required this.child,
    this.canUploadFiles = true,
  });

  @override
  State<FileUploadDropArea> createState() => _FileUploadDropAreaState();
}

class _FileUploadDropAreaState extends State<FileUploadDropArea> {
  bool _dragActive = false;
  bool _draggingOver = false;

  // desktop_drop متاح على المنصات المكتبية فقط.
  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  Future<void> _onDragDone(DropDoneDetails details) async {
    _setDragActive(false);
    if (!widget.canUploadFiles) return;
    if (details.files.isEmpty) return;
    final items = <FileUploadItem>[];
    for (final file in details.files) {
      items.add(
        FileUploadItem(
          path: file.path,
          name: file.name,
          size: await file.length(),
        ),
      );
    }
    await widget.controller.uploadFiles(items);
  }

  void _setDragActive(bool active) {
    if (_dragActive == active) return;
    setState(() => _dragActive = active);
  }

  @override
  Widget build(BuildContext context) {
    if (!_supported) return widget.child;

    final remainingSlots =
        FileUploadController.maxUploadFiles - widget.controller.draft.fileCount;

    return DropTarget(
      onDragEntered: (details) {
        if (!widget.canUploadFiles) return;
        setState(() => _draggingOver = true);
        _setDragActive(true);
      },
      onDragExited: (details) {
        setState(() => _draggingOver = false);
        _setDragActive(false);
      },
      onDragDone: _onDragDone,
      onDragUpdated: (details) {
        if (!_dragActive) _setDragActive(true);
      },
      child: Stack(
        children: [
          widget.child,
          if (_dragActive && _draggingOver)
            Positioned.fill(
              child: IgnorePointer(
                child: FileUploadOverlay(
                  remainingSlots: remainingSlots > 0 ? remainingSlots : 0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}