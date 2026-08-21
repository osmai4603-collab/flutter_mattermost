import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #10]: محرك القوائم الافتراضية عالية الأداء (AppVirtualizedList)
/// ============================================================================
/// المقابل لـ `dynamic_virtualized_list/dynamic_virtualized_list.tsx` في Mattermost Webapp.
/// 
/// ينفذ تقنية العرض الافتراضي (Virtualization) القائمة على `ListView.builder` أو
/// `CustomScrollView` لعرض آلاف الرسائل أو الحسابات بكفاءة ذاكرة استثنائية،
/// مع توفير زر طافٍ للقفز المباشر لأسفل القائمة عند وصول رسائل جديدة.
class AppVirtualizedList<T> extends StatefulWidget {
  /// [items]: قائمة البيانات المراد عرضها في التمرير (مطلوبة).
  /// الغرض: تمرير عناصر الرسائل أو الحسابات أو القنوات المستهدفة.
  final List<T> items;

  /// [itemBuilder]: دالة لبناء الويدجت الخاصة بكل عنصر عند الحاجة لرؤيته فقط.
  /// الغرض: توفير كفاءة الأداء وتجنب بناء العناصر الغائبة عن الشاشة.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// [controller]: المتحكم في تمرير القائمة (ScrollController).
  /// الغرض: مراقبة موقع التمرير والتحكم في القفز برمجياً.
  final ScrollController? controller;

  /// [reverse]: هل القائمة مقلوبة (تبدأ من الأسفل للأعلى كما في الدردشة)؟ (الافتراضي: false).
  /// الغرض: محاكاة تدفق المحادثة والرسائل الفورية في تطبيقات التواصل.
  final bool reverse;

  /// [showScrollToBottomButton]: هل ترغب في إظهار زر التمرير التلقائي لأسفل القائمة؟ (الافتراضي: true).
  /// الغرض: السماح للمستخدم بالقفز لآخر الرسائل بنقرة واحدة عند ابتعاده في التمرير.
  final bool showScrollToBottomButton;

  const AppVirtualizedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.controller,
    this.reverse = false,
    this.showScrollToBottomButton = true,
  });

  @override
  State<AppVirtualizedList<T>> createState() => _AppVirtualizedListState<T>();
}

class _AppVirtualizedListState<T> extends State<AppVirtualizedList<T>> {
  late ScrollController _scrollController;
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!widget.showScrollToBottomButton) return;
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset > 200 && !_showFloatingButton) {
        setState(() => _showFloatingButton = true);
      } else if (offset <= 200 && _showFloatingButton) {
        setState(() => _showFloatingButton = false);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          reverse: widget.reverse,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return widget.itemBuilder(context, widget.items[index], index);
          },
        ),
        if (_showFloatingButton && widget.showScrollToBottomButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
      ],
    );
  }
}
