# تحليل مقارن شامل ومفصل: Threads, Saved Messages, Mentions, Drafts
## بين تطبيق الويب (Mattermost Webapp) وتطبيق فلاتر (Flutter Mattermost)

---

## 1. الملخص التنفيذي (Executive Summary)

يقدم هذا المستند تحليلاً مفصلاً ودقيقاً لأربعة مكونات رئيسية وشديدة الأهمية في واجهة مستخدم Mattermost:
1. **المحادثات المجمعة (Global Threads / Collapsed Reply Threads - CRT)**
2. **الرسائل المحفوظة (Saved Messages / Flagged Posts)**
3. **الإشارات الأخيرة (Recent Mentions / @mentions)**
4. **المسودات والرسائل المجدولة (Drafts & Scheduled Posts)**

تمت الدراسة والمقارنة المباشرة بين الكود المصدري لتطبيق الويب الموجود في:
`/home/osmsoftwareengineering/mattermost/webapp/channels/src/components/`
وتطبيق فلاتر في مجلدات `lib/features/chat/presentation/pages/` و `lib/features/chat/presentation/rhs/`.

### أبرز نتائج المقارنة:
- **المحادثات المجمعة (Threads):** تطبيق فلاتر يغطي الهيكل الأساسي للـ CRT، لكنه يفتقد لخصائص متقدمة في الويب مثل: إمكانية نقل المحادثة (`Move Thread Modal`)، تبديل المتابعة/إلغاء المتابعة المباشر من البطاقة (`Follow/Unfollow Toggle`)، البحث والفلترة الداخلية، والقراءة/التمهيد التلقائي عبر WebSocket.
- **الرسائل المحفوظة (Saved Messages):** فلاتر يقدم لوحة عرض بسيطة للمحفوظات، ولكن يفتقر لميزة التبويب المزدوج (الرسائل vs الملفات المحفوظة)، وشريط البحث الداخلي، ومودال التأكيد عند إلغاء الحفظ.
- **الإشارات (Mentions):** فلاتر يعتمد على استعلام مبسط `@username` فقط، بينما في webapp يتم بناء الاستعلام بناءً على كليات مفاتيح الإشارة الخاصة بالمستخدم (`User Mention Keys` بما فيها الاسم الأول، اللقب، والمفاتيح المخصصة) مع استثناء `@channel` و`@all` و`@here`.
- **المسودات والرسائل المجدولة (Drafts & Scheduled Posts):** تطبيق فلاتر يحتوي على واجهة ممتازة بها تبويبات للمسودات والمجدولة وتاريخ الإرسال، لكن يوجد تباين في مدى المزامنة السحابية الحية لـ Server-side Drafts عبر الأحداث اللحظية (WebSocket Events `DRAFT_CREATED`, `DRAFT_UPDATED`, `DRAFT_DELETED`).

---

## 2. التحليل التفصيلي لكل مكون (Deep-Dive Analysis)

---

### أولاً: المحادثات المجمعة (Global Threads - CRT)

#### 1. كود الويب (Mattermost Webapp)
- **المسار:** `channels/src/components/threading/`
- **المكونات الأساسية:**
  - `global_threads/global_threads.tsx`: الصفحة الرئيسية للمحادثات المجمعة.
  - `thread_viewer/`: عرض تفاصيل المحادثة المحددة.
  - `virtualized_thread_viewer/`: القائمة الافتراضية عالية الأداء لقراءة الردود.
  - `mark_all_threads_as_read_modal/`: مودال تأكيد تعليم جميع المحادثات كمقروءة.
  - `move_thread_modal/`: نافذة لنقل موضوع محادثة كامل من قناة إلى قناة أخرى.
  - `thread_item/` و `thread_menu/`: البطاقة والقائمة السياقية لكل محادثة (متابعة/إلغاء متابعة، نسخ الرابط، نقل المحادثة، التحديد كغير مقروء).
- **المنطق وإدارة الحالة:**
  - تعتمد على Redux selectors (`getThreads`, `getUnreadThreadIds`) وتتلقى تحديثات لحظية عبر WebSocket عند وصول رد جديد أو تغيير حالة القراءة (`THREAD_READ_CHANGED`) أو المتابعة (`THREAD_FOLLOW_CHANGED`).
  - توفر خياري فلترة رئيسيين: "غير المقروءة" (`Unread`) و "الكل" (`All`).
  - في الشاشات الكبيرة (Desktop): تعرض تصميم الشاشة المزدوجة (Dual-Pane) — القائمة على اليسار وتفاصيل المحادثة المحددة والتفاعل معها على اليمين.

