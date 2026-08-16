/// نماذج عناصر الإكمال التلقائي في المحرر.
library;

import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

/// نوع الإكمال التلقائي النشط حالياً.
enum AutocompleteType { none, mention, channel, command, emoji }

/// نوع العنصر المعروض في قائمة النتائج.
enum AutocompleteKind { mention, channel, command, emoji, group }

/// عنصر عرض في قائمة الإكمال التلقائي.
///
/// يحمل كل ما يحتاجه الويدجت للعرض (صورة/أيقونة/إيموجي) والنص الذي
/// يُدرج عند الاختيار (`insertText`).
class AutocompleteItem {
  final AutocompleteKind kind;

  /// النص الأساسي المعروض (اسم المستخدم/القناة/الأمر/الإيموجي).
  final String title;

  /// النص الثانوي (username/وصف الأمر/أسماء بديلة).
  final String? subtitle;

  /// النص الكامل الذي يُدرج بدل كلمة الإكمال (بدون مسافة تالية).
  final String insertText;

  /// معرف المستخدم (لصورة الملف الشخصي).
  final String? userId;

  /// حالة تواجد المستخدم (online/away/dnd/offline).
  final UserStatus? status;

  /// أدوار المستخدم (شارة Admin).
  final String? roles;

  /// نوع القناة ('O' عامة، 'P' خاصة، 'D' مباشرة، 'G' مجموعة).
  final String? channelType;

  /// رمز إيموجي يونيكود.
  final String? emojiUnicode;

  /// اسم إيموجي مخصص (مثل `:party:`).
  final String? emojiName;

  /// تنبيه خاص (@all/@channel/@here).
  final bool special;

  /// هل المستخدم خارج القناة الحالية؟ (يُعرَض مع إشارة في القائمة).
  final bool outOfChannel;

  /// معرف المجموعة (منشن المجموعة — [AutocompleteKind.group]).
  final String? groupId;

  /// عدد أعضاء المجموعة (شارة صغيرة في القائمة).
  final int groupMemberCount;

  const AutocompleteItem({
    required this.kind,
    required this.title,
    required this.insertText,
    this.subtitle,
    this.userId,
    this.status,
    this.roles,
    this.channelType,
    this.emojiUnicode,
    this.emojiName,
    this.special = false,
    this.outOfChannel = false,
    this.groupId,
    this.groupMemberCount = 0,
  });

  factory AutocompleteItem.specialMention(String name, String subtitle) =>
      AutocompleteItem(
        kind: AutocompleteKind.mention,
        title: '@$name',
        subtitle: subtitle,
        insertText: '@$name ',
        special: true,
      );

  factory AutocompleteItem.group({
    required String id,
    required String name,
    required String displayName,
    required int memberCount,
  }) =>
      AutocompleteItem(
        kind: AutocompleteKind.group,
        title: '@$name',
        subtitle: displayName.isNotEmpty ? displayName : null,
        insertText: '@$name ',
        groupId: id,
        groupMemberCount: memberCount,
      );
}