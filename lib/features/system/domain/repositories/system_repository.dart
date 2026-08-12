import 'package:flutter_mattermost/features/system/domain/entities/emoji_entity.dart';
import 'package:flutter_mattermost/features/system/domain/entities/system_info_entity.dart';

abstract class SystemRepository {
  Future<SystemInfoEntity> getSystemInfo();
  Future<Map<String, dynamic>> ping({int? timeoutSeconds});
  Future<String> getServerVersion();
  Future<List<String>> getTimezoneList();
  Future<List<EmojiEntity>> getEmojiList({int page = 0, int perPage = 60});
  Future<List<EmojiEntity>> searchEmoji(String term, {bool prefixOnly = false});
  Future<List<EmojiEntity>> autocompleteEmoji(String term);
  Future<bool> isScheduledPostsEnabled();
}
