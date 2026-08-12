import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/system/data/datasources/emoji_remote_data_source.dart';
import 'package:flutter_mattermost/features/system/data/datasources/system_config_remote_data_source.dart';
import 'package:flutter_mattermost/features/system/data/models/license_config_model.dart';
import 'package:flutter_mattermost/features/system/domain/entities/emoji_entity.dart';
import 'package:flutter_mattermost/features/system/domain/entities/system_info_entity.dart';
import 'package:flutter_mattermost/features/system/domain/repositories/system_repository.dart';

@LazySingleton(as: SystemRepository)
class SystemRepositoryImpl implements SystemRepository {
  final SystemConfigRemoteDataSource _configDataSource;
  final EmojiRemoteDataSource _emojiDataSource;
  SystemInfoEntity? _cachedInfo;

  SystemRepositoryImpl(this._configDataSource, this._emojiDataSource);

  @override
  Future<SystemInfoEntity> getSystemInfo() async {
    if (_cachedInfo != null) return _cachedInfo!;
    final clientConfig = await _configDataSource.getClientConfig();
    LicenseConfigModel? license;
    try {
      license = await _configDataSource.getLicenseConfig();
    } catch (_) {
      // لا توجد رخصة — نعتبر unlicensed.
    }
    final info = SystemInfoEntity(
      version: clientConfig.version.isNotEmpty ? clientConfig.version : 'unknown',
      maxFileSizeBytes: clientConfig.maxFileSizeBytes,
      isScheduledPostsEnabled: clientConfig.isScheduledPostsEnabled,
      isGuestAccountsEnabled: clientConfig.isGuestAccountsEnabled,
      isLicensed: license?.isLicensed ?? false,
      isTrial: license?.isTrial ?? false,
      skuShortName: license?.skuShortName ?? '',
    );
    _cachedInfo = info;
    return info;
  }

  @override
  Future<Map<String, dynamic>> ping({int? timeoutSeconds}) =>
      _configDataSource.ping(timeoutSeconds: timeoutSeconds);

  @override
  Future<String> getServerVersion() => _configDataSource.getServerVersion();

  @override
  Future<List<String>> getTimezoneList() => _configDataSource.getTimezoneList();

  @override
  Future<List<EmojiEntity>> getEmojiList({
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _emojiDataSource.getEmojiList(
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<EmojiEntity>> searchEmoji(
    String term, {
    bool prefixOnly = false,
  }) async {
    final models = await _emojiDataSource.searchEmoji({
      'term': term,
      'prefix_only': prefixOnly,
    });
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<EmojiEntity>> autocompleteEmoji(String term) async {
    final models = await _emojiDataSource.autocompleteEmoji(term);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> isScheduledPostsEnabled() async {
    final info = await getSystemInfo();
    return info.isScheduledPostsEnabled;
  }
}
