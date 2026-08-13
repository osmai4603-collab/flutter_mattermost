# تحليل مقارن شامل ومفصل: Channel Info, Channel Members, Channel Search, Files Search
## بين تطبيق الويب (Mattermost Webapp) وتطبيق فلاتر (Flutter Mattermost)

---

## 1. الملخص التنفيذي (Executive Summary)

يقدم هذا المستند تحليلاً فنياً ودقيقاً من جميع الزوايا لأربعة مكونات رئيسية وحيوية في منصة Mattermost:
1. **معلومات القناة (Channel Info - RHS & Settings Modals)**
2. **أعضاء القناة (Channel Members - RHS, Member List & Group Management Modals)**
3. **البحث داخل القناة والبحث العام (Channel Search & Search Bar Engine)**
4. **البحث في الملفات وملفات القناة (Files Search & Channel Files RHS)**

تمت الدراسة والمقارنة المباشرة بين الكود المصدري لتطبيق الويب الموجود في:
`/home/osmsoftwareengineering/mattermost/webapp/channels/src/components/`
وتطبيق فلاتر الموجود في مجلدات:
`lib/features/chat/presentation/rhs/` و `lib/features/channels/presentation/modals/`

### أبرز نتائج المقارنة:
- **معلومات القناة (Channel Info):** تطبيق فلاتر يوفر الواجهة الجانبية الأساسية (`channel_info_panel.dart`)، ولكن توجد فجوات في عدم وجود مودال إلغاء الأرشفة (`Unarchive Modal`) للمدراء، وغياب بطاقات المعاينة المخصصة للمحادثات المباشرة (`about_area_dm`) والجماعية (`about_area_gm`)، وغياب العدادات الإحصائية الحية (`Live Stats Counters` للرسائل والأعضاء والملفات والمثبتات)، وعدم دعم تحويل القنوات العامة إلى خاصة (`Convert Channel Type`).
- **أعضاء القناة (Channel Members):** يحتوي تطبيق فلاتر على لوحة إدارية جيدة للأعضاء (`channel_members_panel.dart`)، ولكن يفتقر لآلية التمرير اللانهائي (Pagination) للتعامل مع أكثر من 200 عضو، وإدارة المجموعات المنسقة مع LDAP/AD (`Channel Groups Management`)، وطابور طلبات الانضمام للقنوات الخاصة القابلة للاكتشاف (`Pending Join Requests Queue`)، ووسوم سياسات الوصول (`Access Control Attribute Tags`).
- **البحث داخل القناة (Channel Search):** تطبيق فلاتر يدعم البحث الأساسي وحفظ سجل البحث الأخير (`RecentSearchesStore`)، ولكنه يفتقر إلى القائمة المنسدلة التفاعلية للاقتراحات الإكمال التلقائي (`Interactive Autocomplete Suggestions Popout`) لمعدلات البحث (`in:`, `from:`, `on:`, `before:`, `after:`), وموازنة علامات التنصيص الجملية، وفلاش إبراز الرسالة عند الانتقال (`Flash Highlight on Jump to Post`).
- **البحث في الملفات (Files Search):** يوفر فلاتر لوحة ملفات القناة (`channel_files_panel.dart`) ونمطه في البحث، ولكنه يفتقر إلى قائمة تصفية الملفات حسب النوع (PDF, Documents, Code, Images, Audio, Video, Spreadsheets)، والقائمة السياقية لكل ملف (التي تتيح "الانتقال للمحادثة" و "نسخ رابط المحادثة المرفق بها الملف")، والوسوم المميزة لنوع القناة (Public, Private, DM, GM).

---

## 2. التحليل التفصيلي المكوناتي والكودي (Deep-Dive Component Analysis)

---

### أولاً: معلومات القناة (Channel Info / RHS & Settings)

