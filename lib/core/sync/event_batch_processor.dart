import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';

@lazySingleton
class EventBatchProcessor {
  final List<PostEntity> _postBuffer = [];
  Timer? _flushTimer;
  final _flushInterval = const Duration(milliseconds: 300);
  final _maxBatchSize = 50;

  void bufferPost(PostEntity post) {
    _postBuffer.add(post);
    if (_postBuffer.length >= _maxBatchSize) {
      _flush();
    } else {
      _flushTimer?.cancel();
      _flushTimer = Timer(_flushInterval, _flush);
    }
  }

  void _flush() {
    _postBuffer.clear();
    _flushTimer?.cancel();
  }

  void dispose() {
    _flushTimer?.cancel();
  }
}