#### 2. تطبيق فلاتر (Flutter Mattermost)
- **المسار:** `lib/features/chat/presentation/pages/threads_page.dart` و `lib/features/chat/presentation/widgets/thread_card.dart`
- **حالة التطبيق الحالية:**
  - تم بناء واجهة `ThreadsPage` تحتوي على الرأس، وزري الفلترة `All` / `Unread` وزر `Mark all as read`.
  - عند النقر على محادثة يتم تحفيز `RhsBloc` لفتح المحادثة في اللوحة الجانبية (RHS).
- **الفجوات والااختلافات المقارنة (Gaps & Discrepancies):**
  1. **زر المتابعة/إلغاء المتابعة (`Follow/Unfollow Toggle`):** في الويب يوجد زر واضح على البطاقة وفي القائمة السياقية لمتابعة/إلغاء متابعة Thread. في فلاتر الزر غير متوفر بشكل مباشر على `ThreadCard`.
  2. **نافذة نقل المحادثة (`Move Thread Modal`):** غير موجودة تماماً في فلاتر (تتيح للمشرفين نقل المحادثة بالكامل بقنواتها لضبط التنظيم).
  3. **البحث والفلترة الداخلية:** الويب يتيح فلترة المحادثات المجمعة حسب الكلمات المفتاحية، بينما فلاتر يقتصر على فلترة `All` / `Unread`.
  4. **الأداء والعرض الافتراضي (Virtualization):** الويب يستخدم `virtualized_thread_viewer` لمعالجة آلاف المحادثات والردود بدون بطء، بينما فلاتر يستخدم `ListView` اعتيادي.

---

### ثانياً: الرسائل المحفوظة (Saved Messages / Flagged Posts)

#### 1. كود الويب (Mattermost Webapp)
- **المسار:** `channels/src/components/search_results/` و حالة RHS `RHSStates.FLAG`
- **المكونات الأساسية:**
  - `actions/views/rhs.ts` (`showFlaggedPosts()`): تحفيز جلب الرسائل المحفوظة عبر `getFlaggedPosts()`.
  - `search_results.tsx` & `post_search_results_item.tsx`: العرض الموحد لنتائج البحث والرسائل المحفوظة والمثبتة.
  - `messages_or_files_selector.tsx`: التبديل بين عرض "الرسائل المحفوظة" وعرض "الملفات المحفوظة".
  - `remove_flagged_message_confirmation_modal/`: تأكيد إزالة الرسالة من المحفوظات.
- **المنطق وإدارة الحالة:**
  - يتم التعامل مع الرسائل المحفوظة كنوع من أنواع نتائج البحث الخاصة (Saved Search Query).
  - تعرض اسم القناة كبادرة (Pill/Badge) تمكّن المستخدم من الانتقال المباشر للقناة.
  - يدعم تصفية نتائج المحفوظات بفلتر تمديد الملفات (`ext:pdf`, `ext:png`).

#### 2. تطبيق فلاتر (Flutter Mattermost)
- **المسار:** `lib/features/chat/presentation/pages/saved_messages_page.dart` و `lib/features/chat/presentation/rhs/saved_pinned_panel.dart`
- **حالة التطبيق الحالية:**
  - تدمج صفحة `SavedMessagesPage` اللوحة `SavedPinnedPanel(isPinned: false)`.
  - تجلب الرسائل عبر `PostRepository.getFlaggedPosts('me')`.
  - تعرض بطاقات الرسائل المحفوظة مع إمكانية إلغاء الحفظ والانتقال للرسالة وسياقها في القناة.
- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **غياب التبويب المزدوج (Messages vs Files):** في الويب يمكن للمستخدم التبديل لرؤية الملفات الموجودة داخل الرسائل المحفوظة فقط. في فلاتر يعرض فقط الرسائل النصية المرفقة.
  2. **شريط البحث والتصفية الداخلي:** الويب يسمح بالبحث داخل الرسائل المحفوظة، بينما فلاتر يفتقر لشريط بحث مخصص داخل صفحة الرسائل المحفوظة.
  3. **نافذة تأكيد إزالة الحفظ (`Remove Flag Confirmation Modal`):** في فلاتر يتم إلغاء الحفظ فوراً دون مودال تأكيد اختياري يمنع التغيير بالخطأ.

---

### ثالثاً: الإشارات الأخيرة (Recent Mentions / @mentions)