#### 1. كود تطبيق الويب (Mattermost Webapp)
- **المسار الأساسي:** `channels/src/components/channel_info_rhs/`
- **المكونات التابعة والشبكة:**
  - `channel_info_rhs.tsx`: المكون الرئيسي للوحة معلومات القناة اليمينية.
  - `about_area.tsx` / `about_area_channel.tsx` / `about_area_dm.tsx` / `about_area_gm.tsx`: مكونات مخصصة لعرض معلومات القناة حسب نوعها (قناة عامة/خاصة، محادثة ثنائية DM، أو محادثة جماعية GM).
  - `top_buttons.tsx`: أزرار الإجراءات السريعة (تفضيل/إلغاء تفضيل، كتم/إلغاء كتم، إضافة أعضاء، نسخ رابط القناة).
  - `menu.tsx`: شجرة الخيارات والروابط الفرعية التي تتضمن عدادات حية محملة ديناميكياً.
  - Modals المرتبطة:
    - `edit_channel_purpose_modal/`: تعديل غرض القناة.
    - `edit_channel_header_modal/`: تعديل رأس القناة (Header Markdown).
    - `rename_channel_modal/`: تعديل اسم القناة ورابطها (Handle/URL).
    - `channel_notifications_modal/`: ضبط التنبيهات المخصصة للقناة.
    - `unarchive_channel_modal/`: إعادة تفعيل/إلغاء أرشفة القناة المؤرشفة.
    - `convert_channel_modal/`: تحويل نوع القناة من عامة إلى خاصة.

- **المنطق وإدارة الحالة:**
  - يعتمد الويب على استدعاء Redux Action `getChannelStats(channelId)` لجلب إحصائيات حية (`ChannelStats` تحتوي على `member_count`, `pinnedpost_count`, `files_count`).
  - في المحادثات الثنائية (DM)، يستدعي `about_area_dm` بيانات المستخدم الكاملة (`UserProfile`) بما فيها التوقيت المحلي، البريد الإلكتروني، الحالة المخصصة (Custom Status)، وأدوار النظام.
  - تطبيق بوابات الصلاحيات `ChannelPermissionGate` مثل `Permissions.MANAGE_TEAM` أو `canManageProperties` لتحديد إمكانية التعديل أو إلغاء الأرشفة.

#### 2. كود تطبيق فلاتر (Flutter Mattermost)
- **المسار الأساسي:** `lib/features/chat/presentation/rhs/channel_info_panel.dart`
- **المكونات التابعة:**
  - `lib/features/channels/presentation/modals/channel_settings_modal.dart`
  - `lib/features/channels/presentation/modals/channel_notifications_modal.dart`

- **حالة التطبيق الحالية:**
  - يحتوي `ChannelInfoPanel` على تصميم ممتاز يشمل:
    - رأس الصفحة وعرض الاسم والغرض والرأس.
    - بطاقات الأزرار السريعة 4 (Favorite, Mute, Add People, Copy Link).
    - خيارات قائمة القناة (Settings, Notifications, Members, Pinned Messages, Files).
    - إجراءات الخطر (Leave Channel, Archive Channel للمدراء).
    - المعرفات الفنية (Channel Handle, Channel ID).

- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **إلغاء أرشفة القناة (`Unarchive Channel Modal`):** في تطبيق الويب، عند فتح معلومات قناة مؤرشفة، يظهر شريط تنبيه أصفر يحتوي على زر "Unarchive" للمدراء الذين يمتلكون صلاحية `MANAGE_TEAM`. في فلاتر، يظهر تنبيه الأرشفة فقط دون أي خيار أو مودال لإلغاء الأرشفة.
  2. **بطاقات المعاينة المتخصصة (`DM & GM Specific About Cards`):** الويب يقدم واجهة منفصلة تماماً عند فتح معلومات DM (تظهر صورة العضو الكبيرة، الحالة اللحظية، المنطقة الزمنية، والبريد) أو GM (قائمة الأعضاء المشاركين). فلاتر يعامل جميع القنوات بنفس تصميم القناة العادية دون تخصيص واجهة الـ DM/GM.
  3. **العدادات الإحصائية الحية (`Live Stats Counters`):** في الويب، تُعرض خيارات القائمة مع عدادات حية ديناميكية مثل (`12 Members`, `4 Files`, `2 Pinned Messages`). في فلاتر، تُعرض عناوين ثابتة دون أرقام أو إحصائيات حية لعدم ربط API `getChannelStats`.
  4. **تحويل القناة من عامة إلى خاصة (`Convert Channel Modal`):** غير متوفر في فلاتر من واجهة معلومات القناة.
  5. **التحكم الدقيق بالصلاحيات (Granular Permissions):** في الويب، يُفحص `canManageProperties` لإخفاء أو إظهار أزرار "Edit" بجانب الغرض والرأس والاسم. في فلاتر أزرار التعديل تظهر دائماً وتفتح المودال بغض النظر عن صلاحيات المستخدم على المستوى الجزئي.

