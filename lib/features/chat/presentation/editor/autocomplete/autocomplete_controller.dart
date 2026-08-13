import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_item.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_service.dart';

/// متحكم الإكمال التلقائي — يراقب [TextEditingController] ويكتشف أنماط
/// الإكمال @ # / : ثم يجلب النتائج مع debounce ويعرضها.
class AutocompleteController extends ChangeNotifier {
  AutocompleteController({
    required this.textController,
    required this.service,
  }) {
    textController.addListener(_onTextChanged);
  }

  final TextEditingController textController;
  final AutocompleteService service;

  static const Duration debounceDelay = Duration(milliseconds: 300);

  AutocompleteType _type = AutocompleteType.none;
  AutocompleteType get type => _type;

  String _query = '';
  String get query => _query;

  List<AutocompleteItem> _items = const [];
  List<AutocompleteItem> get items => _items;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  TextRange _replaceRange = const TextRange(start: -1, end: -1);
  TextRange get replaceRange => _replaceRange;

  bool get isOpen => _type != AutocompleteType.none;

  Timer? _debounce;
  int _requestSeq = 0;

  // ─────────────────────────── الكشف ───────────────────────────

  /// نتيجة اكتشاف نمط الإكمال: النوع + نطاق الاستبدال + الاستعلام.
  ({AutocompleteType type, TextRange range, String query})? _detect() {
    final text = textController.text;
    final selection = textController.selection;
    final caret = selection.isValid && selection.baseOffset >= 0
        ? selection.baseOffset
        : text.length;
    if (caret > text.length) return null;

    var start = caret;
    while (start > 0) {
      final prev = text[start - 1];
      if (prev == ' ' || prev == '\t' || prev == '\n' || prev == '\u00a0') {
        break;
      }
      start--;
    }
    if (start == caret) return null;

    final token = text.substring(start, caret);
    final atLineStart = start == 0 || text[start - 1] == '\n';

    AutocompleteType? type;
    if (token.startsWith('/') && atLineStart && token.length <= 40) {
      type = AutocompleteType.command;
    } else if (token.startsWith('@') && token.length <= 60) {
      type = AutocompleteType.mention;
    } else if ((token.startsWith('#') || token.startsWith('~')) &&
        token.length <= 60) {
      type = AutocompleteType.channel;
    } else if (token.startsWith(':') &&
        !token.startsWith('::') &&
        token.length > 1 &&
        token.indexOf(':', 1) == -1 &&
        token.length <= 40) {
      type = AutocompleteType.emoji;
    }
    if (type == null) return null;

    return (
      type: type,
      range: TextRange(start: start, end: caret),
      query: token.substring(1).toLowerCase(),
    );
  }

  void _onTextChanged() {
    _debounce?.cancel();
    final detection = _detect();
    if (detection == null) {
      _close();
      return;
    }
    final typeChanged = detection.type != _type;
    final queryChanged = detection.query != _query;
    _type = detection.type;
    _replaceRange = detection.range;
    if (queryChanged) {
      _query = detection.query;
      _selectedIndex = 0;
      // أبقِ النتائج القديمة معروضة مؤقتاً حتى تصل النتائج الجديدة.
    }
    if (typeChanged || queryChanged) {
      _requestSeq++;
      notifyListeners();
      _debounce = Timer(debounceDelay, () => _fetch());
    } else {
      notifyListeners();
    }
  }

  Future<void> _fetch() async {
    final seq = ++_requestSeq;
    final type = _type;
    final query = _query;
    List<AutocompleteItem> results;
    try {
      results = switch (type) {
        AutocompleteType.mention => await service.searchMentions(query),
        AutocompleteType.channel => await service.searchChannels(query),
        AutocompleteType.command => await service.searchCommands(query),
        AutocompleteType.emoji => await service.searchEmojis(query),
        AutocompleteType.none => const [],
      };
    } catch (_) {
      results = const [];
    }
    if (seq != _requestSeq || _type != type) return;
    _items = results;
    if (_selectedIndex >= _items.length) _selectedIndex = 0;
    notifyListeners();
  }

  // ─────────────────────────── التنقل والاختيار ───────────────────────────

  void selectNext() {
    if (_items.isEmpty) return;
    _selectedIndex = (_selectedIndex + 1) % _items.length;
    notifyListeners();
  }

  void selectPrevious() {
    if (_items.isEmpty) return;
    _selectedIndex = (_selectedIndex - 1 + _items.length) % _items.length;
    notifyListeners();
  }

  /// يُدرج العنصر المحدد بدل نطاق الإكمال ثم يُغلق القائمة.
  void insertCurrent() {
    if (!isOpen || _items.isEmpty) return;
    final item = _items[_selectedIndex < _items.length ? _selectedIndex : 0];
    final text = textController.text;
    final start = _replaceRange.start.clamp(0, text.length);
    final end = _replaceRange.end.clamp(start, text.length);
    textController.value = TextEditingValue(
      text: text.replaceRange(start, end, item.insertText),
      selection: TextSelection.collapsed(offset: start + item.insertText.length),
    );
    _close();
  }

  /// إدراج نص مُمرَّر من الخارج (يعيد فتح الكشف تلقائياً عبر المستمع).
  void insertText(String text, {required TextRange replaceRange}) {
    final current = textController.text;
    final value = TextEditingValue(
      text: current.replaceRange(replaceRange.start, replaceRange.end, text),
      selection: TextSelection.collapsed(offset: replaceRange.start + text.length),
    );
    textController.value = value;
    _close();
  }

  void close() {
    if (!isOpen) return;
    _close();
  }

  void _close() {
    _debounce?.cancel();
    _requestSeq++;
    final wasOpen = isOpen || _items.isNotEmpty;
    _type = AutocompleteType.none;
    _query = '';
    _items = const [];
    _selectedIndex = 0;
    _replaceRange = const TextRange(start: -1, end: -1);
    if (wasOpen) notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    textController.removeListener(_onTextChanged);
    super.dispose();
  }
}