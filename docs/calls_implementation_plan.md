# الخطة التنفيذية الشاملة لتطوير ونشر نظام المكالمات (Mattermost Calls)

تُعد هذه الخطة الدليل التنفيذي والتصميمي لدعم وتطوير نظام المكالمات الصوتية والمرئية عبر بروتوكول IP داخل تطبيق **Flutter (`flutter_mattermost`)** للعمل على **شبكة محلية (LAN)** دون الحاجة إلى خدمات سحابية خارجية أو ربط أرقام هواتف تقليدية.

---

## إجابات وتفضيلات المستخدم (User Answers & Target Scope)

- **طبيعة الشبكة**: تعمل المنظومة بالكامل داخل **شبكة محلية (Local Network / LAN)** بدون اتصال بالإنترنت الخارجي.
- **نمط خادم وسائط المكالمات**: الاعتماد على النمط المدمج (**Integrated Mode**) المباشر عبر إضافة Calls على خادم Mattermost الرئيسي، وتحديد العنوان المحلي عبر `ICE Host Override` دون الحاجة لخوادم STUN/TURN خارجية.
- **نطاق المكالمات**: الاكتفاء بالمكالمات الصوتية والمرئية ومشاركة الشاشة **عبر بروتوكول IP فقط** داخل تطبيق Mattermost (إلغاء الحاجة لربط شبكة الهاتف التقليدية PSTN/SIP Trunking).

---

## المراجع والمصادر المعتمدة من مشروع Mattermost (Mattermost Reference Artifacts)

لضمان التطابق المعماري والتصميمي والتنفيذي 100% مع نظام Mattermost الرسمي، تم ربط كل مرحلة في هذه الخطة بالمصادر التالية من مشروع `/home/osmsoftwareengineering/mattermost`:

