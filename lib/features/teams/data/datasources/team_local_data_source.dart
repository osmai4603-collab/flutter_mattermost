import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';

abstract class TeamLocalDataSource {
  /// آخر فريق اختاره المستخدم في الخادم النشط — يُستخدم لاستعادة السياق عند الإقلاع.
  Future<String?> getLastSelectedTeamId();
  Future<void> setLastSelectedTeamId(String teamId);
}

@LazySingleton(as: TeamLocalDataSource)
class TeamLocalDataSourceImpl implements TeamLocalDataSource {
  final AppDatabase _db;
  final ServerManager _serverManager;

  TeamLocalDataSourceImpl(this._db, this._serverManager);

  @override
  Future<String?> getLastSelectedTeamId() async {
    final server =
        await (_db.select(_db.servers)
              ..where((tbl) => tbl.id.equals(_serverManager.activeServerUrl)))
            .getSingleOrNull();
    return server?.currentUserId;
  }

  @override
  Future<void> setLastSelectedTeamId(String teamId) async {
    final serverId = _serverManager.activeServerUrl;
    final exists = await (_db.select(
      _db.servers,
    )..where((tbl) => tbl.id.equals(serverId))).getSingleOrNull();
    if (exists == null) {
      await _db
          .into(_db.servers)
          .insert(
            ServersCompanion.insert(
              id: serverId,
              url: serverId,
              name: serverId,
            ),
            onConflict: DoUpdate(
              (old) => ServersCompanion(),
              target: [_db.servers.id],
            ),
          );
    } else {
      await (_db.update(
        _db.servers,
      )..where((tbl) => tbl.id.equals(serverId))).write(ServersCompanion());
    }
  }
}
