# الخطة التنفيذية الشاملة لتطوير ونشر نظام المكالمات (Mattermost Calls)

تُعد هذه الخطة الدليل التنفيذي والتصميمي لدعم وتطوير نظام المكالمات الصوتية والمرئية عبر بروتوكول IP داخل تطبيق **Flutter (`flutter_mattermost`)** للعمل على **شبكة محلية (LAN)** دون الحاجة إلى خدمات سحابية خارجية أو ربط أرقام هواتف تقليدية.

> [!IMPORTANT]
> **تصحيح ميداني (المرحلة 0 — 2026-08)**: بعض أسماء الإشارات والأحداث في هذه الخطة
> (`call_started`, `join_call`, `leave_call`, `webrtc_offer/answer`, `ice_candidate`)
> **غير دقيقة**. المواصفات المعتمدة (أحداث، إشارات، حمولات، REST، واتصال
> `?calls=true` المخصص) موثقة في
> [mattermost_realtime_analysis.md](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/docs/mattermost_realtime_analysis.md)
> — القسمان 3.3 و 3.4 و 8. استند إليها عند التنفيذ.
>
> **المخطط المرجعي الحالي**: قسم **«المخطط المرجعي المحدّث بالمراحل 0–8»**
> في نهاية هذا المستند هو المرجع المعتمد لحالة التنفيذ وخطوات المتابعة.

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

---

## سجل التقدم (Progress Log)

### المرحلة 2 — محرك الإشارات والشبكة (نُفِّذت، 2026-08)
- **عميل اتصال المكالمات** `calls_websocket_client.dart` (المرحلة 1): اتصال `?calls=true`
  بـ auth + hello + join/leave + sdp (msgpack bin + zlib) + ice + mute/unmute/voice/screen/
  raise_hand/react/call_state، فلتر connID (connID = connID المتلقي — مُتحقق من
  `server/websocket.go` v1.12.2-6)، ping/pong 30s، إعادة اتصال backoff مع
  `reconnect{channelID, originalConnID, prevConnID}` و`connection_id`/`sequence_number`.
- **Hub events**: `CallStateEvent{callEventName,data,seq}` لجميع `custom_com.mattermost.calls_*`
  (مفاتيح غير متناسقة بين الأحداث: `user_id` vs `userID`)، و`CallStartedEvent` يُقرأ الآن
  `id`/`channelID`/`thread_id`/`host_id`/`owner_id`/`post_id`/`start_at` (مُتحقق من الخادم).
- **CallsManager**: أُعيد بناؤه — `startCall(channelId,{video,selfInitiated})` +
  `joinExistingCall`، SDP offer بعد إقرار `calls_join`، ICE config من REST
  (`ICEServersConfigs`/`ICEServers` + TURN عند `NeedsTURNCredentials`)، ICE restart
  عند الانقطاع، تحديث المشاركين من أحداث الـ Hub، و`closeForLeave()` يصفّر الجلسة
  (connID/seq) ليكون الانضمام التالي جلسة أولى نظيفة.
- **REST**: `CallsRestRepository` بالمسارات الفعلية (انظر §3.3 في
  `mattermost_realtime_analysis.md`).
- **التحقق**: `flutter analyze` نظيف على الملفات المعدّلة + 51 اختباراً تجتاز الكل.

---

## المخطط المرجعي المحدّث بالمراحل 0–8 (2026-08) — حالة التنفيذ

> [!IMPORTANT]
> هذا المخطط **هو المرجع المعتمد حالياً** ويرقّم المراحل 0–8 بترتيب مختلف عن
> القسم أعلاه. رموز الحالة: ✅ منجزة | ⚠️ جزئية/بتصميم مختلف | ❌ غير منجزة.

### المرحلة 0 — توثيق البروتوكول والتحقق على الخادم (قبل أي كود)
- [x] **0.3** تحديث `docs/mattermost_realtime_analysis.md` بأسماء الإشارات
      والحِمل الفعلي واتصال `calls=true` (§3.3 / §3.4 / §8) — منجز.
- [x] **0.1** فحص إصدار الإضافة من قشرة الخادم (`GET /api/v4/plugins` أو
      `config.json`) وتأكيد `icehostoverride` والمنفذ `8443 UDP/TCP` — **منجز
      على الخادم المحلي** (2026-08): Calls **v1.11.5** مثبّتة ومفعّلة من
      السوق، و`GET /plugins/com.mattermost.calls/config` يعيد
      `UDPServerPort/TCPServerPort: 8443`, `EnableRinging: true`,
      `AllowEnableCalls: true`, `DefaultEnabled: true`, `MaxCallParticipants: 8`,
      `NeedsTURNCredentials: false`, `AllowScreenSharing: true`
      (`sku_short_name: "starter"` — خادم بلا ترخيص ⇒ مكالمات DM/GM فقط).
