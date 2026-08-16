import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/groups/data/datasources/groups_remote_data_source.dart';

const Duration _groupNamesCacheTtl = Duration(minutes: 5);

Future<Set<String>>? _cachedFuture;
DateTime? _cachedAt;

/// أسماء المجموعات القابلة للإشارة (`allow_reference`) — تُستخدم لعرض
/// منشنات المجموعات `@group-name` في الرسائل وتمييزها عن منشنات المستخدمين.
///
/// نظير `groupsByName` في webapp: يُجلب مرة واحدة ويُخزَّن مؤقتاً، ويُحدَّث
/// عند تجاوز فترة صلاحية الكاش. يفشل بهدوء بإرجاع مجموعة فارغة إن لم يدعم
/// الخادم Group Mentions أو فشلت الشبكة.
Future<Set<String>> cachedGroupMentionNames() {
  final now = DateTime.now();
  final stale =
      _cachedAt != null && now.difference(_cachedAt!) > _groupNamesCacheTtl;
  final cached = _cachedFuture;
  if (cached != null && !stale) return cached;

  final future = _loadGroupMentionNames();
  _cachedFuture = future;
  _cachedAt = now;
  return future;
}

/// يفرض إعادة جلب أسماء المجموعات (يُستدعى بعد تغيير الخادم/الفريق).
void invalidateGroupMentionNamesCache() {
  _cachedFuture = null;
  _cachedAt = null;
}

Future<Set<String>> _loadGroupMentionNames() async {
  try {
    final groups = await getIt<GroupsRemoteDataSource>().getGroups(
      perPage: 200,
      filterAllowReference: true,
    );
    return {
      for (final g in groups)
        if (g.name.isNotEmpty) g.name.toLowerCase(),
    };
  } catch (_) {
    return const {};
  }
}
