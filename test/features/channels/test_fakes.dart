import 'dart:async';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/calls/calls_websocket_client.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_member_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

/// قناة اختبار بأقل الحقول المطلوبة.
ChannelEntity testChannel(
  String id, {
  String name = '',
  String displayName = '',
}) {
  return ChannelEntity(
    id: id,
    teamId: 'team1',
    displayName: displayName.isEmpty ? id : displayName,
    name: name.isEmpty ? id : name,
  );
}

/// مستودع قنوات وهمي يعتمد noSuchMethod — يعيد القوائم/الإحصاءات المحلية
/// فقط للمسارات المستخدمة في الاختبارات.
class FakeChannelRepository implements ChannelRepository {
  List<ChannelEntity> channels;
  List<ChannelStats> stats;

  FakeChannelRepository({required this.channels, this.stats = const []});

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName;
    if (name == #getMyChannels || name == #getChannelsForTeam) {
      return Future.value(channels);
    }
    if (name == #getChannelStats) {
      final id = invocation.positionalArguments.first as String;
      return Future.value(
        stats.firstWhere(
          (s) => s.channelId == id,
          orElse: () => ChannelStats(channelId: id, memberCount: 0),
        ),
      );
    }
    if (name == #getChannelCategories) {
      return Future.value(<ChannelCategoryEntity>[]);
    }
    if (name == #getUnreadCountsForTeam) {
      return Future.value(const <String, ChannelUnreadCounts>{});
    }
    if (name == #getMyChannelMembersInTeam) {
      return Future.value(<ChannelMemberEntity>[]);
    }
    return super.noSuchMethod(invocation);
  }
}

/// مدير WebSocket وهمي — يسمح بحقن أحداث TypedWebSocketEvent يدوياً.
class FakeWebSocketClientManager implements WebSocketClientManager {
  final StreamController<TypedWebSocketEvent> _controller =
      StreamController<TypedWebSocketEvent>.broadcast();

  /// القناة النشطة الأخيرة التي أُبلِغ عنها (presence).
  String? lastActiveChannelId;

  void emit(TypedWebSocketEvent event) => _controller.add(event);

  @override
  Stream<TypedWebSocketEvent> get eventStream => _controller.stream;

  @override
  void updateActiveChannel(String channelId) {
    lastActiveChannelId = channelId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

class FakePostRepository implements PostRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

class FakeTeamRepository implements TeamRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}

class FakeCallsManager implements CallsManager {
  @override
  Stream<CallStartedEvent> get incomingCalls => const Stream.empty();

  @override
  Stream<Map<String, CallParticipantState>> get participantsStream =>
      const Stream.empty();

  @override
  Stream<CallsWebSocketStatus> get connectionStatusStream =>
      const Stream.empty();

  @override
  Stream<String> get callEndedStream => const Stream.empty();

  @override
  Stream<CallState> get callStateStream => const Stream.empty();

  @override
  CallState get currentCallState => CallState.idle;

  @override
  Stream<String> get incomingCallExpiredStream => const Stream.empty();

  @override
  Stream<CallReactionEvent> get reactionsStream => const Stream.empty();

  @override
  Stream<CallHostControlEvent> get hostControlStream => const Stream.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      super.noSuchMethod(invocation);
}