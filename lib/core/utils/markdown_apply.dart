/// تطبيق تنسيق markdown على النص المحدد — نقل أمين لمنطق
/// webapp/channels/src/utils/markdown/apply_markdown.ts
/// مع الحفاظ على سلوك المؤشر (selection).
library;

enum MarkdownMode {
  bold,
  italic,
  link,
  strike,
  code,
  heading,
  heading1,
  heading2,
  heading3,
  quote,
  ul,
  ol,
  taskList,
  horizontalRule,
  table,
}

class MarkdownResult {
  final String message;
  final int selectionStart;
  final int selectionEnd;

  const MarkdownResult({
    required this.message,
    required this.selectionStart,
    required this.selectionEnd,
  });

  factory MarkdownResult.unchanged(String message) => MarkdownResult(
    message: message,
    selectionStart: message.length,
    selectionEnd: message.length,
  );
}

class _Options {
  final int selectionStart;
  final int selectionEnd;
  final String message;
  final String? delimiter;
  final String? delimiterStart;
  final String? delimiterEnd;

  const _Options({
    required this.selectionStart,
    required this.selectionEnd,
    required this.message,
    this.delimiter,
    this.delimiterStart,
    this.delimiterEnd,
  });
}

MarkdownResult applyMarkdown({
  required MarkdownMode mode,
  required int? selectionStart,
  required int? selectionEnd,
  required String message,
}) {
  if (selectionStart == null || selectionEnd == null) {
    return MarkdownResult.unchanged(message);
  }

  switch (mode) {
    case MarkdownMode.bold:
      return _applyBoldMarkdown(_Options(
        selectionStart: selectionStart,
        selectionEnd: selectionEnd,
        message: message,
      ));
    case MarkdownMode.italic:
      return _applyItalicMarkdown(_Options(
        selectionStart: selectionStart,
        selectionEnd: selectionEnd,
        message: message,
      ));
    case MarkdownMode.link:
      return _applyLinkMarkdown(_Options(
        selectionStart: selectionStart,
        selectionEnd: selectionEnd,
        message: message,
      ));
    case MarkdownMode.ol:
      return _applyOlMarkdown(_Options(
        selectionStart: selectionStart,
        selectionEnd: selectionEnd,
        message: message,
      ));
    case MarkdownMode.ul:
      return _applyMarkdownToSelectedLines(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '- ',
        ),
      );
    case MarkdownMode.heading:
      return _applyMarkdownToSelectedLines(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '### ',
        ),
      );
    case MarkdownMode.heading1:
      return _applyHeadingVariantMarkdown(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '# ',
        ),
      );
    case MarkdownMode.heading2:
      return _applyHeadingVariantMarkdown(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '## ',
        ),
      );
    case MarkdownMode.heading3:
      return _applyHeadingVariantMarkdown(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '### ',
        ),
      );
    case MarkdownMode.taskList:
      return _applyMarkdownToSelectedLines(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '- [ ] ',
        ),
      );
    case MarkdownMode.horizontalRule:
      return _applyHorizontalRuleMarkdown(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
        ),
      );
    case MarkdownMode.table:
      return _applyTableMarkdown(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
        ),
      );
    case MarkdownMode.quote:
      return _applyMarkdownToSelectedLines(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '> ',
        ),
      );
    case MarkdownMode.strike:
      return _applyMarkdownToSelection(
        _Options(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
          message: message,
          delimiter: '~~',
        ),
      );
    case MarkdownMode.code:
      return _applyCodeMarkdown(_Options(
        selectionStart: selectionStart,
        selectionEnd: selectionEnd,
        message: message,
      ));
  }
}

String _getMultilineSuffix(String suffix) {
  if (suffix.startsWith('\n')) return '';
  final index = suffix.indexOf('\n');
  return index == -1 ? suffix : suffix.substring(0, index);
}

String _getNewSuffix(String suffix) {
  if (suffix.startsWith('\n')) return suffix;
  final index = suffix.indexOf('\n');
  return index == -1 ? '' : suffix.substring(index);
}

