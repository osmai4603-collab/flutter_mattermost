import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_item.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/markdown_mentions.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_model.dart';
import 'package:markdown/markdown.dart' as md;

void main() {
  group('GroupModel — allow_reference', () {
    test('يقرأ allow_reference من الـ JSON', () {
      final model = GroupModel.fromMap({
        'id': 'g1',
        'name': 'design',
        'display_name': 'Design Team',
        'allow_reference': true,
        'member_count': 7,
      });
      expect(model.allowReference, isTrue);
      expect(model.name, 'design');
      expect(model.memberCount, 7);
    });

    test('allow_reference افتراضياً false عند غياب الحقل', () {
      final model = GroupModel.fromMap({'id': 'g1', 'name': 'x'});
      expect(model.allowReference, isFalse);
    });
  });

  group('AutocompleteItem.group', () {
    test('ينشئ عنصر group بالنص المدرج الصحيح', () {
      final item = AutocompleteItem.group(
        id: 'g1',
        name: 'design',
        displayName: 'Design Team',
        memberCount: 7,
      );
      expect(item.kind, AutocompleteKind.group);
      expect(item.title, '@design');
      expect(item.subtitle, 'Design Team');
      expect(item.insertText, '@design ');
      expect(item.groupId, 'g1');
      expect(item.groupMemberCount, 7);
    });
  });

  group('MentionElementBuilder — منشنات المجموعات', () {
    testWidgets('يعرض @group-name كرابط ويفتح onGroupTap عند النقر', (
      tester,
    ) async {
      final element = md.Element('mention', [md.Text('@design')]);
      element.attributes['name'] = 'design';
      final tapped = <String>[];
      final builder = MentionElementBuilder(
        groupNames: Future.value({'design'}),
        onGroupTap: (name) => tapped.add(name),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  builder.visitElementAfterWithContext(
                    context,
                    element,
                    null,
                    const TextStyle(fontSize: 14),
                  ) ??
                  const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('@design'), findsOneWidget);
      await tester.tap(find.text('@design'));
      expect(tapped, ['design']);
    });

    testWidgets('لا يعامل @user العادي كمجموعة (onGroupTap لا يُستدعى)', (
      tester,
    ) async {
      final element = md.Element('mention', [md.Text('@alice')]);
      element.attributes['name'] = 'alice';
      final groupTaps = <String>[];
      final userTaps = <String>[];
      final builder = MentionElementBuilder(
        groupNames: Future.value({'design'}),
        onTap: (name) => userTaps.add(name),
        onGroupTap: (name) => groupTaps.add(name),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  builder.visitElementAfterWithContext(
                    context,
                    element,
                    null,
                    const TextStyle(fontSize: 14),
                  ) ??
                  const SizedBox(),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('@alice'));
      expect(userTaps, ['alice']);
      expect(groupTaps, isEmpty);
    });
  });
}
