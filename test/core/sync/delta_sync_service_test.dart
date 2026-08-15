import 'dart:ffi';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/core/sync/delta_sync_service.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';

import '../../features/channels/test_fakes.dart';

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 30));

class _FakeServerManager implements ServerManager {
  @override
  String get activeServerUrl => 'http://test/api/v4';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async => const UserEntity(id: 'u1');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePostRemoteDataSource implements PostRemoteDataSource {
  final Map<String, List<PostModel>> postsByChannel;
  final List<int> sinceCalls = [];

  _FakePostRemoteDataSource(this.postsByChannel);

  @override
  Future<List<PostModel>> getPostsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    int? since,
    String? after,
    String? before,
    bool fetchDeleted = false,
    bool collapsedThreads = false,
  }) async {
    sinceCalls.add(since ?? 0);
    final all = postsByChannel[channelId] ?? const <PostModel>[];
    return all.where((p) => p.createAt > (since ?? 0)).toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeChatLocalDataSource implements ChatLocalDataSource {
  List<PostEntity> cachedPosts = [];
  List<ChannelEntity> cachedChannels;

  _FakeChatLocalDataSource(this.cachedChannels);

  @override
  Future<void> cachePosts(List<PostEntity> posts) async {
    cachedPosts = [...cachedPosts, ...posts];
  }

  @override
  Future<List<ChannelEntity>> getCachedChannels(String teamId) async =>
      cachedChannels;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTeamRepository implements TeamRepository {
  final List<TeamEntity> teams;

  _FakeTeamRepository(this.teams);

  @override
  Future<List<TeamEntity>> getMyTeams({int page = 0, int perPage = 60}) async =>
      teams;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // النظام لا يوفر ملف libsqlite3.so غير المنسوخ — نوجه تحميل sqlite3
  // إلى النسخة المثبتة فعلياً (libsqlite3.so.0) لتعمل الاختبارات.
  open.overrideFor(
    OperatingSystem.linux,
    () => DynamicLibrary.open('libsqlite3.so.0'),
  );

  late AppDatabase db;
  late _FakeServerManager serverManager;
  late _FakePostRemoteDataSource remote;
  late _FakeChatLocalDataSource local;
  late FakeWebSocketClientManager ws;
  late DeltaSyncService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    serverManager = _FakeServerManager();
    remote = _FakePostRemoteDataSource({
      'c1': [
        PostModel.fromMap(
          {'id': 'p1', 'channel_id': 'c1', 'create_at': 100},
        ),
        PostModel.fromMap(
          {'id': 'p2', 'channel_id': 'c1', 'create_at': 200},
        ),
        PostModel.fromMap(
          {'id': 'p3', 'channel_id': 'c1', 'create_at': 300},
        ),
      ],
    });
    local = _FakeChatLocalDataSource([testChannel('c1')]);
    ws = FakeWebSocketClientManager();
    service = DeltaSyncService(
      local,
      remote,
      _FakeAuthRepository(),
      db,
      serverManager,
      _FakeTeamRepository([
        const TeamEntity(
          id: 't1',
          name: 'team',
          displayName: 'Team',
          type: TeamType.open,
        ),
      ]),
      ws,
    );
  });

  tearDown(() async {
    service.stop();
    await db.close();
  });

  test('syncPosts fetches since watermark and advances it', () async {
    await service.syncPosts('c1');
    expect(remote.sinceCalls, [0]);
    expect(local.cachedPosts.map((p) => p.id), ['p1', 'p2', 'p3']);

    // مزامنة ثانية تُجلب ما بعد آخر watermark فقط.
    await service.syncPosts('c1');
    expect(remote.sinceCalls, [0, 300]);
    expect(local.cachedPosts.map((p) => p.id), ['p1', 'p2', 'p3']);
  });

  test('advanceWatermark raises watermark on realtime events', () async {
    await service.advanceWatermark('c1', 150);
    await service.advanceWatermark('c1', 100);

    await service.syncPosts('c1');
    expect(remote.sinceCalls, [150]);
    expect(local.cachedPosts.map((p) => p.id), ['p2', 'p3']);
  });

  test('PostCreatedEvent advances watermark via service listener', () async {
    service.start();
    ws.emit(
      PostCreatedEvent(
        post: PostModel.fromMap(
          {'id': 'p5', 'channel_id': 'c1', 'create_at': 500},
        ),
        channelId: 'c1',
        seq: 1,
      ),
    );
    await _settle();

    await service.syncPosts('c1');
    expect(remote.sinceCalls, [500]);
  });

  test('full resync reconnect triggers fullSync for cached channels', () async {
    service.start();
    ws.emit(WebSocketReconnectedEvent(fullResync: true, seq: 0));
    await _settle();

    // fullSync: الفرق → القنوات المخزنة → مزامنة كل قناة منذ 0.
    expect(remote.sinceCalls, contains(0));
    expect(local.cachedPosts.map((p) => p.id), ['p1', 'p2', 'p3']);
  });

  test('non-full resync does not trigger fullSync', () async {
    service.start();
    ws.emit(WebSocketReconnectedEvent(fullResync: false, seq: 1));
    await _settle();

    expect(remote.sinceCalls, isEmpty);
  });
}