#### 1. كود الويب (Mattermost Webapp)
- **المسار:** `actions/views/rhs.ts` (`showMentions()`) و حالة RHS `RHSStates.MENTION`
- **المكونات الأساسية:**
  - `at_mentions_button.tsx`: زر الإشارات في الشريط العلوي العام.
  - `showMentions()` logic: يجمع كافة `User Mention Keys` الخاصة بالصلاحية الحالية (مثل `@username` والاسم الأول والألقاب المستعارة) ويستبعد التنبيهات العامة مثل `@channel` و `@all` و `@here`.
  - يقوم بتركيب استعلام بحث مُخصص يضع علامات تنصيص حول الكلمات المزدوجة لضمان البحث عن الاسم بدقة.
  - يقسم النتائج حسب الأيام (Today, Yesterday, Date Separators) ويبرز الكلمات المشَار إليها بتنسيق مميز (`Mention Highlight`).

#### 2. تطبيق فلاتر (Flutter Mattermost)
- **المسار:** `lib/features/chat/presentation/rhs/mentions_panel.dart`
- **حالة التطبيق الحالية:**
  - يحتوي على `MentionsPanel` يجلب الإشارات عبر `PostRepository.searchPostsInTeam(teamId, '@$username')`.
  - يعرض الإشارات مع فواصل الأيام (Today, Yesterday, Date format)، وأفاتار المستخدم وحالة التواجد (Online/Offline) واسم القناة.
- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **محدودية استعلام الإشارة (`Mention Query Logic`):** فلاتر يكتفي بالبحث عن النص الحرفي `@$username`. بينما الويب يجمع كافة المفاتيح المحفوظة للمستخدم (`getCurrentUserMentionKeys`) بما فيها الاسم الأول أو الكلمات المخصصة للتنبيه (`Custom Mention Keys`).
  2. **عدم استثناء التنبيهات العامة بشكل ديناميكي:** الويب يقوم بفلترة واستبعاد التنبيهات العامة لمنع تلوث قائمة الإشارات الشديدة الأهمية.
  3. **تظليل النص المشار إليه (`Mention Highlighting`):** الويب يظلل الكلمة التي تسببت في الإشارة بخلفية صفراء/برتقالية مميزة. فلاتر يعرض نص الرسالة عبر `MarkdownMessage` دون تظليل مخصص لمفتاح الإشارة.

---

### رابعاً: المسودات والرسائل المجدولة (Drafts & Scheduled Posts)

#### 1. كود الويب (Mattermost Webapp)
- **المسار:** `channels/src/components/drafts/`
- **المكونات الأساسية:**
  - `drafts_and_schedule_posts_tabs.tsx`: تبويبات الملاحة بين المسودات (Drafts) والرسائل المجدولة (Scheduled Posts).
  - `draft_row.tsx`: بطاقة المسودة المتقدمة التي تعرض الهدف (قناة أم رد على محادثة معينة)، المعاينة الغنية، زر التعديل، زر الحذف، وزر الإرسال الفوري.
  - `scheduled_post_list/`: قائمة الرسائل المجدولة مع خيارات تعديل وقت الإرسال المستقبلي أو إلغائها أو إرسالها الآن.
  - المزامنة السحابية اللحظية (`Server-side Draft Synchronization`): يعتمد webapp على مسارات API لـ Drafts (مثل `/api/v4/drafts`) ويتزامن تلقائياً بين مختلف الأجهزة والمتصفحات عبر WebSocket (`DRAFT_CREATED`, `DRAFT_UPDATED`, `DRAFT_DELETED`).

#### 2. تطبيق فلاتر (Flutter Mattermost)
- **المسار:** `lib/features/chat/presentation/pages/drafts_page.dart`
- **حالة التطبيق الحالية:**
  - توفر صفحة `DraftsPage` واجهة متكاملة وممتازة تحتوي على 3 تبويبات: المسودات، المجدولة، وسجل الإرسال (Send History).
  - تعتمد على `DraftsRepository` و `ScheduledPostsRepository`.
  - تتيح إرسال المسودة فوراً أو حذفها.
- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **المزامنة اللحظية عبر WebSocket:** الويب يتحدث لحظياً عند إنشاء أو تعديل أو حذف مسودة من جهاز آخر عبر أحداث WebSocket. في فلاتر تعتمد الواجهة على إعادة التحميل اليدوي أو طلب المستودع (`FutureBuilder`).
  2. **دعم مسودات الردود على المحادثات (`Thread Drafts Navigation`):** في الويب عند النقر على مسودة رد، ينتقل المستخدم مباشرة للمحادثات المجمعة CRT مع فتح محرر الرد مسبقاً بالنص. في فلاتر التوجيه يتطلب التأكد من ربط `rootId` واحتساب سياق CRT بشكل كامل.
  3. **تعديل وقت الرسائل المجدولة (`Reschedule Modal`):** الويب يتيح مودال لتغيير التاريخ والوقت المجدول لرسالة معينة (`scheduled_post_custom_time`). في فلاتر يتوفر خيار الإرسال والحذف، بينما إعادة الجدولة تحتاج استكمال المودال المخصص.