MarkdownResult _applyOlMarkdown(_Options o) {
  final prefix = o.message.substring(0, o.selectionStart);
  final selection = o.message.substring(o.selectionStart, o.selectionEnd);
  final suffix = o.message.substring(o.selectionEnd);

  final newPrefix = prefix.contains('\n')
      ? prefix.substring(0, prefix.lastIndexOf('\n'))
      : '';

  final multilineSuffix = _getMultilineSuffix(suffix);
  final newSuffix = _getNewSuffix(suffix);

  const delimiterLength = 3;
  var counter = 1;
  String getDelimiter() => '${counter++}. ';

  final multilinePrefix = prefix.contains('\n')
      ? prefix.substring(prefix.lastIndexOf('\n'))
      : prefix;
  var multilineSelection = '$multilinePrefix$selection$multilineSuffix';
  final isFirstLineSelected = !multilineSelection.startsWith('\n');

  if (selection.startsWith('\n')) {
    multilineSelection = '$prefix$selection$multilineSuffix';
  }

  bool getHasCurrentMarkdown() {
    final linesQuantity =
        RegExp('\n').allMatches(multilineSelection).length;
    final newLinesWithDelimitersQuantity = RegExp(
      '\n\\d\\. ',
    ).allMatches(multilineSelection).length;

    if (newLinesWithDelimitersQuantity == linesQuantity &&
        !isFirstLineSelected) {
      return true;
    }
    return linesQuantity == newLinesWithDelimitersQuantity &&
        RegExp(r'^\d\. ').hasMatch(multilineSelection);
  }

  final String newValue;
  final int newStart;
  final int newEnd;

  if (getHasCurrentMarkdown()) {
    if (isFirstLineSelected) {
      multilineSelection = multilineSelection.substring(delimiterLength);
    }
    newValue =
        '$newPrefix${multilineSelection.replaceAll(RegExp('\n\\d\\. '), '\n')}$newSuffix';
    var count = 0;
    if (isFirstLineSelected) count++;
    count += RegExp('\n').allMatches(multilineSelection).length;

    newStart = (o.selectionStart - delimiterLength).clamp(0, 1 << 31);
    newEnd = (o.selectionEnd - (delimiterLength * count)).clamp(0, 1 << 31);
  } else {
    var count = 0;
    if (isFirstLineSelected) {
      multilineSelection = '${getDelimiter()}$multilineSelection';
      count++;
    }
    final selectionArr = multilineSelection.split('');
    for (var i = 0; i < selectionArr.length; i++) {
      if (selectionArr[i] == '\n') {
        selectionArr[i] = '\n${getDelimiter()}';
      }
    }
    multilineSelection = selectionArr.join('');
    newValue = '$newPrefix$multilineSelection$newSuffix';
    count += RegExp('\n').allMatches(multilineSelection).length;

    newStart = o.selectionStart + delimiterLength;
    newEnd = o.selectionEnd + (delimiterLength * count);
  }

  return MarkdownResult(
    message: newValue,
    selectionStart: newStart,
    selectionEnd: newEnd,
  );
}

MarkdownResult _applyMarkdownToSelectedLines(_Options o) {
  final delimiter = o.delimiter;
  if (delimiter == null || delimiter.isEmpty) {
    return MarkdownResult(
      message: o.message,
      selectionStart: o.selectionStart,
      selectionEnd: o.selectionEnd,
    );
  }

  final prefix = o.message.substring(0, o.selectionStart);
  final selection = o.message.substring(o.selectionStart, o.selectionEnd);
  final suffix = o.message.substring(o.selectionEnd);

  final newPrefix = prefix.contains('\n')
      ? prefix.substring(0, prefix.lastIndexOf('\n'))
      : '';
  final multilinePrefix = prefix.contains('\n')
      ? prefix.substring(prefix.lastIndexOf('\n'))
      : prefix;

  final multilineSuffix = _getMultilineSuffix(suffix);
  final newSuffix = _getNewSuffix(suffix);
  var multilineSelection = '$multilinePrefix$selection$multilineSuffix';

  final isFirstLineSelected = !multilineSelection.startsWith('\n');

  if (selection.startsWith('\n')) {
    multilineSelection = '$prefix$selection$multilineSuffix';
  }

  bool getHasCurrentMarkdown() {
    final linesQuantity = RegExp('\n').allMatches(multilineSelection).length;
    final newLinesWithDelimitersQuantity = RegExp(
      '\n${RegExp.escape(delimiter)}',
    ).allMatches(multilineSelection).length;

    if (newLinesWithDelimitersQuantity == linesQuantity &&
        !isFirstLineSelected) {
      return true;
    }
    return linesQuantity == newLinesWithDelimitersQuantity &&
        multilineSelection.startsWith(delimiter);
  }

  String newValue;
  final int newStart;
  final int newEnd;

  if (getHasCurrentMarkdown()) {
    if (isFirstLineSelected) {
      multilineSelection = multilineSelection.substring(delimiter.length);
    }
    newValue =
        '$newPrefix${multilineSelection.replaceAll(RegExp('\n${RegExp.escape(delimiter)}'), '\n')}$newSuffix';
    var count = 0;
    if (isFirstLineSelected) count++;
    count += RegExp('\n').allMatches(multilineSelection).length;

    newStart = (o.selectionStart - delimiter.length).clamp(0, 1 << 31);
    newEnd = (o.selectionEnd - (delimiter.length * count)).clamp(0, 1 << 31);
  } else {
    newValue =
        '$newPrefix${multilineSelection.replaceAll('\n', '\n$delimiter')}$newSuffix';
    var count = 0;
    if (isFirstLineSelected) {
      newValue = '$delimiter$newValue';
      count++;
    }
    count += RegExp('\n').allMatches(multilineSelection).length;

    newStart = o.selectionStart + delimiter.length;
    newEnd = o.selectionEnd + (delimiter.length * count);
  }

  return MarkdownResult(
    message: newValue,
    selectionStart: newStart,
    selectionEnd: newEnd,
  );
}