1. **وثائق إعداد ونشر إضافة المكالمات**:
   - [calls-deployment-guide.mdx](file:///home/osmsoftwareengineering/mattermost/docs/main/deployment-guide/calls/calls-deployment-guide.mdx) (دليل النشر والشبكات).
   - [make-calls.mdx](file:///home/osmsoftwareengineering/mattermost/docs/main/end-user-guide/collaborate/make-calls.mdx) (دليل المستخدم وواجهات وتفاعلات المكالمات).
   - [plugins-configuration-settings.mdx](file:///home/osmsoftwareengineering/mattermost/docs/main/administration-guide/configure/plugins-configuration-settings.mdx#L224-L983) (معلمات وقيم `com.mattermost.calls` في `config.json`).

2. **بروتوكولات الإشارات (WebSocket & Signaling Spec)**:
   - أحداث الإشارة من خادم Mattermost: `custom_com.mattermost.calls_call_started` و `user_joined` و `user_left` و `user_muted` و `signal` (SDP Offer/Answer & ICE Candidates).

3. **معايير التصوير الجرافيكي والواجهات (Internal Views & UI Specs)**:
   - [calls-widget.png](file:///home/osmsoftwareengineering/mattermost/docs/develop/contribute/more-info/desktop/architecture/internal-views/calls-widget.png) (تصميم الـ Call Widget والنافذة العائمة والـ Header Controls).

---

## الخطة التنفيذية المفصلة (Main & Sub-Phases)

---

### المرحلة الرئيسية 1: تهيئة الخادم والشبكة المحلية (Server & Local Network Infrastructure Phase)

تستهدف هذه المرحلة تهيئة ملحق المكالمات المدمج على خادم Mattermost الرئيسي ليخدم أجهزة تطبيق الفلاتر عبر الشبكة المحلية (LAN).

- **المصادر المرجعية للمرحلة**:
  - [calls-deployment-guide.mdx (Integrated Mode)](file:///home/osmsoftwareengineering/mattermost/docs/main/deployment-guide/calls/calls-deployment-guide.mdx#L147-L186)
  - [plugins-configuration-settings.mdx#Calls](file:///home/osmsoftwareengineering/mattermost/docs/main/administration-guide/configure/plugins-configuration-settings.mdx#L224-L270)

#### المرحلة الفرعية 1.1: ضبط وتفعيل ملحق `com.mattermost.calls` في `config.json`
- **الهدف**: تفعيل خدمة المكالمات المدمجة على خادم Mattermost.
- **الخطوات التفصيلية**:
  1. تفعيل الملحق: ضبط `PluginSettings.PluginStates.com.mattermost.calls.Enable = true`.
  2. تحديد عنوان الاستماع عبر الشبكة المحلية:
     - `PluginSettings.Plugins.com.mattermost.calls.udpserveraddress = 0.0.0.0`
     - `PluginSettings.Plugins.com.mattermost.calls.tcpserveraddress = 0.0.0.0`
     - `PluginSettings.Plugins.com.mattermost.calls.udpserverport = 8443`
     - `PluginSettings.Plugins.com.mattermost.calls.tcpserverport = 8443`

#### المرحلة الفرعية 1.2: تهيئة `ICE Host Override` للشبكة المحلية (LAN NAT Bypass)
- **الهدف**: منع استخدام خوادم STUN خارجية وتحديد IP الخادم المحلي المباشر الذي سيتصل به العملاء لنقل الصوت والفيديو.
- **الخطوات التفصيلية**:
  1. تعيين IP الخادم المحلي في إعداد `icehostoverride`:
     `PluginSettings.Plugins.com.mattermost.calls.icehostoverride = "<MATTERMOST_LOCAL_IP>"` (مثال: `192.168.1.100`).
  2. إلغاء أي خوادم STUN خارجية مجهزة افتراضياً.

#### المرحلة الفرعية 1.3: إعداد وتأكيد فتح المنافذ الشبكية (Local Firewall & Port Verification)
- **الهدف**: التأكد من وصول ترافيك وسائط اتصالات الفلاتر للخادم دون اعتراض.
- **الخطوات التفصيلية**:
  1. تأكيد فتح البورت `443 TCP` لـ HTTPS وإشارات WebSocket.
  2. تأكيد فتح البورت `8443 UDP` لنقل وسائط WebRTC الصوتية والمرئية الأساسية.
  3. تأكيد فتح البورت `8443 TCP` كخيار احتياطي لنقل الوسائط في حال وجود قيود على UDP على بعض الأجهزة.
  4. تنفيذ أمر الفحص الشبكي من جهاز عميل: `nmap -sU -p 8443 <MATTERMOST_LOCAL_IP>`.

---

### المرحلة الرئيسية 2: تطوير وتوسيع محرك الشبكة والإشارات في الفلاتر (Flutter Signaling & Network Engine Layer)

تستهدف هذه المرحلة تحديث كود التطبيق في [calls_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/calls_manager.dart) وتوفير الاتصال المباشر عبر WebRTC.

- **المصادر المرجعية للمرحلة**:
  - [make-calls.mdx#Is-there-encryption](file:///home/osmsoftwareengineering/mattermost/docs/main/end-user-guide/collaborate/make-calls.mdx#L266-L268)

#### المرحلة الفرعية 2.1: الجلب الديناميكي لتكوينات ICE من API الخادم
- **الهدف**: استرجاع عنوان الخادم المحلي وقيم المنافذ ديناميكياً من Mattermost.
- **الخطوات التفصيلية**:
  1. إنشاء المستودع [calls_rest_repository.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/domain/repositories/calls_rest_repository.dart) لعمل طلب `GET /plugins/com.mattermost.calls/config`.
  2. بناء كائن `RTCConfiguration` يضم العنوان المحلي المحصل من `iceHostOverride`.

#### المرحلة الفرعية 2.2: إعادة هيكلة `CallsManager` لتعدد المشاركين (Multi-Stream SFU Map)
- **الهدف**: استبدال العارض المنفرد بدعم مشغل صوت/فيديو محلي وخريطة للمشاركين الآخرين.
- **الخطوات التفصيلية**:
  1. التعديل في [calls_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/calls_manager.dart):
     - تغيير `_remoteRenderer` إلى `Map<String, RTCVideoRenderer> _remoteRenderers`.
  2. معالجة إضافة وإزالة المسارات الصوتيّة والمرئية (`onTrack` / `onRemoveTrack`) لربط كل مشارك بـ Renderer خاص به.
  3. دعم التبديل الديناميكي بين دفق الكاميرا ودفق مشاركة الشاشة.

#### المرحلة الفرعية 2.3: استقبال وإرسال كافة إشارات المكالمة عبر WebSocket
- **الهدف**: التزامن الحظي المكتمل مع الخادم وأحداث القنوات.
- **الخطوات التفصيلية**:
  1. معالجة الأحداث التالية في [websocket_client.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/network/websocket_client.dart):
     - `custom_com.mattermost.calls_call_started`
     - `custom_com.mattermost.calls_user_joined`
     - `custom_com.mattermost.calls_user_left`
     - `custom_com.mattermost.calls_user_muted` / `unmuted`
     - `custom_com.mattermost.calls_user_raise_hand` / `unraise_hand`
     - `custom_com.mattermost.calls_call_ended`
  2. إرسال إشارات `join_call`, `leave_call`, `mute`, `unmute`, `raise_hand`, `unraise_hand`, و `webrtc_answer/offer`.

#### المرحلة الفرعية 2.4: معالجة الانقطاع والاتصال المحلي التلقائي (Local ICE Restart)
- **الهدف**: استعادة الاتصال فورياً عند تغير عنوان الجوال المحلي (مثل التبديل بين أجهزة التغطية في LAN).
- **الخطوات التفصيلية**:
  1. الاستماع لـ `onIceConnectionState`.
  2. عند حدوث انقطاع: تنشيط `restartIce()` وإعادة تبادل الـ SDP دون قطع المكالمة.

---

### المرحلة الرئيسية 3: إدارة الصوت والإشعارات الأصلية (Audio Session & Native CallKit Layer)

تضمن هذه المرحلة الحصول على تجربة اتصال هاتفية حقيقية تتكامل مع نظام تشغيل الجوال على الشبكة المحلية.

- **المصادر المرجعية للمرحلة**:
  - [make-calls.mdx#Mobile](file:///home/osmsoftwareengineering/mattermost/docs/main/end-user-guide/collaborate/make-calls.mdx#L55-L66) (إدارة الصوت على الجوال بين الميكروفون وسماعة البلوتوث والسماعة الخارجية).

#### المرحلة الفرعية 3.1: تهيئة إدارة جلسات الصوت (Audio Session Management)
- **الهدف**: التحكم الصريح بمخارج ومدخلات الصوت والجودة في الجوال.
- **الخطوات التفصيلية**:
  1. إنشاء الكائن [audio_session_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/audio_session_manager.dart).
  2. تفعيل `AudioSessionCategory.playAndRecord` و `AudioSessionMode.voiceChat`.
  3. إضافة خيارات التبديل بين: السماعة الخارجية (Speaker Phone)، السماعة الداخلية (Earpiece)، وسماعة البلوتوث (Bluetooth Headset).

#### المرحلة الفرعية 3.2: دمج `flutter_callkit_incoming` (Native Local Ringing)
- **الهدف**: إظهار شاشة الاتصال الأصلية للجوال عند رنين المكالمة المباشرة DM في الشبكة المحلية.
- **الخطوات التفصيلية**:
  1. إضافة وتكوين حزمة `flutter_callkit_incoming`.
  2. إيقاذ الرنين بمجرد استقبال `custom_com.mattermost.calls_call_started` وتحديد اسم المتصل.
  3. ربط أزرار الرد والرفض الأصلية بـ `CallsBloc` لتشغيل رفع السماعة تلقائياً.

---

### المرحلة الرئيسية 4: تطوير واجهات وتجربة المستخدم (UI & UX Experience Layer)

تصميم واجهات عصرية احترافية مستوحاة من الدليل الرسمي لـ Mattermost Desktop و Mobile.

- **المصادر المرجعية للمرحلة**:
  - [make-calls.mdx#Host-controls](file:///home/osmsoftwareengineering/mattermost/docs/main/end-user-guide/collaborate/make-calls.mdx#L69-L100) (Host Controls: Mute, Ask to unmute, Remove, End for all).
  - [make-calls.mdx#React-using-emojis](file:///home/osmsoftwareengineering/mattermost/docs/main/end-user-guide/collaborate/make-calls.mdx#L137-L154) (تفاعلات الإيموجي في المكالمة).
  - [calls-widget.png](file:///home/osmsoftwareengineering/mattermost/docs/develop/contribute/more-info/desktop/architecture/internal-views/calls-widget.png) (شكل الودجت الرئيسي للمكالمة).

#### المرحلة الفرعية 4.1: شريط المكالمة النشطة العلوي (`ActiveCallGlobalBanner`)
- **الهدف**: إظهار شريط علوي يوضح وجود مكالمة جارية عبر الشبكة أثناء تصفح القنوات.
- **الخطوات التفصيلية**:
  1. إنشاء الكائن [active_call_global_banner.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/active_call_global_banner.dart).
  2. عرضه أعلى صفحات المحادثات مع إظهار: اسم القناة، العداد الزمني، وزر الانضمام/العودة.

#### المرحلة الفرعية 4.2: النافذة العائمة الصغرى (`FloatingCallOverlayWidget`)
- **الهدف**: نافذة عائمة مصغرة (Picture-in-Picture) فوق التطبيق.
- **الخطوات التفصيلية**:
  1. إنشاء ودجت عائم قابل للسحب باللمس.
  2. عرض مشاركة الشاشة أو فيديو المتحدث الحالي مع أزرار التحكم السريعة.

#### المرحلة الفرعية 4.3: شاشة المكالمة الكاملة وتنسيق الشبكة (`FullCallScreen` & Participant Grid)
- **الهدف**: الواجهة الرئيسية للمكالمة الجماعية والمباشرة.
- **الخطوات التفصيلية**:
  1. بناء الشاشة [full_call_screen.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/pages/full_call_screen.dart).
  2. بناء شبكة المشاركين (Grid view) وتحديد الإطار المضيء حول المتحدث الفعال (Active Speaker Border).
  3. شريط أدوات سفلي زجاجي (Glassmorphism) يضم: (Mute/Unmute, Camera On/Off, Screen Share, Audio Device Selector, Reactions, Host Menu, Leave).

#### المرحلة الفرعية 4.4: لوحة أدوات المشرف (`HostControlsBottomSheet`)
- **الهدف**: منح منشئ المكالمة والآدمن صلاحيات إدارة الجلسة وفقاً لمواصفات Mattermost الرسمية.
- **الخطوات التفصيلية**:
  1. بناء النافذة [host_controls_bottom_sheet.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/host_controls_bottom_sheet.dart).
  2. تضمين الأوامر: كتم مشارك / كتم الجميع (Mute All)، طلب التحدث (Ask to Unmute)، خفض الأيادي (Lower Hand)، طرد مشارك (Remove from Call)، وإنهاء المكالمة للجميع (End Call for Everyone).

#### المرحلة الفرعية 4.5: تفاعلات الإيموجي والثريد المرفق (In-Call Reactions & Thread)
- **الهدف**: التفاعل السريع بالإيموجي والدردشة أثناء الاتصال.
- **الخطوات التفصيلية**:
  1. تفعيل زر Reactions مع إطلاق أنيميشن الإيموجي على صور المشاركين.
  2. إضافة زر فتح ثريد محادثة القناة مباشرة داخل المكالمة.

---

### المرحلة الرئيسية 5: الاختبار، التحقق والتكامل التشغيلي (Testing & Verification Phase)

تتضمن هذه المرحلة فحص المكالمات والاتصال المباشر على الشبكة المحلية وتأكيد الجودة.

#### المرحلة الفرعية 5.1: اختبار الاتصال عبر الشبكة المحلية (LAN Connectivity Test)
- **الخطوات التفصيلية**:
  1. إجراء مكالمة صوتية ومرئية بين جهازين محمولين متصلين بنفس الـ Wi-Fi المحلي.
  2. تأكيد انتقال الصوت والفيديو بوقت تأخير منخفض جداً (Low Latency) وسلس عبر المنافذ `8443 UDP/TCP`.

#### المرحلة الفرعية 5.2: اختبار استجابة الواجهات والإشارات
- **الخطوات التفصيلية**:
  1. تجربة كتم وسحب الصلاحيات والتأكد من انخفاض الأيادي وتغير الإشارات فورياً لدى جميع الأطراف.

---

## خطة التغييرات الصريحة على الملفات (Proposed Changes in Codebase)

### [Component: Core Calls Engine]

#### [MODIFY] [calls_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/calls_manager.dart)
- التعديل لدعم `Map<String, RTCVideoRenderer>` واستقبال تكوينات `ICE Host Override` المحلية.

#### [NEW] [calls_rest_repository.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/domain/repositories/calls_rest_repository.dart)
- إنشاء مستودع REST API لجلب تكوينات الخادم المحلي وتأكيد عمليات الجلسة.

---

### [Component: Audio & CallKit Layer]

#### [NEW] [audio_session_manager.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/audio_session_manager.dart)
- مدير تهيئة أجهزة الصوت وتفعيل السماعة الخارجية للبلوتوث.

#### [NEW] [callkit_service.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/core/calls/callkit_service.dart)
- خدمة الربط مع `flutter_callkit_incoming` لشاشات الاتصال الأصلية على الجوال.

---

### [Component: Presentation & BLoC Layer]

#### [MODIFY] [calls_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/bloc/calls_bloc.dart)
- استيعاب أحداث المشرف والإشعارات ورسوم الإيموجي وتعدد حالات التوصيل.

#### [NEW] [full_call_screen.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/pages/full_call_screen.dart)
- الشاشة الكاملة للمكالمات الجماعية وواجهة المشاركين.

#### [NEW] [active_call_global_banner.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/active_call_global_banner.dart)
- الشريط العلوي العام في أرجاء التطبيق.

#### [NEW] [host_controls_bottom_sheet.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/host_controls_bottom_sheet.dart)
- قائمة التحكم والإدارة المخصصة للمشرفين والآدمن.

---

## Verification Plan

### Automated Tests
- تشغيل اختبارات `CallsBloc` والربط مع `CallsManager`:
  ```bash
  flutter test test/features/chat/presentation/bloc/calls_bloc_test.dart
  ```
- التأكد من سلامة بناء المشروع وتوليد الأكواد:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

### Manual Verification
- الاتصال المحلي: اختبار إجراء مكالمة بين هاتفين على الشبكة المحلية وتأكيد وضوح الصوت والفيديو.
- رنين الجوال: اختبار استقبال إشعار رنين الشاشة الأصلية واستجابة رفع السماعة.
- أجهزة الصوت: تجربة تحويل مخرج الصوت إلى سماعة البلوتوث والسماعة الخارجية خلال المكالمة.
