import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Servers (Multi-server support)
class Servers extends Table {
  TextColumn get id => text()(); // URL or UUID
  TextColumn get url => text()();
  TextColumn get name => text()();
  TextColumn get currentUserId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// Tables definitions
class CachedUsers extends Table {
  TextColumn get serverId => text()();
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get firstName => text().withDefault(const Constant(''))();
  TextColumn get lastName => text().withDefault(const Constant(''))();
  TextColumn get nickname => text().withDefault(const Constant(''))();
  TextColumn get position => text().withDefault(const Constant(''))();
  TextColumn get roles => text().withDefault(const Constant('system_user'))();

  @override
  Set<Column> get primaryKey => {serverId, id};
}

class CachedTeams extends Table {
  TextColumn get serverId => text()();
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get displayName => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant('O'))();

  @override
  Set<Column> get primaryKey => {serverId, id};
}

class CachedChannels extends Table {
  TextColumn get serverId => text()();
  TextColumn get id => text()();
  TextColumn get teamId => text().withDefault(const Constant(''))();
  TextColumn get name => text()();
  TextColumn get displayName => text()();
  TextColumn get header => text().withDefault(const Constant(''))();
  TextColumn get purpose => text().withDefault(const Constant(''))();
  TextColumn get type => text()();
  IntColumn get lastPostAt => integer()();
  IntColumn get totalMsgCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {serverId, id};
}

class CachedPosts extends Table {
  TextColumn get serverId => text()();
  TextColumn get id => text()();
  TextColumn get channelId => text()();
  TextColumn get userId => text()();
  TextColumn get message => text()();
  TextColumn get rootId => text().withDefault(const Constant(''))();
  IntColumn get createAt => integer()();
  IntColumn get updateAt => integer()();
  IntColumn get deleteAt => integer().withDefault(const Constant(0))();
  TextColumn get pendingPostId => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {serverId, id};
}

// تفاعلات الإيموجي
class CachedReactions extends Table {
  TextColumn get serverId => text()();
  TextColumn get userId => text()();
  TextColumn get postId => text()();
  TextColumn get emojiName => text()();
  IntColumn get createAt => integer()();

  @override
  Set<Column> get primaryKey => {serverId, userId, postId, emojiName};
}

// معلومات الملفات المرفقة
class CachedFileInfo extends Table {
  TextColumn get serverId => text()();
  TextColumn get id => text()();
  TextColumn get postId => text()();
  TextColumn get creatorId => text()();
  TextColumn get name => text()();
  TextColumn get extension_ => text()();
  IntColumn get size => integer()();
  TextColumn get mimeType => text().withDefault(const Constant(''))();
  IntColumn get width => integer().withDefault(const Constant(0))();
  IntColumn get height => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {serverId, id};
}

// أعضاء القنوات
class CachedChannelMembers extends Table {
  TextColumn get serverId => text()();
  TextColumn get channelId => text()();
  TextColumn get userId => text()();
  TextColumn get roles => text().withDefault(const Constant(''))();
  IntColumn get lastViewedAt => integer().withDefault(const Constant(0))();
  IntColumn get msgCount => integer().withDefault(const Constant(0))();
  IntColumn get mentionCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {serverId, channelId, userId};
}

// حالة المستخدمين (أونلاين/أوفلاين)
class CachedUserStatuses extends Table {
  TextColumn get serverId => text()();
  TextColumn get userId => text()();
  TextColumn get status => text()(); // online, away, dnd, offline
  IntColumn get lastActivityAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {serverId, userId};
}

// تفضيلات المستخدم
class CachedPreferences extends Table {
  TextColumn get serverId => text()();
  TextColumn get userId => text()();
  TextColumn get category => text()();
  TextColumn get name => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {serverId, userId, category, name};
}

// محفوظ آخر مزامنة (Delta Sync)
class SyncMetadata extends Table {
  TextColumn get serverId => text()();
  TextColumn get key => text()(); // e.g. 'channels_last_sync'
  IntColumn get lastSyncAt => integer()();

  @override
  Set<Column> get primaryKey => {serverId, key};
}

// Offline Queue Table for Outbox pattern
class PendingActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serverId => text()();
  TextColumn get actionType => text()(); // e.g. 'CREATE_POST', 'ADD_REACTION'
  TextColumn get payloadJson => text()();
  IntColumn get createdAt => integer()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // pending, failed, completed
  TextColumn get tempId => text().withDefault(const Constant(''))();
}

class PendingPosts extends Table {
  TextColumn get id => text()(); // Local UUID
  TextColumn get serverId => text()();
  TextColumn get channelId => text()();
  TextColumn get userId => text()();
  TextColumn get message => text()();
  TextColumn get rootId => text().withDefault(const Constant(''))();
  TextColumn get fileIds => text().withDefault(const Constant('[]'))(); // JSON array
  IntColumn get createdAt => integer()();
  IntColumn get lastAttemptAt => integer().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id, serverId};
}

// الأدوار والصلاحيات المخزنة محلياً
class CachedRoles extends Table {
  TextColumn get serverId => text()();
  TextColumn get name => text()();
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();
  TextColumn get permissions => text()(); // JSON array of permission names
  BoolColumn get schemeManaged =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {serverId, name};
}

@lazySingleton
@DriftDatabase(
  tables: [
    Servers,
    CachedUsers,
    CachedTeams,
    CachedChannels,
    CachedPosts,
    CachedReactions,
    CachedFileInfo,
    CachedChannelMembers,
    CachedUserStatuses,
    CachedPreferences,
    SyncMetadata,
    PendingActions,
    PendingPosts,
    CachedRoles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openDatabaseConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Re-create all for simplicity in this phase since data is not yet in production
      if (from < 5) {
        await m.createAll();
      }
    },
  );
}

LazyDatabase openDatabaseConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'mattermost_desktop.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