MarkdownResult _applyMarkdownToSelection(_Options o) {
  final openingDelimiter = o.delimiterStart ?? o.delimiter;
  final closingDelimiter = o.delimiterEnd ?? o.delimiter;
  if (openingDelimiter == null || closingDelimiter == null) {
    return MarkdownResult(
      message: o.message,
      selectionStart: o.selectionStart,
      selectionEnd: o.selectionEnd,
    );
  }

  var prefix = o.message.substring(0, o.selectionStart);
  var selection = o.message.substring(o.selectionStart, o.selectionEnd);
  var suffix = o.message.substring(o.selectionEnd);

  final hasCurrentMarkdown =
      prefix.endsWith(openingDelimiter) && suffix.startsWith(closingDelimiter);

  var newStart = o.selectionStart;
  var newEnd = o.selectionEnd;

  if (selection.endsWith(' ')) {
    selection = selection.substring(0, selection.length - 1);
    suffix = ' $suffix';
    newEnd -= 1;
  }
  if (selection.startsWith(' ')) {
    selection = selection.substring(1);
    prefix = '$prefix ';
    newStart += 1;
  }

  final String newValue;
  if (hasCurrentMarkdown) {
    newValue =
        '${prefix.substring(0, prefix.length - openingDelimiter.length)}$selection${suffix.substring(closingDelimiter.length)}';
    newStart -= openingDelimiter.length;
    newEnd -= closingDelimiter.length;
  } else {
    newValue = '$prefix$openingDelimiter$selection$closingDelimiter$suffix';
    newStart += openingDelimiter.length;
    newEnd += closingDelimiter.length;
  }

  return MarkdownResult(
    message: newValue,
    selectionStart: newStart,
    selectionEnd: newEnd,
  );
}

MarkdownResult _applyBoldItalicMarkdown(
  _Options o,
  MarkdownMode markdownMode,
) {
  const boldMd = '**';
  const italicMd = '*';

  final isForceItalic = markdownMode == MarkdownMode.italic;
  final isForceBold = markdownMode == MarkdownMode.bold;

  var prefix = o.message.substring(0, o.selectionStart);
  var selection = o.message.substring(o.selectionStart, o.selectionEnd);
  var suffix = o.message.substring(o.selectionEnd);

  var newStart = o.selectionStart;
  var newEnd = o.selectionEnd;

  if (selection.endsWith(' ')) {
    selection = selection.substring(0, selection.length - 1);
    suffix = ' $suffix';
    newEnd -= 1;
  }
  if (selection.startsWith(' ')) {
    selection = selection.substring(1);
    prefix = '$prefix ';
    newStart += 1;
  }

  var isItalicFollowedByBold = false;
  var delimiter = '';
  if (isForceBold) {
    delimiter = boldMd;
  } else if (isForceItalic) {
    delimiter = italicMd;
    isItalicFollowedByBold =
        prefix.endsWith(boldMd) && suffix.startsWith(boldMd);
  }

  final hasCurrentMarkdown =
      prefix.endsWith(delimiter) && suffix.startsWith(delimiter);
  final hasItalicAndBold =
      prefix.endsWith('$boldMd$italicMd') &&
      suffix.startsWith('$boldMd$italicMd');

  final String newValue;
  if (hasItalicAndBold || (hasCurrentMarkdown && !isItalicFollowedByBold)) {
    newValue =
        '${prefix.substring(0, prefix.length - delimiter.length)}$selection${suffix.substring(delimiter.length)}';
    newStart -= delimiter.length;
    newEnd -= delimiter.length;
  } else {
    newValue = '$prefix$delimiter$selection$delimiter$suffix';
    newStart += delimiter.length;
    newEnd += delimiter.length;
  }

  return MarkdownResult(
    message: newValue,
    selectionStart: newStart,
    selectionEnd: newEnd,
  );
}

