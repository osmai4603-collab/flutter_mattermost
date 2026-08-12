import 'package:drift/drift.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class StorageModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    mOptions: MacOsOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  @lazySingleton
  QueryExecutor get databaseExecutor => openDatabaseConnection();
}
