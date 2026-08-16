import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/files/file_display_utils.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/auth_cached_image.dart';

/// مشغل وسائط مدمج داخل الرسالة — نظير AudioVideoPreviewWidget في webapp.
///
/// فيديو: media_kit (mp4/webm/...) — صوت: media_kit (mp3/wav/ogg/...).
/// لا يُنشأ الـ Player إلا عند أول تشغيل (Lazy) لتقليل استهلاك الموارد
/// في قوائم الرسائل، وتُمرَّر ترويسات Bearer مع المصدر.
class MediaAttachmentPlayer extends StatefulWidget {
  final FileInfoEntity file;

  /// تشغيل تلقائي فور التركيب (يُستخدم في شاشة المعاينة المكبرة).
  final bool autoPlay;

  /// خلفية داكنة (لشاشة المعاينة المكبرة بخلفية سوداء).
  final bool dark;

  /// ارتفاع الفيديو داخل القائمة (null → حسب المساحة المتاحة).
  final double? height;

  const MediaAttachmentPlayer({
    super.key,
    required this.file,
    this.autoPlay = false,
    this.dark = false,
    this.height,
  });

  @override
  State<MediaAttachmentPlayer> createState() => _MediaAttachmentPlayerState();
}

class _MediaAttachmentPlayerState extends State<MediaAttachmentPlayer> {
  late final bool _isVideo = isVideoExtension(widget.file.extension);

  Player? _player;
  VideoController? _controller;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<bool>? _bufferingSub;
  StreamSubscription<bool>? _completedSub;
  StreamSubscription<String>? _errorSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _playing = false;
  bool _buffering = false;
  bool _initializing = false;
  bool _error = false;
  bool _started = false;
  bool _disposed = false;

