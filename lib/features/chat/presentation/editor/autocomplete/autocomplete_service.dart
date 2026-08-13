import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/data/datasources/channels_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/emoji_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_item.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/commands/slash_commands_registry.dart';
import 'package:flutter_mattermost/features/integrations/data/datasources/commands_remote_data_source.dart';
import 'package:flutter_mattermost/features/users/data/datasources/user_status_remote_data_source.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

/// طبقة الإكمال التلقائي — تجمع المصادر القائمة عبر [getIt] مع:
/// - debounce لا يُدار هنا بل في [AutocompleteController] (300ms)
/// - تخزين مؤقت (cache) للاستعلامات المتكررة
/// - فشل صامت: أي خطأ شبكة يُرجع قائمة فارغة بدل إزعاج المستخدم
class AutocompleteService {
  AutocompleteService({required this.teamId, this.channelId = ''});

  final String teamId;
  final String channelId;

  static const int _cacheLimit = 60;

  final Map<String, ({DateTime at, List<AutocompleteItem> items})> _cache = {};

  List<AutocompleteItem>? _cachedList(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.at).inSeconds > 30) {
      _cache.remove(key);
      return null;
    }
    return entry.items;
  }

  void _store(String key, List<AutocompleteItem> items) {
    if (_cache.length >= _cacheLimit) {
      final oldest = _cache.entries.reduce(
        (a, b) => a.value.at.isBefore(b.value.at) ? a : b,
      );
      _cache.remove(oldest.key);
    }
    _cache[key] = (at: DateTime.now(), items: items);
  }

  // ─────────────────────────── @mentions ───────────────────────────

  /// بحث المستخدمين + التنبيهات الخاصة (@all/@channel/@here) المطابقة.
  Future<List<AutocompleteItem>> searchMentions(String query) async {
    final key = 'mention:$query';
    final cached = _cachedList(key);
    if (cached != null) return cached;

    final result = <AutocompleteItem>[];
    for (final special in const ['all', 'channel', 'here']) {
      if (special.startsWith(query)) {
        // الوصف يُحل في الويدجت عبر الترجمة (l10n).
        result.add(AutocompleteItem.specialMention(special, ''));
      }
    }

    try {
      final users = await getIt<UsersRemoteDataSource>().autocompleteUsers(
        query,
        channelId: channelId.isEmpty ? null : channelId,
      );
      if (users.isNotEmpty) {
        final statuses = await _fetchStatuses(
          users.take(10).map((u) => u.id).toList(),
        );
        result.addAll(
          users.map(
            (u) => AutocompleteItem(
              kind: AutocompleteKind.mention,
              userId: u.id,
              title: getMentionDisplayName(
                username: u.username,
                nickname: u.nickname,
                firstName: u.firstName,
                lastName: u.lastName,
              ),
              subtitle: '@${u.username}',
              insertText: '@${u.username} ',
              status: statuses[u.id],
              roles: u.roles,
            ),
          ),
        );
      }
    } catch (_) {
      // فشل الشبكة: نكتفي بالتنبيهات الخاصة.
    }

    _store(key, result);
    return result;
  }

  Future<Map<String, UserStatus>> _fetchStatuses(List<String> userIds) async {
    if (userIds.isEmpty) return const {};
    try {
      final statuses = await getIt<UserStatusRemoteDataSource>()
          .getStatusesByIds(userIds);
      return {for (final s in statuses) s.userId: s.status};
    } catch (_) {
      return const {};
    }
  }

  // ─────────────────────────── #channels ───────────────────────────

  /// بحث القنوات ضمن الفريق الحالي.
  Future<List<AutocompleteItem>> searchChannels(String query) async {
    if (teamId.isEmpty) return const [];
    final key = 'channel:$query';
    final cached = _cachedList(key);
    if (cached != null) return cached;

    final result = <AutocompleteItem>[];
    try {
      final channels = await getIt<ChannelRemoteDataSource>()
          .autocompleteChannels(teamId, query);
      result.addAll(
        channels.map(
          (c) => AutocompleteItem(
            kind: AutocompleteKind.channel,
            title: c.displayName,
            subtitle: '#${c.name}',
            insertText: '#${c.name} ',
            channelType: c.type.value,
          ),
        ),
      );
    } catch (_) {
      // فشل الشبكة: قائمة فارغة.
    }
    _store(key, result);
    return result;
  }

  // ─────────────────────────── /commands ───────────────────────────

  /// أوامر السلاش: المدمجة (محلياً) + المخصصة من الخادم.
  Future<List<AutocompleteItem>> searchCommands(String query) async {
    final key = 'command:$query';
    final cached = _cachedList(key);
    if (cached != null) return cached;

    final result = <AutocompleteItem>[];
    for (final cmd in SlashCommandsRegistry.search(query)) {
      result.add(
        AutocompleteItem(
          kind: AutocompleteKind.command,
          title: '/${cmd.trigger}',
          // الوصف يُحل في الويدجت عبر [SlashCommandsRegistry.match].
          insertText: '/${cmd.trigger} ',
        ),
      );
    }

    if (teamId.isNotEmpty) {
      try {
        final commands = await getIt<CommandsRemoteDataSource>()
            .autocompleteCommands(teamId);
        final known = {for (final c in result) c.title};
        for (final cmd in commands) {
          if (cmd.autoComplete != true) continue;
          final trigger = (cmd.trigger ?? '').toLowerCase();
          if (trigger.isEmpty || !trigger.startsWith(query)) continue;
          final title = '/$trigger';
          if (known.contains(title)) continue;
          result.add(
            AutocompleteItem(
              kind: AutocompleteKind.command,
              title: title,
              subtitle: (cmd.autoCompleteDesc?.isNotEmpty ?? false)
                  ? cmd.autoCompleteDesc
                  : null,
              insertText: '$title ',
            ),
          );
        }
      } catch (_) {
        // فشل الشبكة: الأوامر المدمجة فقط.
      }
    }

    _store(key, result);
    return result;
  }

  // ─────────────────────────── :emoji ───────────────────────────

  /// إيموجي يونيكود (محلي) + إيموجي مخصص من الخادم.
  Future<List<AutocompleteItem>> searchEmojis(String query) async {
    final key = 'emoji:$query';
    final cached = _cachedList(key);
    if (cached != null) return cached;

    final q = query.toLowerCase();
    final result = <AutocompleteItem>[];
    for (final set in defaultEmojiSet) {
      for (final emoji in set.emoji) {
        if (result.length >= 24) break;
        if (emoji.name.contains(q)) {
          result.add(
            AutocompleteItem(
              kind: AutocompleteKind.emoji,
              title: emoji.emoji,
              subtitle: ':$q:',
              insertText: '${emoji.emoji} ',
              emojiUnicode: emoji.emoji,
              emojiName: emoji.name,
            ),
          );
        }
      }
      if (result.length >= 24) break;
    }

    try {
      final customs = await getIt<EmojiRemoteDataSource>()
          .autocompleteCustomEmoji(prefix: query);
      for (final emoji in customs.where((custom) => custom.name.isNotEmpty)) {
        result.add(
          AutocompleteItem(
            kind: AutocompleteKind.emoji,
            title: ':${emoji.name}:',
            subtitle: 'custom',
            insertText: ':${emoji.name}: ',
            emojiName: emoji.name,
          ),
        );
      }
    } catch (_) {
      // فشل الشبكة: الإيموجي المحلي فقط.
    }

    _store(key, result);
    return result;
  }
}
