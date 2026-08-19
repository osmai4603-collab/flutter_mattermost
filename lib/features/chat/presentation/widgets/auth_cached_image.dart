import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';

/// صورة تُحمّل من خادم Mattermost عبر تحميل مباشر للبيانات
/// مع ترويسات توثيق Bearer.
class AuthCachedImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace)? errorBuilder;
  final double? width;
  final double? height;

  const AuthCachedImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.errorBuilder,
    this.width,
    this.height,
  });

  @override
  State<AuthCachedImage> createState() => _AuthCachedImageState();
}

class _AuthCachedImageState extends State<AuthCachedImage> {
  Future<Uint8List>? _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  Future<Uint8List> _loadImage() async {
    final fileId = _extractFileId(widget.url);
    if (fileId != null) {
      return getIt<PostRepository>().getFile(fileId);
    }
    throw Exception('Invalid file URL');
  }

  String? _extractFileId(String url) {
    final match = RegExp(r'/files/([^/]+)').firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingPlaceholder();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(
              context,
              snapshot.error?.toString() ?? '',
              StackTrace.empty,
            );
          }
          return _loadingPlaceholder();
        }
        return Image.memory(
          snapshot.data!,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          gaplessPlayback: true,
        );
      },
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black12,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
