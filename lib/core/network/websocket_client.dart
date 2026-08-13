import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/reaction_model.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';

enum WebSocketStatus { disconnected, connecting, connected, error }

sealed class TypedWebSocketEvent {
  final int seq;
  TypedWebSocketEvent({required this.seq});
}

class PostCreatedEvent extends TypedWebSocketEvent {
  final PostEntity post;
  final String channelId;

  PostCreatedEvent({
    required this.post,
    required this.channelId,
    required super.seq,
  });
}

class PostUpdatedEvent extends TypedWebSocketEvent {
  final PostEntity post;
  final String channelId;

  PostUpdatedEvent({
    required this.post,
    required this.channelId,
    required super.seq,
  });
}

class PostDeletedEvent extends TypedWebSocketEvent {
  final String postId;
  final String channelId;

  PostDeletedEvent({
    required this.postId,
    required this.channelId,
    required super.seq,
  });
}

class ReactionChangedEvent extends TypedWebSocketEvent {
  final ReactionEntity reaction;
  final bool added;

  ReactionChangedEvent({
    required this.reaction,
    required this.added,
    required super.seq,
  });
}

class ChannelUpdatedEvent extends TypedWebSocketEvent {
  final ChannelEntity channel;
  final String channelId;

  ChannelUpdatedEvent({
    required this.channel,
    required this.channelId,
    required super.seq,
  });
}

/// انضمام مستخدم إلى قناة (user_added) — يحدّث عدد الأعضاء فورياً.
class UserAddedEvent extends TypedWebSocketEvent {
  final String userId;
  final String channelId;

  UserAddedEvent({
    required this.userId,
    required this.channelId,
    required super.seq,
  });
}

/// مغادرة/إزالة مستخدم من قناة (user_removed) — يحدّث عدد الأعضاء فورياً.
class UserRemovedEvent extends TypedWebSocketEvent {
  final String userId;
  final String channelId;

  UserRemovedEvent({
    required this.userId,
    required this.channelId,
    required super.seq,
  });
}

class UserPresenceEvent extends TypedWebSocketEvent {
  final String userId;
  final UserStatus status;

  UserPresenceEvent({
    required this.userId,
    required this.status,
    required super.seq,
  });
}

class UserTypingEvent extends TypedWebSocketEvent {
  final String userId;
  final String channelId;

  UserTypingEvent({
    required this.userId,
    required this.channelId,
    required super.seq,
  });
}

/// تغيّر حالة متابعة محادثة من جهاز آخر (thread_follow_changed).
class ThreadFollowChangedEvent extends TypedWebSocketEvent {
  final String teamId;
  final String threadId;
  final bool following;

  ThreadFollowChangedEvent({
    required this.teamId,
    required this.threadId,
    required this.following,
    required super.seq,
  });
}

/// تغيّر حالة قراءة محادثة (thread_read_changed).
class ThreadReadChangedEvent extends TypedWebSocketEvent {
  final String teamId;
  final String threadId;
  final String channelId;
  final int timestamp;
  final int unreadMentions;
  final int unreadReplies;

  ThreadReadChangedEvent({
    required this.teamId,
    required this.threadId,
    required this.channelId,
    required this.timestamp,
    required this.unreadMentions,
    required this.unreadReplies,
    required super.seq,
  });
}

/// مسودة جديدة/محدّثة من جهاز آخر (draft_created / draft_updated).
class DraftUpsertedEvent extends TypedWebSocketEvent {
  final Map<String, dynamic> draftJson;

  DraftUpsertedEvent({required this.draftJson, required super.seq});
}

/// حذف مسودة من جهاز آخر (draft_deleted).
class DraftDeletedEvent extends TypedWebSocketEvent {
  final Map<String, dynamic> draftJson;

  DraftDeletedEvent({required this.draftJson, required super.seq});
}

class CallStartedEvent extends TypedWebSocketEvent {
  final String callId;
  final String channelId;
  final String threadId;