---

## 3. مصفوفة المقارنة المتعددة الأبعاد (Multi-Angle Matrix)

| البُعد / المحور | تطبيق الويب (Mattermost Webapp) | تطبيق فلاتر (Flutter Mattermost) | التقييم ومستوى التوافق |
| :--- | :--- | :--- | :--- |
| **تصميم الواجهة (UI/UX)** | دعم كامل للـ Desktop Dual-Pane والـ RHS Drawer مع استجابة للشاشات الصغيرة | اعتماد على الملاحة بالحاويات وقوائم صفحة مستقلة أو لوحة جانبة RHS | **جيد جداً (85%)**: الواجهات مطابقة بحد كبير لكن بحاجة لبعض التلميحات البصرية (Highlighting/Badges) |
| **إدارة الحالة (State Mgmt)** | Redux Store + Selectors مع معالجة حية وشاملة عبر أحداث WebSocket | BLoC Pattern + FutureBuilder / Local State | **متوسط (70%)**: تنقصه المزامنة اللحظية الكاملة عبر WebSocket لبعض الأحداث |
| **تكامل API والبيانات** | Server-side Drafts API + Threads CRT Endpoints المتقدمة | REST Repositories مع اعتمادات جزئية على Storage محلي في حالة الانقطاع | **جيد (80%)**: تغطية معظم الـ Endpoints لكن يحتاج تكامل أعمق مع Server-side Drafts Sync |
| **ميزات المحادثات (CRT)** | نقل المحادثة، المتابعة/إلغاء المتابعة المباشر، الفلترة الداخلية، Virtualized List | قائمة المحادثات الأساسية، التمييز كغير مقروء، القراءة الشاملة | **متوسط (65%)**: يفتقر لنقل المحادثة والـ Follow Toggle على بطاقة المحادثة |
| **ميزات الإشارات (Mentions)** | استعلام موسع يشمل كافة User Mention Keys المخصصة للمستخدم واستبعاد التنبيهات العامة | استعلام محدد ببنية `@username` فقط | **يحتاج تحسين (60%)**: يحتاج لتوسيع استعلام البحث ليشمل مفاتيح المستخدم الكاملة |
| **ميزات الرسائل المحفوظة** | فلاتر رسائل vs ملفات، بحث داخلي، مودال تأكيد الحذف | عرض القائمة المحفوظة مع إمكانية التوجيه وسياق القناة | **جيد (75%)**: ناقص تبويب الملفات المحفوظة وشريط البحث |

---

## 4. التوصيات وخطة العمل للتطوير (Actionable Remediation Plan)

### المرحلة الأولى: تحسين استعلام الإشارات وتظليل النصوص (Mentions Enhancement)
1. تعديل `MentionsPanel` في `mentions_panel.dart` لجلب كافة `User Mention Keys` من بروفايل المستخدم الحالي (الاسم الأول، اللقب، والمفاتيح المخصصة) بدلاً من الاقتصار على `@username`.
2. إضافة تظليل ملون شفاف (`Mention Highlighting`) داخل مكون `MarkdownMessage` للكلمات التي طابقت استعلام الإشارة.

### المرحلة الثانية: تطوير خصائص المحادثات المجمعة (Threads CRT Improvements)
1. إضافة زر المتابعة/إلغاء المتابعة (`Follow/Unfollow Thread`) مباشرة على `ThreadCard`.
2. إنشاء `MoveThreadModal` لتزويد المشرفين بإمكانية نقل المحادثة بين القنوات.
3. ربط أحداث WebSocket اللحظية (`THREAD_FOLLOW_CHANGED` و `THREAD_READ_CHANGED`) بشجرة البلوك `ThreadsBloc`.

### المرحلة الثالثة: تحسين الرسائل المحفوظة والمسودات (Saved Messages & Drafts Polish)
1. إضافة تبويب التبديل بين "الرسائل المحفوظة" و "الملفات المحفوظة" داخل `SavedMessagesPage`.
2. إضافة مودال التأكيد عند إلغاء حفظ الرسالة لمنع الإلغاء غير المقصود.
3. تفعيل المزامنة اللحظية لـ `DRAFT_CREATED`, `DRAFT_UPDATED`, `DRAFT_DELETED` عبر WebSocket لحفظ المسودات بين كافة أجهزة المستخدم فوراً.

---
*تم إعداد هذا التحليل بناءً على الفحص المباشر لكود المصدر في مشروعي Mattermost Webapp و Flutter Mattermost.*