---

### ثانياً: أعضاء القناة (Channel Members)

#### 1. كود تطبيق الويب (Mattermost Webapp)
- **المسار الأساسي:** `channels/src/components/channel_members_rhs/` و `channels/src/components/channel_members_modal/`
- **المكونات التابعة:**
  - `channel_members_rhs.tsx`: الواجهة الجانبية لأعضاء القناة.
  - `channel_members_modal.tsx`: مودال إدارة الأعضاء الكامل.
  - `channel_members_dropdown.tsx`: القائمة المنسدلة لإجراءات العضو (ترقية لمدير قناة، تنزيل لعضو، إزالة من القناة).
  - `member_list_channel/`: قائمة عرض الأعضاء المقسمة.
  - `channel_groups_manage_modal/` و `add_groups_to_channel_modal/`: مودالات ربط وإدارة مجموعات LDAP/AD القائمة على القنوات.
  - `pending_join_requests.tsx`: طابور مخصص لطلبات الانضمام المعلقة للقنوات الخاصة القابلة للاكتشاف (`Discoverable Private Channels`).

- **المنطق وإدارة الحالة:**
  - يعتمد على التصفح المقسم والصفحات (`USERS_PER_PAGE = 100`) مع البحث السيرفري في الوقت الحي عبر `searchProfilesAndChannelMembers`.
  - يدعم وضع التعديل المتعدد (Bulk Edit/Select) لإزالة مجموعة من الأعضاء بضغطة واحدة.
  - فحص سياسات وشارات التحكم بالوصول (`Access Control Attribute Tags` مثل `Department: Engineering`) وعرضها كبطاقات تنبيهية أعلى قائمة الأعضاء.

#### 2. كود تطبيق فلاتر (Flutter Mattermost)
- **المسار الأساسي:** `lib/features/chat/presentation/rhs/channel_members_panel.dart` و `add_channel_members_modal.dart`

- **حالة التطبيق الحالية:**
  - يحتوي `ChannelMembersPanel` على شريط بحث محلي وسيرفري، وجلب مبدئي للأعضاء عبر `getChannelMembers(perPage: 200)`، وتقسيم القائمة إلى (Channel Admins / Members)، مع صورة العضو وحالته الحية عبر `UserStatusBloc` والقائمة المنسدلة للترقية والإزالة.

- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **التمرير اللانهائي للصفحات (Infinite Scroll Pagination):** في فلاتر يتم استدعاء `perPage: 200` مرة واحدة دون دعم التمرير اللانهائي (Pagination)، مما يؤدي لعدم ظهور بقية الأعضاء في القنوات التي تحتوي على آلاف المستخدمين (مثل القنوات العامة التي تضم 5,000+ عضو).
  2. **إدارة المجموعات ورابط LDAP (`Group Sync & Channel Groups`):** الويب يتيح مدراء القنوات ربط القناة بمجموعات AD/LDAP وتحديد الأدوار تلقائياً عبر `ChannelGroupsManageModal`. هذه الميزة غائبة تماماً في فلاتر.
  3. **طابور طلبات الانضمام المعلقة (`Pending Join Requests Queue`):** للقنوات الخاصة القابلة للاكتشاف، يملك الويب مكون `pending_join_requests` للمدراء لمرجعة وتدقيق وإقرار/رفض طلبات الانضمام. غير مدعومة في فلاتر.
  4. **وسوم سياسات الوصول (`Access Control Attribute Tags`):** الويب يعرض وسم السياسة المطبقة على القناة في أعلى شاشة الأعضاء. غير موجودة في فلاتر.
  5. **التحدي والعمليات الجماعية (Bulk Operations):** الويب يدعم تحديد عدة أعضاء وإزالتهم معاً في شاشة التعديل الجماعي (`editing = true`). فلاتر يقتصر على الإزالة الفردية عضواً بعضو.

