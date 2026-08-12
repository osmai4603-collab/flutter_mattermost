import 'package:flutter/foundation.dart';

/// إشعار عام "مرّر إلى الأسفل" — نظير EventEmitter + scrollPostListToBottom
/// في webapp (actions/views/channel.ts). قائمة الرسائل تستمع لهذا الإشعار
/// وتنفذ التمرير للأسفل عند إرسال رسالة أو عند ضغط زر "الانتقال للأحدث".
class ScrollToBottomNotifier extends ChangeNotifier {
  int _version = 0;

  int get version => _version;

  void scrollToBottom() {
    _version++;
    notifyListeners();
  }
}
