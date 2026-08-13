import 'package:shared_preferences/shared_preferences.dart';

/// تخزين سجل البحث الأخير — نظير `recentSearches` في localStorage
/// (webapp/search/selectors.ts + actions.ts).
class RecentSearchesStore {
  static const _key = 'recent_searches';
  static const int maxItems = 8;
  static SharedPreferences? _prefs;

  Future<SharedPreferences> _ensure() async {
    final existing = _prefs;
    if (existing != null) return existing;
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    return prefs;
  }

  /// آخر مصطلحات البحث (الأحدث أولاً).
  Future<List<String>> load() async {
    final prefs = await _ensure();
    return prefs.getStringList(_key) ?? const [];
  }

  /// يسجل مصطلح بحث جديد في المقدمة ويتجاهل التكرارات.
  Future<List<String>> record(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return load();
    final prefs = await _ensure();
    final current = prefs.getStringList(_key) ?? const <String>[];
    final next = [
      trimmed,
      ...current.where((t) => t.toLowerCase() != trimmed.toLowerCase()),
    ];
    final capped = next.take(maxItems).toList();
    await prefs.setStringList(_key, capped);
    return capped;
  }

  Future<void> clear() async {
    final prefs = await _ensure();
    await prefs.remove(_key);
  }
}