  FileInfoEntity get _file => widget.file;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelSubs();
    unawaited(_disposePlayer());
    super.dispose();
  }

  void _cancelSubs() {
    _positionSub?.cancel();
    _positionSub = null;
    _durationSub?.cancel();
    _durationSub = null;
    _playingSub?.cancel();
    _playingSub = null;
    _bufferingSub?.cancel();
    _bufferingSub = null;
    _completedSub?.cancel();
    _completedSub = null;
    _errorSub?.cancel();
    _errorSub = null;
  }

  Future<void> _disposePlayer() async {
    final player = _player;
    _controller = null;
    _player = null;
    if (player != null) {
      await player.dispose();
    }
  }

  /// إنشاء الـ Player عند أول تشغيل (Lazy) مع ترويسات Bearer.
  Future<void> _start() async {
    if (_started || _initializing || _error) return;
    _initializing = true;
    setState(() {});
    try {
      final headers = await authHeaders();
      final player = Player();
      if (_disposed) {
        unawaited(player.dispose());
        return;
      }
      _player = player;
      if (_isVideo) {
        _controller = VideoController(player);
      }

      _positionSub = player.stream.position.listen(
        (d) => _safeSetState(() => _position = d),
      );
      _durationSub = player.stream.duration.listen(
        (d) => _safeSetState(() => _duration = d),
      );
      _playingSub = player.stream.playing.listen(
        (p) => _safeSetState(() => _playing = p),
      );
      _bufferingSub = player.stream.buffering.listen(
        (b) => _safeSetState(() => _buffering = b),
      );
      _completedSub = player.stream.completed.listen(
        (c) {
          if (!c) return;
          _safeSetState(() => _playing = false);
          unawaited(player.seek(Duration.zero));
        },
      );
      _errorSub = player.stream.error.listen(
        (_) => _safeSetState(() => _error = true),
      );

      await player.open(
        Media(
          fileApiUrl(_file),
          httpHeaders: headers.isEmpty ? null : headers,
        ),
        play: widget.autoPlay,
      );
      if (_disposed) return;
      _started = true;
      _safeSetState(() => _initializing = false);
    } catch (_) {
      if (!_disposed) {
        _safeSetState(() {
          _error = true;
          _initializing = false;
        });
      }
    }
  }

  void _safeSetState(VoidCallback fn) {
    if (_disposed || !mounted) return;
    setState(fn);
  }

  void _togglePlay() {
    final player = _player;
    if (player == null) {
      unawaited(_start());
      return;
    }
    if (_playing) {
      unawaited(player.pause());
    } else {
      unawaited(player.play());
    }
  }

  void _onSeek(double value) {
    final player = _player;
    final total = _duration.inMilliseconds;
    if (player == null || total <= 0) return;
    unawaited(player.seek(Duration(milliseconds: (value * total).round())));
  }

  void _retry() {
    setState(() {
      _error = false;
      _started = false;
    });
    unawaited(_disposePlayer());
    unawaited(_start());
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '$h:$mm:$ss';
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo) return _buildVideo();
    return _buildAudio();
  }

  // ─────────────────────────── فيديو ───────────────────────────

  Widget _buildVideo() {
    final controller = _controller;

    final Widget child;
    if (_error) {
      child = _FallbackCard(file: _file, isVideo: true, onRetry: _retry);
    } else if (controller == null) {
      // بوستر مصغّرة + زر تشغيل (قبل إنشاء الـ Player).
      child = _VideoPoster(
        file: _file,
        dark: widget.dark,
        loading: _initializing,
        onPlay: _start,
      );
    } else {
      child = Stack(
        fit: StackFit.expand,
        children: [
          Video(
            controller: controller,
            controls: NoVideoControls,
            fill: widget.dark ? const Color(0xFF000000) : const Color(0xFF111111),
          ),
          if (_buffering || _initializing)
            const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _togglePlay,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _VideoControls(
              playing: _playing,
              position: _position,
              duration: _duration,
              dark: widget.dark,
              onTogglePlay: _togglePlay,
              onSeek: _onSeek,
              format: _formatDuration,
            ),
          ),
        ],
      );
    }

    // ارتفاع محدد (القائمة) أو تمدد داخل المساحة المتاحة (المعاينة المكبرة).
    if (widget.height != null) {
      return SizedBox(height: widget.height, child: child);
    }
    return child;
  }

  // ─────────────────────────── صوت ───────────────────────────

  Widget _buildAudio() {
    if (_error) {
      return _FallbackCard(file: _file, isVideo: false, onRetry: _retry);
    }

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: widget.dark
          ? const Color(0xFF1E1E1E)
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: widget.dark
              ? const Color(0xFF444444)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: _togglePlay,
              iconSize: 22,
              icon: _initializing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      _playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: widget.dark
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.dark
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Slider(
                    value: _duration.inMilliseconds > 0
                        ? (_position.inMilliseconds /
                                _duration.inMilliseconds)
                            .clamp(0.0, 1.0)
                        : 0,
                    onChanged: _started ? _onSeek : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _started
                  ? '${_formatDuration(_position)} / ${_formatDuration(_duration)}'
                  : _formatDuration(_duration),
              style: TextStyle(
                fontSize: 11.5,
                color: widget.dark
                    ? Colors.white70
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شريط تحكم سفلي للفيديو: تشغيل/إيقاف + مؤشر تقدم + وقت.
class _VideoControls extends StatelessWidget {
  final bool playing;
  final Duration position;
  final Duration duration;
  final bool dark;
  final VoidCallback onTogglePlay;
  final void Function(double) onSeek;
  final String Function(Duration) format;

  const _VideoControls({
    required this.playing,
    required this.position,
    required this.duration,
    required this.dark,
    required this.onTogglePlay,
    required this.onSeek,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.black.withValues(alpha: 0.65) : Colors.black54;
    final fg = Colors.white;
    final totalMs = duration.inMilliseconds;
    final progress =
        totalMs > 0 ? (position.inMilliseconds / totalMs).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onTogglePlay,
            iconSize: 20,
            color: fg,
            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 12,
                ),
                activeTrackColor: fg,
                inactiveTrackColor: Colors.white24,
                thumbColor: fg,
              ),
              child: Slider(
                value: progress,
                onChanged: onSeek,
              ),
            ),
          ),
          Text(
            '${format(position)} / ${format(duration)}',
            style: TextStyle(color: fg, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// بوستر فيديو: مصغّرة (thumbnail) + زر تشغيل كبير.
class _VideoPoster extends StatelessWidget {
  final FileInfoEntity file;
  final bool dark;
  final bool loading;
  final VoidCallback onPlay;

  const _VideoPoster({
    required this.file,
    required this.dark,
    required this.loading,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AuthCachedImage(
            url: fileApiUrl(file, suffix: '/thumbnail'),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              color: dark
                  ? const Color(0xFF1E1E1E)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.movie_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.25),
          ),
          Center(
            child: loading
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : InkWell(
                    onTap: onPlay,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          Positioned(
            left: 8,
            bottom: 8,
            right: 8,
            child: Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة بديلة عند تعذّر تشغيل الوسائط (مع إعادة المحاولة).
class _FallbackCard extends StatelessWidget {
  final FileInfoEntity file;
  final bool isVideo;
  final VoidCallback onRetry;

  const _FallbackCard({
    required this.file,
    required this.isVideo,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isVideo ? Icons.movie_outlined : Icons.audiotrack_outlined,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