- [x] **0.2** التقاط أحداث WS حقيقية (فتح مكالمة من متصفح + أدوات المطوّر)
      وتحديث الأسماء الفعلية `channel_id/user_id/session_id` — **منجز**:
      عميل WS محلي (python) على الـ Hub الرئيسي بجلسة مصادقة التقط
      `custom_com.mattermost.calls_call_start`/`user_joined`/`user_left`/
      `call_host_changed`/`call_state`/`user_unmuted` بحمولة فعلية
      `{id, channelID, host_id, owner_id, post_id, start_at, thread_id}`
      (الاسم الفعلي للمعرّف `id` وليس `call_id`، والقناة `channelID` camelCase)،
      وأكّد أن أحداث الحالة تُبثّ على الـ Hub الرئيسي (وليس اتصال `calls=true`).

### المرحلة 1 — اتصال WS مخصص للمكالمات (البنية الصحيحة)
- [x] `lib/core/calls/calls_websocket_client.dart`: اتصال ثانٍ بـ
      `?calls=true&connection_id=&sequence_number=` + header `authorization: Bearer`.
- [x] يعالج `hello` (session_id/connID) و`calls_join` (ack) و`calls_error`
      و`calls_signal` (SDP ثنائي msgpack+zlib / ICE نصي) + ping/pong 30s.
- [x] إعادة اتصال بإرسال `reconnect{channelID, originalConnID, prevConnID}`
      وليس `join` عند نفس الـ originalConnID.
- [x] مستقل تماماً عن `WebSocketClientManager` (مسجَّل `@lazySingleton` في DI).

### المرحلة 2 — أحداث المكالمات الناقصة على الـ Hub الرئيسي
- [x] كلاسات typed لكل حدث (مُتحققة من `server/websocket.go` v1.12.2-6):
      `CallEndedEvent`, `CallUserJoinedEvent`, `CallUserLeftEvent`,
      `CallUserMuteEvent`, `CallUserVideoEvent`, `CallUserVoiceEvent`,
      `CallScreenShareEvent`, `CallRaiseHandEvent`, `CallHostChangedEvent`,
      `CallUserReactedEvent`, `CallRecordingStateEvent`, `CallJobStateEvent`,
      `CallCaptionEvent` + `CallStartedEvent` (id/channelID) — مع تحليل
      `user_id` vs `userID` (غير متناسق بين الأحداث) و`emoji.name` و
      `raised_hand` و`timestamp`.
- [x] الربط في الـ switch: `_handleCallsEvent` يوجّه كل `calls_*` إلى الكلاس
      المناسب؛ `host_mute/host_unmute/host_screen_off/host_lower_hand/
      host_removed/call_state` تبقى على `CallStateEvent` العام (يديرها
      `CallsManager` عبر `hostControlStream`).
- [x] استخراج `channel_id`: من `broadcast.channel_id` أولاً ثم `data`
      (`channelID`/`channel_id`) — يغطي `call_end` (broadcast فقط) و
      `user_left` الفردي (data فقط).
- [x] اختبارات وحدة لكل حدث (12 اختباراً في `websocket_client_test.dart`).

### المرحلة 3 — إعادة بناء CallsManager كآلة حالات
- [x] `enum CallState {idle, ringing, joining, connected, reconnecting, ended}`
      — `CallState _callState` + `callStateStream` + `currentCallState` في
      `CallsManager` (المرحلة 5 تربطه بحالات الـ bloc).
- [x] إرسال إشارات عبر اتصال المكالمات: `join{channelID,title,threadID,
      av1Support,dcSignaling}` / `leave` / `mute` / `unmute` / `raise_hand` /
      `react` / `sdp` (zlib+msgpack) / `ice` / `host_*` / `call_state`.
- [x] المشاركون: `Map<String sessionId, CallParticipantState>` تُدار من أحداث
      الـ Hub بالإضافة إلى `onTrack`.
