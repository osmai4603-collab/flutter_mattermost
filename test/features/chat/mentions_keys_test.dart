import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/rhs/mentions_panel.dart';
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
}
