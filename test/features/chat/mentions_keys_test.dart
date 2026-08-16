import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/mentions_panel.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_test/flutter_test.dart';

/// اختبارات منطق مفاتيح الإشارة — مطابقة getCurrentUserMentionKeys
/// و showMentions في webapp.
void main() {
  UserEntity userWith(Map<String, dynamic> notifyProps) => UserEntity(
    id: 'u1',
    username: 'john_doe',
    firstName: 'John',
    lastName: 'Doe',
    notifyProps: notifyProps,
  );

  group('mentionKeysFrom', () {
    test('يضيف @username دائماً', () {
      final keys = mentionKeysFrom(
        userWith(const {}),
      );
      expect(keys, contains('@john_doe'));
    });

    test('يشمل المفاتيح المخصصة من mention_keys', () {
      final keys = mentionKeysFrom(
        userWith(const {'mention_keys': 'team-lead,alert' }),
      );
      expect(keys, contains('team-lead'));
      expect(keys, contains('alert'));
    });

    test('يستبعد التنبيهات العامة @channel/@all/@here', () {
      final keys = mentionKeysFrom(
        userWith({
          'mention_keys': '@channel,@all,@here,dev',
          'channel': 'true',
        }),
      );
      expect(keys, isNot(contains('@channel')));
      expect(keys, isNot(contains('@all')));
      expect(keys, isNot(contains('@here')));
      expect(keys, contains('dev'));
      expect(keys, contains('@john_doe'));
    });

    test('يشمل الاسم الأول فقط عندما يكون first_name مفعّلاً', () {
      final disabled = mentionKeysFrom(
        userWith(const {'first_name': 'false'}),
      );
      expect(disabled, isNot(contains('John')));

      final enabled = mentionKeysFrom(
        userWith(const {'first_name': 'true'}),
      );
      expect(enabled, contains('John'));
    });
  });

  group('mentionKeysQuery', () {
    test('يجمع المفاتيح بمسافات مع مسافة نهائية مثل showMentions', () {
      final query = mentionKeysQuery(
        const ['@john_doe', 'John'],
      );
      expect(query, '@john_doe John ');
    });
  });

  group('allMentionKeysFrom', () {
    test('يبقي التنبيهات العامة عند تفعيل notify_props.channel', () {
      final keys = allMentionKeysFrom(
        userWith({'channel': 'true', 'mention_keys': 'dev'}),
      );
      expect(keys, contains('@channel'));
      expect(keys, contains('@all'));
      expect(keys, contains('@here'));
      expect(keys, contains('dev'));
    });

    test('لا يضيف التنبيهات العامة عند إيقاف notify_props.channel', () {
      final keys = allMentionKeysFrom(userWith(const {}));
      expect(keys, isNot(contains('@channel')));
      expect(keys, contains('@john_doe'));
    });
  });

  group('textMentionsKeys', () {
    const keys = ['@john_doe', 'John', 'team-lead'];

    test('يطابق @username في النص', () {
      expect(textMentionsKeys('مرحباً @john_doe', keys), isTrue);
    });

    test('يطابق المفتاح المخصص دون @', () {
      expect(textMentionsKeys('راجع team-lead اليوم', keys), isTrue);
    });

    test('يطابق الاسم الأول', () {
      expect(textMentionsKeys('مرحباً John', keys), isTrue);
    });

    test('حساسية الحالة غير مفعّلة', () {
      expect(textMentionsKeys('مرحباً @JOHN_DOE', keys), isTrue);
    });

    test('يتجاهل المنشن داخل كتلة الكود', () {
      expect(textMentionsKeys('```\n@john_doe\n```', keys), isFalse);
    });

    test('لا يطابق عند غياب المفاتيح أو النص الفارغ', () {
      expect(textMentionsKeys('', keys), isFalse);
      expect(textMentionsKeys('نص عادي', const []), isFalse);
    });
  });
}