- [x] إنهاء الجهاز عند `user_left`: يُحذف من الخريطة دون `await renderer.dispose()`.
- [x] `_handleSignalingEvent` يقرأ `calls_signal` (offer/answer/candidate) —
      ربط `caller_id` بجلسة كل مشارك عبر track ID في نموذج SFU
      (`audio_<session_id>_<random>` من `genTrackID` في rtcd v1.2.6) —
      الـ renderers مربوطة بمفتاح `sessionId` (متسق مع `user_left`).
- [x] ICE restart + بث الـ offer مجدداً عند إعادة الاتصال/الانقطاع.
- [x] تفعيل `getCallsConfig` كمصدر ICE (`ICEServersConfigs`/`ICEServers` +
      TURN عند `NeedsTURNCredentials`) — أُزيلت قيمة TURN الثابتة من `AppConfig`.
- [x] تحسين `toggleScreenShare`: إزالة مسار الكاميرا + إرسال `screen_on/off`.
- [x] مؤقت رنين للمكالمة الواردة (ringing timeout → رفض تلقائي):
      `Timer(incomingCallRingDuration=30s)` → `incomingCallExpiredStream` +
      حالة `ringing` عند `call_start` الوارد (ملغي عند endCall/call_end/join).

### المرحلة 4 — إكمال CallsRestRepository
- [x] `getCallsConfig()` + `getTurnCredentials()` + `endCall(channelId)` +
      `dismissNotification(channelId)` + أوامر المضيف `host/{make|mute|
      screen-off|lower-hand|remove}` + `getChannelState(channelId)` (يشمل
      المشاركين من `call.sessions`).
- [ ] `recordingStart/Stop` (غير موجود — مؤجل حتى مرحلة التسجيل).
- [x] موديلات `CallParticipantDto` + `CallDto` مع `fromMap` + اختبارات وحدة
      (مطابقة لشكل الخادم `UserStateClient`/`CallStateClient`/`JobStateClient`
      من `server/state.go`): `CallChannelStateDto{enabled,channel_id,call}` +
      `CallDto{id,start_at,sessions,thread_id,post_id,screen_sharing_session_id,
      owner_id,host_id,recording,transcription,live_captions,
      dismissed_notification}` — `getChannelCallState` يعيد `CallChannelStateDto`
      و `_applyCallState` يستهلك `CallDto` (8 اختبارات في
      `test/features/chat/call_dto_test.dart`).

### المرحلة 5 — ربط CallsBloc والحالات
- [x] `CallReconnectingState` (من `onIceConnectionState`/فقدان الـ WS).
- [x] تمييز `CallEndedState` عن `CallIdleState` — `CallState.ended` من
      `callStateStream` → `CallEndedState{channelId}` (عبر `CallStateFromManager`
      الداخلي) ثم مهلة 2 ثانية → idle.
- [x] `JoinCallEvent` يستخدم `callId` الحقيقي من حدث `call_start`.
- [x] رفض/إنهاء خارجي (`call_end`) يعيد idle مع رسالة — يُدار من
      `callStateStream` (حالة `ended`)، والإنهاء المحلي `_onEndCall` يلغي المؤقت.
- [x] `ToggleReactionEvent(emojiName)` يرسل `react` فعلياً عبر
      `CallsManager.sendReaction` (`sendReact(CallsEmoji)` — `react{data:
      <EmojiData JSON>}` مُحقّق من server websocket.go + mobile connection.ts).

### المرحلة 6 — واجهات المشاركين والتفاعلات (الملفات موجودة — الربط ناقص)
- [x] `FullCallScreen`: شبكة المشاركين من `state.participants` (الإزالة عند
      الغادر تلقائياً) + أسماء عبر `UserRepository.getProfilesByIds` مع تخزين
      مؤقت + إطار المتحدث النشط (`isVoiceActive`) + شارات (كتم/يد/شاشة/مضيف)
      + عرض فيديو كل مشارك عبر `participant.renderer`.
