import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_mattermost/features/chat/presentation/files/file_display_utils.dart';

/// صورة تُحمّل من خادم Mattermost عبر CachedNetworkImage
/// مع ترويسات توثيق Bearer (تُجلب من التخزين الآمن).
class AuthCachedImage extends StatefulWidget {
  final String url;
  final BoxFit fit;
  final LoadingErrorWidgetBuilder? errorBuilder;

  const AuthCachedImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  State<AuthCachedImage> createState() => _AuthCachedImageState();
}

class _AuthCachedImageState extends State<AuthCachedImage> {
  Map<String, String>? _headers;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final headers = await authHeaders();
    if (mounted) setState(() => _headers = headers);
  }

  @override
  Widget build(BuildContext context) {
    final headers = _headers;
    if (headers == null) {
      return Container(color: Colors.black12);
    }
    return CachedNetworkImage(
      imageUrl: widget.url,
      fit: widget.fit,
      httpHeaders: headers,
      errorWidget: widget.errorBuilder,
      placeholder: (context, url) => Container(color: Colors.black12),
    );
  }
}
