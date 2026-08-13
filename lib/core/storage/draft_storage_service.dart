import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// تخزين مسودات الرسائل محلياً — نظير `draft.v2` في localStorage
/// (webapp/channels/src/types/store/draft.ts + actions/new_drafts.ts).
///
/// المفتاح: `draft.v2.<channelId>` للقناة، و`draft.v2.<channelId>.<rootId>`
/// لمسودة الرد ضمن ثريد (rootId غير فارغ).
///
/// [ChangeNotifier] يُعلم الواجهات (الشريط الجانبي/صفحة المسودات) عند
/// تغيّر مجموعة القنوات التي تحمل مسودات محفوظة عبر [channelsWithDrafts].
class DraftStorageService extends ChangeNotifier {
  static const String _prefix = 'draft.v2.';
  static SharedPreferences? _prefs;

  Set<String> _channelIds = const {};

  /// معرفات القنوات التي لديها نص مسودة محفوظ (أي rootId).
  Set<String> get channelsWithDrafts => _channelIds;

  /// هل توجد مسودة محفوظة للقناة؟
  bool hasDraft(String channelId) => _channelIds.contains(channelId);

  static String _key(String channelId, String rootId) {
    if (rootId.isEmpty) return '$_prefix$channelId';
    return '$_prefix$channelId.$rootId';
  }

  Future<SharedPreferences> _ensure() async {
    final existing = _prefs;
    if (existing != null) return existing;
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _refreshChannels(prefs);
    return prefs;
  }

  /// يسترجع نص المسودة المخزنة (أو null إن لم توجد).
  ///
  /// تُستدعى عند الدخول للقناة/الثريد لاستعادة المسودة في المحرر.
  Future<String?> load(String channelId, String rootId) async {
    final prefs = await _ensure();
    return prefs.getString(_key(channelId, rootId));
  }

  /// يحفظ نص المسودة؛ يحذف المفتاح إن كانت فارغة (تعادل المسح).
  Future<void> save(String channelId, String rootId, String message) async {
    final prefs = await _ensure();
    final key = _key(channelId, rootId);
    if (message.isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, message);
    }
    _refreshChannels(prefs);
  }

  /// يمسح المسودة المخزنة للقناة/الثريد.
  Future<void> clear(String channelId, String rootId) =>
      save(channelId, rootId, '');

  /// كل المسودات المحلية: المفتاح الكامل (`draft.v2...`) → النص المحفوظ.
  ///
  /// تُستخدم في صفحة المسودات لعرض المسودات غير المُرسلة مع القنوات.
  Future<Map<String, String>> allDrafts() async {
    final prefs = await _ensure();
    final result = <String, String>{};
    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_prefix)) continue;
      final value = prefs.getString(key);
      if (value == null || value.isEmpty) continue;
      result[key] = value;
    }
    return result;
  }

  /// تحديث مجموعة القنوات ذات المسودات من المفاتيح المخزنة.
  void _refreshChannels(SharedPreferences prefs) {
    final ids = <String>{};
    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_prefix)) continue;
      final value = prefs.getString(key);
      if (value == null || value.isEmpty) continue;
      final id = key.substring(_prefix.length);
      ids.add(id.split('.').first);
    }
    if (setEquals(ids, _channelIds)) return;
    _channelIds = ids;
    notifyListeners();
  }
}