- [x] `HostControlsBottomSheet` تربط فعلياً: كتم الكل / إنزال الأيدي /
      طرد مشارك / إنهاء للجميع — عبر `CallsManager.hostMuteAll/
      hostLowerAllHands/hostRemove/hostEndCall` (REST host/*)، ويظهر فقط
      للمضيف (`isCurrentUserHost`).
- [x] شريط الإيموجي يرسل/يستقبل تفاعلات حقيقية: `ToggleReactionEvent(CallsEmoji)`
      → `react`، والاستقبال عبر `reactionsStream` (CallReactionEvent يحمل
      `emojiLiteral` من `emoji.literal`) يُعرض كفقاعات مؤقتة (3 ثوانٍ).
- [x] `IncomingCallBanner`: اسم المتصل من `owner_id` (call_start → CallRingingState
      → `UserRepository.getProfilesByIds`) + `incomingCallFrom` جديد بالترجمات
      + رفض فعلي (`dismissIncomingCall` → REST dismiss-notification) + اختفاء
      تلقائي عند انتهاء مهلة الرنين (آلة الحالات).

### المرحلة 7 — الصوت والتنبيهات
- [x] `AudioSessionManager`: `activateAudioSession()` (ensureAudioSession +
      `setSpeakerphoneOnButPreferBluetooth` — توجيه تلقائي بلوتوث/سماعة، وضع
      playAndRecord يتحقق عبر getUserMedia على Android) عند `initialize()`/
      بدء المكالمة، و`deactivateAudioSession()` (setSpeakerphoneOn(false)) عند
      `endCall()` — توجيه يدوي عبر `setAudioOutput` موجود مسبقاً.
- [x] نغمة/اهتزاز الرنين للمكالمة الواردة: `CallRinger` (SystemSound.alert +
      HapticFeedback.heavyImpact كل ثانية) يُشغَّل مع `_startIncomingCallRingingTimer`
      ويُوقَف عند القبول/الرفض/انتهاء المهلة/call_end.
- [ ] `flutter_callkit_incoming` — مؤجَّل خارج نطاق LAN الحالي (يتطلب إعدادات
      أصيلة iOS/Android + PushKit).

### المرحلة 8 — الاختبارات والتحقق
- [x] وحدة: parsing الأحداث (تم)، `CallsManager` عبر WS وهمي
      (`test/core/calls/calls_manager_test.dart` — 14 اختباراً: الرنين/المهلة/
      الرفض، نهاية المكالمة، المشاركون والتحديثات، الاتصال وإعادة الاتصال،
      hostMuteAll، رسائل خروج)، `CallsBloc`
      (`test/features/chat/calls_bloc_test.dart` — 13 اختباراً: البدء/الإنهاء،
      الرنين/القبول/الرفض، الضوابط، ended→idle بمؤقت 2s). (27/27 ناجحاً)
- [x] يدوي على LAN — **جزئي منجز** (2026-08، الخادم المحلي 127.0.0.1:8065):
      مكالمة من متصفح (testuser01) في قناة DM → التطبيق (sysadmin) يستقبل
      `call_start` على الـ Hub، يظهر `IncomingCallBanner` مع اسم المتصل،
      القبول يُدخل المكالمة (يصبح مضيفاً بعد مغادرة المالك)،
      `call_end` يعيد idle، ورسائل "started a call"/"call ended" تظهر في
      المحادثة. **المتبقي**: اختبار صوت/فيديو/مشاركة شاشة بجهازين فعليين،
      فصل Wi-Fi أثناء المكالمة (ICE restart)، رفض/انتهاء خارجي، NAT متعدد الأجهزة.

### الملخص
| المرحلة | الحالة |
|---|---|
| 0 | ✅ مكتملة (0.1/0.2/0.3 — تحقق فعلي من الإضافة وأحداث WS الحقيقية على الخادم المحلي) |
| 1 | ✅ مكتملة |
| 2 | ✅ مكتملة (كلاسات typed + channel_id من broadcast + اختبارات لكل حدث) |
| 3 | ✅ مكتملة (آلة الحالات CallState، مؤقت الرنين 30s، ربط sessionId من track ID، reconnecting من statusStream) |
| 4 | ⚠️ ~95% (ناقص: recording فقط — موديلات CallDto/ParticipantDto + اختبارات ✅) |
| 5 | ✅ مكتملة (CallEndedState من callStateStream + مؤقت 2s، ToggleReactionEvent يرسل react) |
| 6 | ✅ مكتملة (شبكة بأسماء/شارات/متحدث نشط، تحكمات المضيف، تفاعلات حقيقية، banner باسم المتصل) |
| 7 | ✅ مكتملة (جلسة صوت activate/deactivate + توجيه تلقائي + نغمة/اهتزاز رنين) — CallKit مؤجَّل خارج نطاق LAN |
| 8 | ⚠️ جزئي — وحدة ✅ (CallsManager + CallsBloc، 27/27) — يدوي ✅ جزئياً (مكالمة واردة/قبول/مضيف/انتهاء) — صوت/فيديو/مشاركة/NAT معلّقة |