MarkdownResult _applyBoldMarkdown(_Options o) =>
    _applyBoldItalicMarkdown(o, MarkdownMode.bold);

MarkdownResult _applyItalicMarkdown(_Options o) =>
    _applyBoldItalicMarkdown(o, MarkdownMode.italic);

const String kDefaultPlaceholderUrl = 'url';

int _findWordEnd(String text, int start) {
  final index = text.indexOf(' ', start);
  return index == -1 ? text.length : index;
}

int _findWordStart(String text, int start) {
  final index = text.lastIndexOf(' ', start - 1) + 1;
  return index == -1 ? 0 : index;
}

MarkdownResult _applyLinkMarkdown(
  _Options o, {
  String url = kDefaultPlaceholderUrl,
}) {
  final prefix = o.message.substring(0, o.selectionStart);
  final selection = o.message.substring(o.selectionStart, o.selectionEnd);
  final suffix = o.message.substring(o.selectionEnd);

  const delimiterStart = '[';
  final delimiterEnd = ']($url)';

  final hasMarkdown =
      prefix.endsWith(delimiterStart) && suffix.startsWith(delimiterEnd);

  const urlShift = delimiterStart.length + 2;

  final String newValue;
  final int newStart;
  final int newEnd;

  if (hasMarkdown) {
    newValue =
        '${prefix.substring(0, prefix.length - delimiterStart.length)}$selection${suffix.substring(delimiterEnd.length)}';
    newStart = o.selectionStart - delimiterStart.length;
    newEnd = o.selectionEnd - delimiterStart.length;
  } else if (o.message.isEmpty) {
    newValue = '$delimiterStart$delimiterEnd';
    newStart = delimiterStart.length;
    newEnd = delimiterStart.length;
  } else if (o.selectionStart < o.selectionEnd) {
    newValue = '$prefix$delimiterStart$selection$delimiterEnd$suffix';
    newStart = o.selectionEnd + urlShift;
    newEnd = newStart + url.length;
  } else {
    final spaceBefore =
        prefix.isNotEmpty && prefix[prefix.length - 1] == ' ';
    final spaceAfter = suffix.isNotEmpty && suffix[0] == ' ';
    final cursorBeforeWord =
        (o.selectionStart != 0 && spaceBefore && !spaceAfter) ||
        (o.selectionStart == 0 && !spaceAfter);
    final cursorAfterWord =
        (o.selectionEnd != o.message.length && spaceAfter && !spaceBefore) ||
        (o.selectionEnd == o.message.length && !spaceBefore);

    if (cursorBeforeWord) {
      final word = o.message.substring(
        o.selectionStart,
        _findWordEnd(o.message, o.selectionStart),
      );
      newValue =
          '$prefix$delimiterStart$word$delimiterEnd${suffix.substring(word.length)}';
      newStart = o.selectionStart + word.length + urlShift;
      newEnd = newStart + urlShift;
    } else if (cursorAfterWord) {
      final cursorAtEndOfLine =
          o.selectionStart == o.selectionEnd &&
          o.selectionEnd == o.message.length;
      if (cursorAtEndOfLine) {
        newValue = '${o.message} $delimiterStart$delimiterEnd';
        newStart = o.selectionEnd + 1 + delimiterStart.length;
        newEnd = newStart;
      } else {
        final word = o.message.substring(
          _findWordStart(o.message, o.selectionStart),
          o.selectionStart,
        );
        newValue =
            '${prefix.substring(0, prefix.length - word.length)}$delimiterStart$word$delimiterEnd$suffix';
        newStart = o.selectionStart + urlShift;
        newEnd = newStart + urlShift;
      }
    } else {
      final wordStart = _findWordStart(o.message, o.selectionStart);
      final wordEnd = _findWordEnd(o.message, o.selectionStart);
      final word = o.message.substring(wordStart, wordEnd);
      newValue =
          '${prefix.substring(0, wordStart)}$delimiterStart$word$delimiterEnd${o.message.substring(wordEnd)}';
      newStart = wordEnd + urlShift;
      newEnd = newStart + urlShift;
    }
  }

  return MarkdownResult(
    message: newValue,
    selectionStart: newStart,
    selectionEnd: newEnd,
  );
}

