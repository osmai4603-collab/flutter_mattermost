import 'package:flutter/material.dart';

typedef WidgetHoverBuilder = Widget Function(BuildContext, bool);

class HoverWidget extends StatefulWidget {
  final WidgetHoverBuilder builder;
  final void Function()? onHover;
  final MouseCursor cursor;
  const HoverWidget({
    super.key,
    required this.builder,
    this.onHover,
    this.cursor = MouseCursor.defer,
  });

  @override
  State<HoverWidget> createState() => _HoverWidgetState();
}

class _HoverWidgetState extends State<HoverWidget> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: widget.builder(context, isHovered),
      onHover: (_) => widget.onHover,
    );
  }
}
