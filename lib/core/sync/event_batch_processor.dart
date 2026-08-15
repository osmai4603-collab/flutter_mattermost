import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';

@lazySingleton
class EventBatchProcessor {
  final ChatLocalDataSource _localDataSource;
  final List<PostEntity> _postBuffer = [];
  Timer? _flushTimer;
  final _flushInterval = const Duration(milliseconds: 300);
  final _maxBatchSize = 50;

  EventBatchProcessor(this._localDataSource);

  void bufferPost(PostEntity post) {
    _postBuffer.add(post);
    if (_postBuffer.length >= _maxBatchSize) {
      _flush();
    } else {
      _flushTimer?.cancel();
      _flushTimer = Timer(_flushInterval, _flush);
    }
  }

  Future<void> _flush() async {
    if (_postBuffer.isEmpty) return;
    
    final toProcess = List<PostEntity>.from(_postBuffer);
    _postBuffer.clear();
    _flushTimer?.cancel();

    await _localDataSource.cachePosts(toProcess);
  }

  void dispose() {
    _flushTimer?.cancel();
  }
}