  CallStartedEvent({
    required this.callId,
    required this.channelId,
    required this.threadId,
    required super.seq,
  });
}

class WebRTCSignalingEvent extends TypedWebSocketEvent {
  final Map<String, dynamic> data;

  WebRTCSignalingEvent({required this.data, required super.seq});
}

class UnknownWebSocketEvent extends TypedWebSocketEvent {
  final String rawEventName;
  final Map<String, dynamic> data;

  UnknownWebSocketEvent({
    required this.rawEventName,
    required this.data,
    required super.seq,
  });
}

@lazySingleton
class WebSocketClientManager {
  final SecureStorageService _secureStorage;
  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  StreamSubscription? _subscription;
  int _reconnectAttempts = 0;

  final _typedEventStreamController =
      StreamController<TypedWebSocketEvent>.broadcast();
  final _statusController = StreamController<WebSocketStatus>.broadcast();

  WebSocketStatus _status = WebSocketStatus.disconnected;
  WebSocketStatus get status => _status;

  Stream<TypedWebSocketEvent> get eventStream =>
      _typedEventStreamController.stream;
  Stream<WebSocketStatus> get statusStream => _statusController.stream;

  WebSocketClientManager(this._secureStorage);

  Future<void> connect({String? customWsUrl}) async {
    if (_status == WebSocketStatus.connected ||
        _status == WebSocketStatus.connecting) {
      return;
    }

    _updateStatus(WebSocketStatus.connecting);

    final wsUrl = customWsUrl ?? AppConfig.defaultWebSocketUrl;
    final token = await _secureStorage.getAuthToken();

    try {
      final uri = Uri.parse(wsUrl);
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;

      _subscription = _channel!.stream.listen(
        (message) => _onMessageReceived(message),
        onError: (error) => _handleDisconnectAndReconnect(),
        onDone: () => _handleDisconnectAndReconnect(),
      );

      _reconnectAttempts = 0;
      _updateStatus(WebSocketStatus.connected);
      _startHeartbeat();

      if (token != null && token.isNotEmpty) {
        _authenticate(token);
      }
    } catch (e) {
      _handleDisconnectAndReconnect();
    }
  }