---

### ثالثاً: البحث داخل القناة والبحث العام (Channel Search)

#### 1. كود تطبيق الويب (Mattermost Webapp)
- **المسار الأساسي:** `channels/src/components/search_bar/`, `channels/src/components/search/`, `channels/src/components/suggestion/`
- **المكونات التابعة:**
  - `search_bar.tsx`: شريط مدخلات البحث الذكي مع دعم شارات نوع البحث (`MESSAGES` / `FILES`).
  - `suggestion_box/` & `search_suggestion_list.tsx`: المحرك التفاعلي لإكمال معدلات البحث تلقائياً.
  - `search_results.tsx` & `search_results_header.tsx`: واجهة عرض نتائج البحث مع التبويب المزدوج للرسائل والملفات.
  - `rhs_search_popout.tsx`: النوافذ المنبثقة لمساعدات البحث ومحددات التاريخ.

- **المنطق ومحددات البحث (Search Modifiers Engine):**
  - يوفر الويب محرك اقتراحات حي بأسلوب Autocomplete عند كتابة:
    - `in:` (يقترح قائمة القنوات مع استكمال اسمها).
    - `from:` (يقترح أعضاء الفريق).
    - `on:`, `before:`, `after:` (يفتح منتقي تاريخ تفاعلي `SuggestionDate`).
    - `phrase search` (يوازن علامات التنصيص المزدوجة تلقائياً `" "`).
  - عند النقر على "Jump" للانتقال للرسالة من نتائج البحث، يذهب الويب للقناة ويقوم بعمل فلاش خلفية أصفر مؤقت (`post--highlight`) لجذب عين المستخدم للرسالة المحددة.

#### 2. كود تطبيق فلاتر (Flutter Mattermost)
- **المسار الأساسي:** `lib/features/chat/presentation/rhs/search_results_panel.dart` و `search_bloc.dart` و `recent_searches_store.dart`

- **حالة التطبيق الحالية:**
  - يحتوي فلاتر على `SearchResultsPanel` مجهزة بـ `_SearchBar` ومبدل `_MessageFileSelector` وسجل عمليات البحث الأخيرة `RecentSearchesStore` وحالة التحميل الافتراضية `_SkeletonResults` ودعم التمرير التلقائي للجلب الإضافي عبر `SearchBloc`.

- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **المساعد التفاعلي للاقتراحات (`Interactive Autocomplete Popout`):** في الويب بمجرد كتابة `in:` أو `from:` يظهر كائن منبثق فوري يقترح الأسماء والقنوات والتواريخ. في فلاتر لا توجد ميزة الإكمال التلقائي التفاعلي داخل شريط البحث، ويتحتم على المستخدم كتابة اسم المعرف يدويًا بالكامل.
  2. **موازنة علامات التنصيص والجمل الدقيقة:** الويب يعالج النصوص ويقوم بإغلاق علامات التنصيص المزدوجة التلقائي لضمان البحث عن الجملة كما هي. فلاتر يرسل النص كما تم إدخاله مباشرة.
  3. **تظليل الرسالة عند الانتقال (`Post Flash Highlight`):** في الويب عند النقر على نتيجة البحث والانتقال للقناة، يتم تسليط الضوء على خلفية الرسالة بلون أصفر فاقع لمدة ثانية واحدة. في فلاتر يتم الانتقال لموقع الرسالة ولكن بدون وميض/تظليل مرئي واضح للرسالة المستهدفة.

---

### رابعاً: البحث في الملفات وملفات القناة (About Files Search & Channel Files)

#### 1. كود تطبيق الويب (Mattermost Webapp)
- **المسار الأساسي:** `channels/src/components/file_search_results/` و `channels/src/components/search_results/`
- **المكونات التابعة:**
  - `file_search_results.tsx` & `file_search_result_item.tsx`: العرض التفصيلي لنتائج البحث في الملفات.
  - `files_filter_menu.tsx`: شريط تصفية نتائج البحث حسب تصنيف الملفات.
  - `messages_or_files_selector.tsx`: التبديل بين الرسائل والملفات.
  - `file_preview_modal/`: النافذة المنبثقة لمعاينة وتصفح الملفات والوسائط.

