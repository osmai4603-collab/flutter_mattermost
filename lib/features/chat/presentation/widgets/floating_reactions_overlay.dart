import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingReactionsOverlay extends StatefulWidget {
  final String? emoji;
  final VoidCallback? onFinished;

  const FloatingReactionsOverlay({super.key, this.emoji, this.onFinished});

  @override
  State<FloatingReactionsOverlay> createState() => _FloatingReactionsOverlayState();
}

class _FloatingReactionsOverlayState extends State<FloatingReactionsOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_FloatingEmoji> _emojis = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          _emojis.removeWhere((e) => e.progress >= 1.0);
          if (_emojis.isEmpty && widget.onFinished != null) {
             // We don't call it here to avoid build conflicts, 
             // usually handled by the parent bloc state reset.
          }
        });
      });
  }

  @override
  void didUpdateWidget(FloatingReactionsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.emoji != null && widget.emoji != oldWidget.emoji) {
      _addEmoji(widget.emoji!);
      if (!_controller.isAnimating) {
        _controller.forward(from: 0);
      }
    }
  }

  void _addEmoji(String emoji) {
    _emojis.add(_FloatingEmoji(
      emoji: emoji,
      startTime: DateTime.now(),
      xOffset: math.Random().nextDouble() * 200 - 100,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: _emojis.map((e) {
          final progress = (DateTime.now().difference(e.startTime).inMilliseconds / 2000).clamp(0.0, 1.0);
          e.progress = progress;
          
          return Positioned(
            bottom: 100 + (progress * 400),
            left: MediaQuery.of(context).size.width / 2 + e.xOffset + (math.sin(progress * 10) * 20),
            child: Opacity(
              opacity: 1.0 - progress,
              child: Text(
                e.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FloatingEmoji {
  final String emoji;
  final DateTime startTime;
  final double xOffset;
  double progress = 0;

  _FloatingEmoji({
    required this.emoji,
    required this.startTime,
    required this.xOffset,
  });
}