  void _handleDisconnectAndReconnect() {
    _onDisconnected();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectAttempts++;
    final delayMs =
        (500 * pow(2, min(_reconnectAttempts, 5))).toInt() +
        Random().nextInt(200);
    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () {
      if (_status == WebSocketStatus.disconnected) {
        connect();
      }
    });
  }

  void _authenticate(String token) {
    sendJson({
      'seq': 1,
      'action': 'authentication_challenge',
      'data': {'token': token},
    });
  }

  void _startHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(AppConfig.webSocketPingInterval, (_) {
      if (_status == WebSocketStatus.connected) {
        sendJson({
          'seq': DateTime.now().millisecondsSinceEpoch,
          'action': 'ping',
        });
      }
    });
  }

  void _onMessageReceived(dynamic rawData) {
    try {
      final decoded = jsonDecode(rawData as String) as Map<String, dynamic>;
      final seq = decoded['seq'] as int? ?? 0;
      final eventName = decoded['event'] as String?;

      if (eventName != null) {
        final data = (decoded['data'] as Map<String, dynamic>?) ?? {};
        final broadcast =
            (decoded['broadcast'] as Map<String, dynamic>?) ?? {};
        final teamId = broadcast['team_id'] as String? ?? '';

        switch (eventName) {
          case 'posted':
            final postJson =
                jsonDecode(data['post'] as String? ?? '{}')
                    as Map<String, dynamic>;
            final postEntity = _parsePost(postJson);
            final channelId =
                (data['channel_id'] as String?)?.isNotEmpty == true
                ? data['channel_id'] as String
                : postEntity.channelId;
            _typedEventStreamController.add(
              PostCreatedEvent(
                post: postEntity,
                channelId: channelId,
                seq: seq,
              ),
            );
            break;
          case 'post_edited':
            final postJson =
                jsonDecode(data['post'] as String? ?? '{}')
                    as Map<String, dynamic>;
            final postEntity = _parsePost(postJson);
            final channelId =
                (data['channel_id'] as String?)?.isNotEmpty == true
                ? data['channel_id'] as String
                : postEntity.channelId;
            _typedEventStreamController.add(
              PostUpdatedEvent(
                post: postEntity,
                channelId: channelId,
                seq: seq,
              ),
            );
            break;
          case 'post_deleted':
            final postJson =
                jsonDecode(data['post'] as String? ?? '{}')
                    as Map<String, dynamic>;
            _typedEventStreamController.add(
              PostDeletedEvent(
                postId: postJson['id'] as String? ?? '',
                channelId: postJson['channel_id'] as String? ?? '',
                seq: seq,
              ),
            );
            break;
          case 'reaction_added':
          case 'reaction_removed':
            final reactionRaw = data['reaction'] as String?;
            final reactionJson = (reactionRaw != null && reactionRaw.isNotEmpty)
                ? jsonDecode(reactionRaw) as Map<String, dynamic>
                : (data['reaction'] as Map<String, dynamic>? ?? {});
            final reactionEntity = _parseReaction(reactionJson);
            _typedEventStreamController.add(
              ReactionChangedEvent(
                reaction: reactionEntity,
                added: eventName == 'reaction_added',
                seq: seq,
              ),
            );
            break;
          case 'channel_updated':
          case 'channel_created':
          case 'channel_deleted':
            final channelRaw = data['channel'] as String?;
            final channelJson = (channelRaw != null && channelRaw.isNotEmpty)
                ? jsonDecode(channelRaw) as Map<String, dynamic>
                : (data['channel'] as Map<String, dynamic>? ?? {});
            final channelEntity = _parseChannel(channelJson);
            _typedEventStreamController.add(
              ChannelUpdatedEvent(
                channel: channelEntity,
                channelId: channelEntity.id.isNotEmpty
                    ? channelEntity.id
                    : (data['channel_id'] as String? ?? ''),
                seq: seq,
              ),
            );
            break;
          case 'presence':
            _typedEventStreamController.add(
              UserPresenceEvent(
                userId: data['user_id'] as String? ?? '',
                status: UserStatus.fromValue(data['status'] as String?),
                seq: seq,
              ),
            );
            break;
          case 'user_added':
            _typedEventStreamController.add(
              UserAddedEvent(
                userId: data['user_id'] as String? ?? '',
                channelId: data['channel_id'] as String? ?? '',
                seq: seq,
              ),
            );
            break;
          case 'user_removed':
            _typedEventStreamController.add(
              UserRemovedEvent(
                userId: data['user_id'] as String? ?? '',
                channelId: data['channel_id'] as String? ?? '',
                seq: seq,
              ),
            );
            break;
          case 'typing':
            _typedEventStreamController.add(
              UserTypingEvent(
                userId: data['user_id'] as String? ?? '',
                channelId: data['channel_id'] as String? ?? '',
                seq: seq,
              ),
            );
            break;
          case 'thread_follow_changed':
            _typedEventStreamController.add(
              ThreadFollowChangedEvent(
                teamId: teamId,
                threadId: data['thread_id'] as String? ?? '',
                following: data['state'] as bool? ?? false,
                seq: seq,
              ),
            );
            break;
          case 'thread_read_changed':
            _typedEventStreamController.add(
              ThreadReadChangedEvent(
                teamId: teamId,
                threadId: data['thread_id'] as String? ?? '',
                channelId: data['channel_id'] as String? ?? '',
                timestamp: (data['timestamp'] as num?)?.toInt() ?? 0,
                unreadMentions:
                    (data['unread_mentions'] as num?)?.toInt() ?? 0,
                unreadReplies: (data['unread_replies'] as num?)?.toInt() ?? 0,
                seq: seq,
              ),
            );
            break;
          case 'draft_created':
          case 'draft_updated':
            final draftJson = _parseDraftJson(data);
            if (draftJson != null) {
              _typedEventStreamController.add(
                DraftUpsertedEvent(draftJson: draftJson, seq: seq),
              );
            }
            break;
          case 'draft_deleted':
            final deletedDraftJson = _parseDraftJson(data);
            if (deletedDraftJson != null) {
              _typedEventStreamController.add(
                DraftDeletedEvent(draftJson: deletedDraftJson, seq: seq),
              );
            }
            break;
          case 'custom_com.mattermost.calls_call_started':
            _typedEventStreamController.add(
              CallStartedEvent(
                callId: data['call_id'] as String? ?? '',
                channelId: data['channel_id'] as String? ?? '',
                threadId: data['thread_id'] as String? ?? '',
                seq: seq,
              ),
            );
            break;
          default:
            if (eventName.startsWith('custom_com.mattermost.calls_webrtc') ||
                eventName.startsWith('custom_com.mattermost.calls_ice')) {
              _typedEventStreamController.add(
                WebRTCSignalingEvent(data: data, seq: seq),
              );
            } else {
              _typedEventStreamController.add(
                UnknownWebSocketEvent(
                  rawEventName: eventName,
                  data: data,
                  seq: seq,
                ),
              );
            }
            break;
        }
      }
    } catch (_) {}
  }

  void sendCallSignal(String action, Map<String, dynamic> data) {
    sendJson({
      'action': 'custom_com.mattermost.calls_$action',
      'seq': DateTime.now().millisecondsSinceEpoch,
      'data': data,
    });
  }

  /// يخبر الخادم بأن هذه القناة هي القناة النشطة الآن — مطابق
  /// `WebSocketClient.updateActiveChannel` في webapp (platform/client/src/websocket.ts).
  /// يرسل حدث `presence` مع channel_id لكي يتلقى المستخدم حالات التواجد
  /// (online/away/dnd) للمستخدمين الظاهرين في القناة النشطة فقط.
  void updateActiveChannel(String channelId) {
    if (channelId.isEmpty) return;
    sendJson({
      'action': 'presence',
      'seq': DateTime.now().millisecondsSinceEpoch,
      'data': {'channel_id': channelId},
    });
  }

  void sendJson(Map<String, dynamic> jsonMap) {
    if (_channel != null && _status == WebSocketStatus.connected) {
      _channel!.sink.add(jsonEncode(jsonMap));
    }
  }

  void _onDisconnected() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _updateStatus(WebSocketStatus.disconnected);
  }

  void disconnect() {
    _onDisconnected();
    _channel?.sink.close();
  }

  void _updateStatus(WebSocketStatus newStatus) {
    _status = newStatus;
    if (!_statusController.isClosed) {
      _statusController.add(_status);
    }
  }

  void dispose() {
    disconnect();
    _typedEventStreamController.close();
    _statusController.close();
  }

  PostEntity _parsePost(Map<String, dynamic> json) {
    return PostModel.fromMap(json).toEntity();
  }

  ReactionEntity _parseReaction(Map<String, dynamic> json) {
    return ReactionModel.fromMap(json).toEntity();
  }

  ChannelEntity _parseChannel(Map<String, dynamic> json) {
    return ChannelModel.fromMap(json).toEntity();
  }

  /// يستخرج JSON المسودة من حمولة حدث draft_* — مطابق هياكل webapp
  /// (WebSocketMessages.PostDraft) حيث `data.draft` نص JSON.
  Map<String, dynamic>? _parseDraftJson(Map<String, dynamic> data) {
    final raw = data['draft'];
    if (raw is String && raw.isNotEmpty) {
      return jsonDecode(raw) as Map<String, dynamic>;
    }
    if (raw is Map<String, dynamic>) return raw;
    return null;
  }
}