- **خيارات الفلترة والإجراءات:**
  - تتيح قائمة `files_filter_menu` للمستخدم التصفية المباشرة بناءً على التصنيفات التالية:
    - Documents (PDF, Word, TXT, etc.)
    - Spreadsheets (XLS, XLSX, CSV)
    - Presentations (PPT, PPTX)
    - Code (JS, TS, PY, HTML, CSS, JSON)
    - Images (PNG, JPG, GIF, SVG)
    - Audio (MP3, WAV)
    - Video (MP4, WEBM, MOV)
  - يقدم كل عنصر ملف في نتائج البحث قائمة إجراءات سياقية (Dropdown Menu):
    - **Jump to conversation:** الانتقال المباشر للرسالة الأصلية المرفق بها الملف.
    - **Copy Link:** نسخ رابط مشاركة الرسالة المحتوية على الملف.
    - **Download:** تنزيل الملف مباشرة.
    - **Plugin Action Items:** الإجراءات الإضافية المضافة بواسطة إضافات Mattermost Plugins.
  - عرض وسم القناة (Tag Badge) يبين نوع القناة التي رُفع فيها الملف (Public, Private, Direct Message, Group Message).

#### 2. كود تطبيق فلاتر (Flutter Mattermost)
- **المسار الأساسي:** `lib/features/chat/presentation/rhs/channel_files_panel.dart` و `search_results_panel.dart`

- **حالة التطبيق الحالية:**
  - يحتوي `ChannelFilesPanel` على مدخل بحث ونمط جلب الملفات عبر `FilesRemoteDataSource.searchFilesInTeam(terms: 'channel:name query')` وعرض قائمة الصفوف `_FileRow` التي تحتوي على أيقونة النوع، الاسم، الحجم والتاريخ ومعاينة وتنزيل عند التحويم.

- **الفجوات والاختلافات المقارنة (Gaps & Discrepancies):**
  1. **غياب تصفية تصنيفات الملفات (`Files Category Filter Menu`):** في الويب يمكن فلترة الملفات المكتشفة بنقرة واحدة لتمرير نوع الملفات المرغوبة (مستندات، صور، كود، جداول بيانات...). في فلاتر لا تتوفر هذه القائمة المنسدلة في شاشة البحث أو لوحة ملفات القناة.
  2. **القائمة السياقية للملف (`File Context Dropdown Menu`):** عنصر الملف في فلاتر ينقلك للمعاينة أو التنزيل فقط. بينما في الويب يوفر خياري "Jump to conversation" و "Copy link to post" الهامين جداً للوصول لسياق الملف.
  3. **وسوم تمييز القنوات (`Channel Type Tags`):** الويب يضع شارة (Pill Badge) بجانب اسم الملف توضح هل هو في محادثة خاصة، ثنائية DM، أو جماعية GM. في فلاتر يُكتفى باسم الملف وحجمه وتاريخه.
  4. **دعم الإضافات (`Plugin Menu Items`):** الويب يفحص المكونات الإضافية المسجلة ويضيف خياراتها للملفات، بينما فلاتر لا يدعم خطوط ربط الإضافات مع الملفات.
  5. **تحميل التصفح اللانهائي (Infinite Pagination):** `ChannelFilesPanel` يستدعي صفحة واحدة بقيمة ثابتة `per_page: 100` باستخدام `FutureBuilder`. إذا كانت القناة تحتوي على 500 ملف، لن يتمكن المستخدم من الوصول لبقية الملفات بدون آلية التمرير والتحميل المستمر.

---

## 3. جدول المقارنة الفنية الشاملة (Technical Comparison Matrix)

