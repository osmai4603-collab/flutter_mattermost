import 'package:shared_preferences/shared_preferences.dart';

/// تخزين مسودات الرسائل محلياً — نظير `draft.v2` في localStorage
/// (webapp/channels/src/types/store/draft.ts + actions/new_drafts.ts).
///
/// المفتاح: `draft.v2.<channelId>` للقناة، و`draft.v2.<channelId>.<rootId>`
/// لمسودة الرد ضمن ثريد (rootId غير فارغ).
class DraftStorageService {
  static SharedPreferences? _prefs;

  static String _key(String channelId, String rootId) {
    if (rootId.isEmpty) return 'draft.v2.$channelId';
    return 'draft.v2.$channelId.$rootId';
  }

  Future<SharedPreferences> _ensure() async {
    final existing = _prefs;
    if (existing != null) return existing;
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    return prefs;
  }

  /// يسترجع نص المسودة المخزنة للقناة (أو null إن لم توجد).
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
  }

  /// يمسح المسودة المخزنة للقناة.
  Future<void> clear(String channelId, String rootId) async {
    final prefs = await _ensure();
    await prefs.remove(_key(channelId, rootId));
  }
}