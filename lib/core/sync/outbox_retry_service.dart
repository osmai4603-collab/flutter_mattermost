import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/connectivity_monitor.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/pending_post_entity.dart';

@lazySingleton
class OutboxRetryService {
  final ChatLocalDataSource _localDataSource;
  final PostRemoteDataSource _remoteDataSource;
  final ConnectivityMonitor _connectivityMonitor;
  final WebSocketClientManager _wsClient;

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _wsStatusSubscription;
  Timer? _retryTimer;
  bool _isProcessing = false;

  OutboxRetryService(
    this._localDataSource,
    this._remoteDataSource,
    this._connectivityMonitor,
    this._wsClient,
  );

  void start() {
    _connectivitySubscription = _connectivityMonitor.onConnectivityChanged.listen((connected) {
      if (connected) {
        processOutbox();
      }
    });

    _wsStatusSubscription = _wsClient.statusStream.listen((status) {
      if (status == WebSocketStatus.connected) {
        processOutbox();
      }
    });

    // Periodic check every 1 minute as a fallback
    _retryTimer = Timer.periodic(const Duration(minutes: 1), (_) => processOutbox());
    
    // Initial check
    processOutbox();
  }

  void stop() {
    _connectivitySubscription?.cancel();
    _wsStatusSubscription?.cancel();
    _retryTimer?.cancel();
  }

  Future<void> processOutbox() async {
    if (_isProcessing) return;
    if (!_connectivityMonitor.isConnected) return;

    _isProcessing = true;
    try {
      final pendingPosts = await _localDataSource.getPendingPosts();
      final now = DateTime.now().millisecondsSinceEpoch;

      for (final post in pendingPosts) {
        if (post.status == PendingPostStatus.delivered ||
            post.status == PendingPostStatus.failedPermanent ||
            post.status == PendingPostStatus.sending) {
          continue;
        }

        // Check backoff
        if (post.retryCount > 0) {
          final delay = _getBackoffDelay(post.retryCount);
          if (now < post.lastAttemptAt + delay.inMilliseconds) {
            continue;
          }
        }

        if (post.retryCount >= 3) {
          await _localDataSource.updatePendingPost(
            post.copyWith(status: PendingPostStatus.failedPermanent),
          );
          continue;
        }

        await _sendPendingPost(post);
      }
    } finally {
      _isProcessing = false;
    }
  }

  Duration _getBackoffDelay(int retryCount) {
    // 2s, 5s, 15s approx
    switch (retryCount) {
      case 1:
        return const Duration(seconds: 2);
      case 2:
        return const Duration(seconds: 5);
      case 3:
        return const Duration(seconds: 15);
      default:
        return const Duration(seconds: 30);
    }
  }

  Future<void> _sendPendingPost(PendingPostEntity post) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Mark as sending
    await _localDataSource.updatePendingPost(
      post.copyWith(
        status: PendingPostStatus.sending,
        lastAttemptAt: now,
      ),
    );

    try {
      // We use createPost and include the pending_post_id in props if the API supports it
      // Mattermost API usually accepts 'pending_post_id' in the body
      await _remoteDataSource.createPost(
        channelId: post.channelId,
        message: post.message,
        rootId: post.rootId,
        fileIds: post.fileIds,
        // The server will echo this back in the 'posted' event
        metadata: {'pending_post_id': post.id}, 
      );

      // We don't mark as delivered here immediately because we wait for the WebSocket 'posted' event
      // to ensure consistency and get the real server ID.
      // However, for the outbox service, we can consider it "done" if the REST call succeeds.
      // But let's stay safe and mark as delivered so it's not picked up again.
      await _localDataSource.updatePendingPost(
        post.copyWith(status: PendingPostStatus.delivered),
      );
      
      // Cleanup will happen when WebSocket event arrives or here
      // await _localDataSource.deletePendingPost(post.id);

    } catch (e) {
      debugPrint('[outbox] failed to send post ${post.id}: $e');
      final newRetryCount = post.retryCount + 1;
      final newStatus = newRetryCount >= 3 
          ? PendingPostStatus.failedPermanent 
          : PendingPostStatus.failedNetwork;
          
      await _localDataSource.updatePendingPost(
        post.copyWith(
          status: newStatus,
          retryCount: newRetryCount,
          lastAttemptAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