| الميزة / الوظيفة | تطبيق الويب (Mattermost Webapp) | تطبيق فلاتر (Flutter Mattermost) | نسبة التوافق | الفجوات المباشرة |
| :--- | :--- | :--- | :---: | :--- |
| **مودال إلغاء الأرشفة (Unarchive Modal)** | مدعوم بشرط صلاحية `MANAGE_TEAM` | غير مدعوم | **0%** | عدم وجود زر أو نافذة لإلغاء أرشفة القناة |
| **تخصص واجهات DM & GM في Channel Info** | واجهات مخصصة تظهر ملف العضو والتوقيت والـ GM | واجهة موحدة لجميع القنوات | **40%** | غياب بطاقات تفاصيل المستخدم الثنائي وقائمة الأعضاء |
| **الإحصائيات والعدادات الحية (Live Stats)** | عدادات حية محملة من `getChannelStats` | عناوين ثابتة بدون عدادات | **30%** | عدم عرض أعداد الأعضاء والملفات والمثبتات |
| **تحويل نوع القناة (Public -> Private)** | نافذة مخصصة `ConvertChannelModal` | غير متوفر من شاشة المعلومات | **0%** | غياب خيار تحويل القناة العامة لخاطفة/خاصة |
| **تعديل الخصائص بحسب الصلاحيات الجزئية** | فحص دقيق عبر `canManageProperties` | أزرار التعديل مجهزة إستاتيكياً | **60%** | ظهور الأزرار حتى لو لم يملك المستخدم صلاحية |
| **التمرير اللانهائي لأعضاء القناة (Pagination)** | دالة تصفح ديناميكية لكل 100 عضو | جلب ثابت لأول 200 عضو فقط | **40%** | توقف القائمة عند 200 عضو في القنوات الكبيرة |
| **إدارة مجموعات LDAP/AD القائمة للقنوات** | مودال كامل `ChannelGroupsManageModal` | غير مدعوم | **0%** | غياب الربط مع مجموعات الدليل الفعال |
| **طابور طلبات الانضمام للقنوات الخاصة** | مكون `pending_join_requests` للمدراء | غير مدعوم | **0%** | عدم القدرة على قبول/رفض طلبات الانضمام |
| **وسوم سياسات الوصول للأعضاء (Attribute Tags)** | عرض شارات سياسات العضوية | غير مدعوم | **0%** | غياب شارات السياسات المطبقة |
| **الاقتراحات التفاعلية لمعدلات البحث (Autocomplete)** | قائمة منبثقة تفاعلية لـ `in:`, `from:`, `on:` | سجل عمليات البحث الأخيرة فقط | **30%** | غياب الاكمال التلقائي للقنوات والأعضاء والتواريخ |
| **تصفية الملفات حسب النوع (Files Category Filter)** | قائمة منسدلة لتصفية المستندات والصور والكود | غير مدعوم | **0%** | غياب الفلترة بحسب امتداد ونوع الملف |
| **القائمة السياقية للملف (Jump & Copy Link)** | خيارات الانتقال للمحادثة ونسخ رابط الملف | معاينة وتنزيل فقط | **50%** | غياب الانتقال لسياق الرسالة الأصلية من القائمة |
| **تظليل الرسالة عند الانتقال من البحث (Flash Highlight)** | تظليل أصفر مؤقت لفيزياء الرسالة | الانتقال بدون وميض خلفية | **40%** | عدم تمييز الرسالة بصرياً عند قفز البحث |

---

## 4. التحليل المعماري وإدارة الحالة والأداء (Architecture, State Management & Performance)

### 1. إدارة الحالة (State Management Alignment)
- **الويب:** يعتمد على **Redux Store** وحالات مركزية تشمل `entities/channels`, `entities/users`, `entities/search`, `views/rhs`. ويتم تحديث البيانات لحظياً عند استقبال إشارات WebSocket.
- **فلاتر:** يعتمد على **BLoC Pattern** موزعة بين:
  - `ChannelBloc` لإدارة حالة القناة المحددة والأعضاء والقواعد.
  - `RhsBloc` للتحكم في التنقل بين لوحات RHS المختلفة (`ShowChannelInfoEvent`, `ShowChannelMembersEvent`, `ShowChannelFilesEvent`, `ShowSearchResultsEvent`).
  - `SearchBloc` للتحكم في استعلامات البحث وإلغاء الاستعلامات السابقة والجلب الإضافي.
  - `UserStatusBloc` لجلب وتحديث حالات التواجد اللحظية للأعضاء.