MarkdownResult _applyCodeMarkdown(_Options o) {
  final selection = o.message.substring(o.selectionStart, o.selectionEnd);
  if (selection.contains('\n')) {
    return _applyMarkdownToSelection(
      _Options(
        selectionStart: o.selectionStart,
        selectionEnd: o.selectionEnd,
        message: o.message,
        delimiterStart: '```\n',
        delimiterEnd: '\n```',
      ),
    );
  }
  return _applyMarkdownToSelection(
    _Options(
      selectionStart: o.selectionStart,
      selectionEnd: o.selectionEnd,
      message: o.message,
      delimiter: '`',
    ),
  );
}

/// يطبّق مستوى عنوان محدد (H1/H2/H3) على الأسطر المحددة.
///
/// - نفس المستوى على كل الأسطر → إزالة (toggle off).
/// - عنوان بمستوى مختلف → استبدال المستوى القديم بالمطلوب.
/// - بلا عنوان → إضافة البادئة.
MarkdownResult _applyHeadingVariantMarkdown(_Options o) {
  final delimiter = o.delimiter ?? '### ';
  final selection = o.message.substring(o.selectionStart, o.selectionEnd);
  final lines = selection.split('\n');
  final headingPattern = RegExp(r'^#{1,6} ');

  if (lines.isNotEmpty && lines.every((l) => l.startsWith(delimiter))) {
    return _applyMarkdownToSelectedLines(o);
  }

  if (lines.any((l) => headingPattern.hasMatch(l))) {
    final stripped = lines
        .map((l) {
          final match = headingPattern.firstMatch(l);
          return match == null ? l : l.substring(match.end);
        })
        .join('\n');
    final prefix = o.message.substring(0, o.selectionStart);
    final suffix = o.message.substring(o.selectionEnd);
    return _applyMarkdownToSelectedLines(
      _Options(
        selectionStart: o.selectionStart,
        selectionEnd: o.selectionStart + stripped.length,
        message: '$prefix$stripped$suffix',
        delimiter: delimiter,
      ),
    );
  }

  return _applyMarkdownToSelectedLines(o);
}

/// خط فاصل `---` على سطر جديد في موضع المؤشر.
MarkdownResult _applyHorizontalRuleMarkdown(_Options o) {
  final message = o.message;
  final caret = o.selectionStart;
  final base = message.substring(0, caret);
  final after = message.substring(o.selectionEnd);
  final needsDoubleNewLine = base.isNotEmpty && !base.endsWith('\n\n');
  final separator = needsDoubleNewLine ? '\n\n---\n' : '\n---\n';
  final newValue = '$base$separator$after';
  final newCaret = caret + separator.length;
  return MarkdownResult(
    message: newValue,
    selectionStart: newCaret,
    selectionEnd: newCaret,
  );
}

/// إدراج هيكل جدول Markdown مع وضع المؤشر داخل أول خلية.
MarkdownResult _applyTableMarkdown(_Options o) {
  const table = '| Column 1 | Column 2 |\n| --- | --- |';
  final message = o.message;
  final caret = o.selectionStart;
  final needsNewLineBefore = caret > 0 && message[caret - 1] != '\n';
  final prefix = needsNewLineBefore ? '\n' : '';
  final newValue =
      '${message.substring(0, caret)}$prefix$table${message.substring(o.selectionEnd)}';
  final newCaret = caret + prefix.length + '| Column 1 |'.length;
  return MarkdownResult(
    message: newValue,
    selectionStart: newCaret,
    selectionEnd: newCaret,
  );
}
