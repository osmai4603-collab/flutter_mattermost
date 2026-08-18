import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/markdown_mentions.dart';
import 'package:markdown/markdown.dart' as md;

/// يفحص عناصر `mention`/`channel` المستخرجة من شجرة الـ AST.
void _collect(
  md.Node node,
  List<md.Element> mentions,
  List<md.Element> channels,
) {
  if (node is md.Element) {
    if (node.tag == 'mention') mentions.add(node);
    if (node.tag == 'channel') channels.add(node);
    for (final child in node.children ?? const <md.Node>[]) {
      _collect(child, mentions, channels);
    }
  } else if (node is md.Text) {
    // لا شيء
  }
}

List<md.Element> _parseMentions(String text) => _parse(text).mentions;

List<md.Element> _parseChannels(String text) => _parse(text).channels;

({List<md.Element> mentions, List<md.Element> channels}) _parse(String text) {
  final doc = md.Document(extensionSet: markdownExtensionSet);
  final mentions = <md.Element>[];
  final channels = <md.Element>[];
  for (final node in doc.parseLines(text.split('\n'))) {
    _collect(node, mentions, channels);
  }
  return (mentions: mentions, channels: channels);
}

void main() {
  test('يستخرج @username كعنصر mention', () {
    final mentions = _parseMentions('مرحباً @alice كيف حالك');
    expect(mentions, hasLength(1));
    expect(mentions.single.attributes['name'], 'alice');
    expect(mentions.single.textContent, '@alice');
  });

  test('يستخرج ~channel كعنصر channel', () {
    final channels = _parseChannels('تفقدوا ~town-square اليوم');
    expect(channels, hasLength(1));
    expect(channels.single.attributes['name'], 'town-square');
    expect(channels.single.textContent, '~town-square');
  });

  test('لا يحوّل @user داخل الكود السطري أو كتلة الكود', () {
    final inlineCode = _parseMentions('استخدم `@alice` في السطر');
    expect(inlineCode, isEmpty);

    final codeBlock = _parseMentions('```dart\n@alice\n```');
    expect(codeBlock, isEmpty);
  });

  test('لا يحوّل البريد الإلكتروني إلى منشن', () {
    final mentions = _parseMentions('راسل alice@example.com اليوم');
    expect(mentions, isEmpty);
  });

  test('يدعم التنبيهات الخاصة @all @here @channel', () {
    final mentions = _parseMentions('@all و @here و @channel');
    final names = mentions.map((m) => m.attributes['name']).toSet();
    expect(names, {'all', 'here', 'channel'});
  });

  test('قوائم المهام تنتج عنصراً بنوع checkbox', () {
    final doc = md.Document(extensionSet: markdownExtensionSet);
    final nodes = doc.parseLines(['- [ ] مهمة معلقة', '- [x] مهمة منجزة']);
    var checkboxCount = 0;
    md.NodeVisitor visitor = _CountingVisitor((element) {
      if (element.attributes['type'] == 'checkbox') checkboxCount++;
    });
    for (final node in nodes) {
      node.accept(visitor);
    }
    expect(checkboxCount, 2);
  });
}

class _CountingVisitor extends md.NodeVisitor {
  final void Function(md.Element element) onElement;
  _CountingVisitor(this.onElement);

  @override
  bool visitElementBefore(md.Element element) {
    onElement(element);
    return true;
  }

  @override
  void visitText(md.Text text) {}

  @override
  void visitElementAfter(md.Element element) {}
}