### 2. معالجة الأحداث اللحظية عبر WebSocket
تفتقر بعض لوحات فلاتر للتجاوب التلقائي الحي عند وقوع الأحداث التالية مقارنة بالويب:
- `USER_ADDED` / `USER_REMOVED`: في الويب، تنعكس هذه الإشارات فوراً على لوحة `ChannelMembersRHS` وعدادات `ChannelInfoRHS`. في فلاتر يتطلب الأمر إعادة تحميل manual أو فتح اللوحة من جديد.
- `CHANNEL_UPDATED`: عند تعديل اسم القناة أو غرضها من قبل مستخدم آخر، يعيد الويب بناء اللوحة فوراً.

### 3. أداء الواجهات والقوائم الضخمة (List Performance & Virtualization)
- **في الويب:** تُستخدم مكتبات العرض الافتراضي (Virtualization) لمعالجة 10,000+ عضو أو نتيجة بحث دون استهلاك الذاكرة.
- **في فلاتر:** استخدام `ListView.builder` ممتاز وأداؤه عالٍ، ولكن في `ChannelMembersPanel` كود الجلب يجلب أول 200 فقط، وفي `ChannelFilesPanel` يجلب 100 ملف فقط دون آلية pagination مجهزة بسكرول للأسفل لاستدعاء `page + 1`.

---

## 5. التوصيات وخطة العمل التنفيذية (Actionable Implementation Plan)

للترقية بتطبيق فلاتر ليكون متوافقاً ومكافئاً لتطبيق الويب 100% في المكونات الأربعة، يُوصى بتنفيذ الخطة المرحلية التالية:

### المرحلة الأولى: سد فجوات معلومات القناة (Channel Info Enhancements)
1. **تحديث `ChannelInfoPanel`:**
   - ربط API `getChannelStats` لإظهار العدادات الحية للأعضاء، الملفات، والرسائل المثبتة.
   - إضافة دمج واجهة `about_area_dm` لعرض ملف المستخدم الثنائي المكتمل والمنطقة الزمنية عندما تكون القناة من نوع DM.
   - إضافة خيار ومودال إلغاء الأرشفة `UnarchiveChannelModal` للمدراء عند معاينة قناة مؤرشفة.

### المرحلة الثانية: تطوير لوحة الأعضاء والبحث (Channel Members & Pagination)
1. **إضافة التمرير اللانهائي (Pagination) للأعضاء:**
   - تعديل دالة التحميل في `ChannelMembersPanel` لتعتمد على `ScrollController` وتستدعي `getChannelMembers(page: current + 1)` عند الاقتراب من النهاية.
2. **إضافة طابور الطلبات المعلقة (`Pending Join Requests`):**
   - إنشاء شريط ترويسة مخصص للمدراء يظهر طلبات الانضمام المعلقة للقنوات الخاصة القابلة للاكتشاف مع زري القبيل والرفض.

### المرحلة الثالثة: ترقية محرك البحث والإكمال التلقائي (Search Autocomplete & Modifiers)
1. **بناء مكون الاقتراحات المنبثق `SearchSuggestionBox`:**
   - إنشاء محرك تفاعلي يظهر أسفل شريط البحث يحلل الكلمات (`in:`, `from:`, `on:`) ويقترح القنوات والأعضاء والتواريخ ديناميكياً.
2. **إضافة فلاش تظليل خلفية الرسالة عند الانتقال:**
   - إضافة حالة تظليل مؤقتة (`highlightedPostId`) في `PostBloc` تجعل بطاقة الرسالة تومض باللون الأصفر/البرتقالي عند القفز إليها من شاشة نتائج البحث.

### المرحلة الرابعة: تطوير لوحة ونتائج البحث في الملفات (Files Search & Filters)
1. **إضافة شريط تصفية امتداد الملفات (`FilesFilterMenu`):**
   - إضافة خيارات تصفية أعلى نتائج بحث الملفات وفي `ChannelFilesPanel` تتيح الاختيار بين (الكل، المستندات، الصور، الجداول، الكود، الفيديو).
2. **إضافة القائمة السياقية لكل ملف (`File Context Menu`):**
   - إضافة قائمة خيارات سفلية لكل عنصر ملف تحتوي على: "الانتقال للمحادثة Jump to post" و "نسخ رابط المحادثة Copy Link" للتوافق التام مع الويب.

---
*تم إعداد هذا التحليل بناءً على الفحص المباشر لكود Mattermost Webapp و Flutter Mattermost.*
