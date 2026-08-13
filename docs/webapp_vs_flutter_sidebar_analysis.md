# تحليل مقارن شامل: Channel Sidebar
## Mattermost Webapp (React/TSX) ↔ Flutter Implementation

---

## 🗂️ خريطة المكونات

| Webapp (React) | Flutter | الحالة |
|---|---|---|
| `sidebar.tsx` | `channel_sidebar.dart` | ⚠️ ناقص |
| `sidebar_list.tsx` | `channel_sidebar.dart` (مدمج) | 🔴 كبير جداً |
| `sidebar_category.tsx` | `sidebar_category.dart` | ⚠️ ناقص |
| `sidebar_category_menu/index.tsx` | `_CategoryMenu` (مدمج) | 🔴 ناقص جداً |
| `sidebar_channel_link.tsx` | `sidebar_channel_row.dart` | ⚠️ ناقص |
| `sidebar_channel_menu.tsx` | `channel_context_menu.dart` | ⚠️ ناقص |
| `sidebar_direct_channel.tsx` | `_DmRow` (مدمج) | 🔴 ناقص |
| `sidebar_group_channel.tsx` | **غير موجود** | 🚫 مفقود |
| `sidebar_header.tsx` | `sidebar_header.dart` | ⚠️ ناقص |
| `channel_filter.tsx` (Unread Filter) | `lhs.unreadsOnly` (جزئي) | 🔴 ناقص |
| `unread_channels.tsx` | **غير موجود** | 🚫 مفقود |
| `unread_channel_indicator.tsx` | **غير موجود** | 🚫 مفقود |
| `ResizableLhs` | **غير موجود** | 🚫 مفقود |
| `DataPrefetch` | **غير موجود** | 🚫 مفقود |
| `SidebarJoinRequestCountsSync` | **غير موجود** | 🚫 مفقود |
| `mobile_sidebar_header.tsx` | **غير موجود** | 🚫 مفقود |
| `add_channels_cta_button.tsx` | **غير موجود** | 🚫 مفقود |
| `invite_members_button.tsx` | **غير موجود** | 🚫 مفقود |
| `DraftsLink` | **غير موجود** | 🚫 مفقود |
| `GlobalThreadsLink` | `_GlobalSectionLink` (جزئي) | ⚠️ |
| `RecapsLink` | **غير موجود** | 🚫 مفقود |

---

## 🔴 الفجوات الحرجة (Critical Gaps)

### 1. نظام Drag & Drop مختلف كلياً

**Webapp** يستخدم `react-beautiful-dnd` — مكتبة متخصصة تُعطي:
```tsx
// sidebar_list.tsx
<DragDropContext onDragEnd={this.onDragEnd} onBeforeCapture={this.onBeforeCapture}>
  <Droppable droppableId='droppable-categories' type='SIDEBAR_CATEGORY'>
    // الفئات قابلة للسحب بين بعضها
    <Draggable draggableId={category.id} index={categoryIndex}>
      <Droppable droppableId={category.id} type='SIDEBAR_CHANNEL'>
        // القنوات قابلة للسحب داخل الفئة وبين الفئات
```

**Flutter** يستخدم `LongPressDraggable<String>` + `DragTarget<SidebarCategoryDragData>`:
- ✅ `SidebarCategory` لديه `DragTarget` صحيح
- ❌ `_DmRow` يستخدم `LongPressDraggable<String>` بدون `DragTarget` مقابل
- ❌ **لا يوجد** سحب الفئات بين بعضها (reorder categories)
- ❌ **لا يوجد** `DraggingState` ليعرف UI حالة السحب
- ❌ **لا يوجد** `DraggingStateTypes` (CHANNEL/DM/MIXED_CHANNELS/CATEGORY)
- ❌ **لا يوجد** `isDropDisabled` — يمنع الـ webapp سحب DM إلى فئة channels والعكس

> [!CAUTION]
> Flutter يسمح سحب DM إلى فئة channels — وهو سلوك خاطئ لا يحدث في الـ webapp

---

### 2. قناة المجموعة (GM - Group Message) غير مُنفّذة

**Webapp** لديه مكوّن مستقل [`sidebar_group_channel.tsx`](file:///home/osmsoftwareengineering/mattermost/webapp/channels/src/components/sidebar/sidebar_channel/sidebar_group_channel/sidebar_group_channel.tsx):
```tsx
// أيقونة GM: عداد عدد الأعضاء
const getIcon = () => (
  <div className='status status--group'>{membersCount}</div>
);
// رابط GM: /teamName/messages/channelName (وليس @username)
link={`/${currentTeamName}/messages/${channel.name}`}
```

**Flutter** لا يُميّز بين `ChannelType.direct` و`ChannelType.group`:
```dart
// channel_sidebar.dart#L138
if (ch.type == ChannelType.direct && !inCategories.contains(ch.id)...)
// ❌ ChannelType.group مُهمل تماماً في _DmCategory
```
- ❌ `_DmRow._label` لا يعالج `displayName` الغير فارغ للـ GM (الخادم يُعيده مملوءاً)
- ❌ أيقونة GM يجب أن تُظهر عدد الأعضاء (`membersCount`) لا دائرة

---

### 3. Unread Channel Indicator — مؤشرات الأعلى والأسفل مفقودة

**Webapp** [`unread_channel_indicator.tsx`](file:///home/osmsoftwareengineering/mattermost/webapp/channels/src/components/sidebar/unread_channel_indicator) يعرض أسهم تمرير في أعلى وأسفل القائمة عند وجود قنوات غير مقروءة خارج مجال الرؤية:
```tsx
<UnreadChannelIndicator name='Top' show={this.state.showTopUnread}
  onClick={this.scrollToFirstUnreadChannel} />
<UnreadChannelIndicator name='Bottom' show={this.state.showBottomUnread}
  onClick={this.scrollToLastUnreadChannel} />
```

**Flutter**: ❌ غير موجود — المستخدم لا يعلم بوجود قنوات غير مقروءة تحت منطقة الرؤية.

---

### 4. فئة "Unreads" المدارة (Managed Category) غير مُنفّذة

**Webapp** يدعم `CategoryTypes.MANAGED` — فئة نظام مخصوصة يُعيدها الخادم:
```tsx
// sidebar_list.tsx
const managedCategories = categories.filter(c => c.type === CategoryTypes.MANAGED);
// تُعرض خارج DragDropContext (غير قابلة للسحب)
```

**Flutter**:
- ❌ `channelSectionsFor` يُصفّي `ChannelCategoryType.favorites` و`ChannelCategoryType.directMessages` فقط
- ❌ `CategoryTypes.MANAGED` لا وجود له في `ChannelCategoryType`
- ❌ الفئات المُدارة تُعرض كفئات عادية قابلة للسحب

---

### 5. نظام ترتيب القنوات (CategorySorting) غير مُنفّذ

**Webapp** يدعم 3 أوضاع ترتيب لكل فئة:
```tsx
// sidebar_category_menu/index.tsx
CategorySorting.Alphabetical  // أبجدي
CategorySorting.Recency       // حسب آخر نشاط
CategorySorting.Manual        // يدوي (drag & drop)
```

**Flutter** يفرز دائماً بـ `lastPostAt` تنازلياً بغض النظر عن إعداد الفئة:
```dart
// sidebar_category.dart#L72-73
final sorted = [...channels]
  ..sort((a, b) => b.lastPostAt.compareTo(a.lastPostAt));
// ❌ لا يراعي category.sorting من الخادم
```

---

### 6. Multi-select للقنوات غير موجود

**Webapp** يدعم اختيار متعدد (Ctrl+Click أو Shift+Click):
```tsx
// sidebar_channel_link.tsx
if (cmdOrCtrlPressed(event)) {
  this.props.actions.multiSelectChannelAdd(this.props.channel.id);
} else if (event.shiftKey) {
  this.props.actions.multiSelectChannelTo(this.props.channel.id);
}
```

**Flutter**: ❌ لا يوجد أي دعم لاختيار متعدد.

---

### 7. Keyboard Shortcuts غير موجودة

**Webapp** يدعم:
| Shortcut | الوظيفة |
|---|---|
| `Alt + ↑/↓` | التنقل بين القنوات |
| `Alt + Shift + ↑/↓` | التنقل بين القنوات غير المقروءة |
| `Ctrl + Shift + U` | تفعيل/إيقاف فلتر Unreads |
| `Shift + Esc` | تعليم الكل كمقروء |
| `Ctrl + /` | فتح نافذة اختصارات لوحة المفاتيح |
| `Ctrl + Shift + A` | فتح User Settings |
| `Ctrl + Shift + K` | فتح نافذة DM |

**Flutter**: ❌ لا يوجد أي اختصار لوحة مفاتيح.

---

## 🟡 اختلافات السلوك (Behavior Differences)

### 8. إدارة اسم DM — خطأ في Flutter

**Webapp** [`sidebar_direct_channel.tsx#L91-L98`]:
```tsx
let displayName = channel.display_name;
if (this.props.currentUserId === teammate.id) {
  // محادثة مع النفس تُضاف لها "(you)"
  displayName = intl.formatMessage({id: 'sidebar.directchannel.you'}, {displayname: channel.display_name});
}
// displayName مأخوذ من الخادم مباشرة (محسوب في server)
```

**Flutter** [`_DmRow._label`]:
```dart
// يحسب الاسم من الـ profile محلياً
final full = '${u.firstName} ${u.lastName}'.trim();
// ❌ لا يُضيف "(you)" لمحادثة النفس
// ❌ يتجاهل displayName المُحسوب من الخادم
```

---

### 9. رابط DM في Flutter خاطئ

**Webapp**: رابط DM = `/${teamName}/messages/@${teammate.username}`
**Flutter**: رابط DM = `/${teamName}/channels/${channel.name}`

```dart
// channel_sidebar.dart#L79
context.go('/$teamName/channels/${channel.name}');
// ❌ الصحيح للـ DM: messages/@username
// ❌ الصحيح للـ GM: messages/channelName
```

---

### 10. Copy Link للقناة — مختلف

**Webapp** [`sidebar_channel_menu.tsx#L217`]:
```tsx
// copyLink يظهر فقط لـ OPEN_CHANNEL و PRIVATE_CHANNEL (ليس DM/GM)
if (channel.type === Constants.OPEN_CHANNEL || channel.type === Constants.PRIVATE_CHANNEL) {
  copyLinkMenuItem = ...
}
// copyToClipboard(channelLink) — channelLink مُمرَّر صحيحاً
```

**Flutter** [`channel_context_menu.dart#L316-L323`]:
```dart
// يظهر لكل القنوات (DM/GM أيضاً)
MatterMenuItem(id: 'copy_link', ...)

// URL مبني بشكل خاطئ:
final base = getIt<ApiClient>().dio.options.baseUrl; // يتضمن /api/v4
final url = '$base/$teamName/channels/${channel.name}';
// ❌ الصحيح: استخراج base URL فقط بدون /api/v4
```

---

### 11. Add Members — مفقود في Flutter

**Webapp** [`sidebar_channel_menu.tsx#L237-L261`]: يعرض "Add Members" لـ Public/Private channel إذا كان للمستخدم صلاحية `manageMembers`.

**Flutter**: ❌ لا يوجد بند "Add Members" في `channel_context_menu.dart`.

---

### 12. Mark as Read/Unread — مفقود في Flutter

**Webapp** يُتيح:
- تعليم قناة كمقروءة (من القائمة)
- تعليم قناة كغير مقروءة (Alt+Click أو من القائمة)
- تعليم فئة كاملة كمقروءة
- تعليم كل القنوات كمقروءة (Shift+Esc)

**Flutter**: ❌ لا يوجد أي من هذه الخيارات.

---

### 13. Muted Channel Visual في Flutter غير مكتمل

**Webapp** [`sidebar_channel_link.tsx#L307-L314`]:
```tsx
const className = classNames([
  'SidebarLink',
  { muted: isMuted, ... }  // CSS class يُغير opacity للقناة المكتومة
]);
```

**Flutter**: الكتم يُخزَّن في `notifyProps` لكن `SidebarChannelRow` لا يطبّق أي تمييز بصري للقناة المكتومة (لا تعتيم، لا أيقونة).

---

### 14. Urgency/Priority Mention — مفقود في Flutter

**Webapp** [`sidebar_channel_link.tsx`]:
```tsx
// دعم "urgent mention" بلون مختلف وتولتيب
<ChannelMentionBadge hasUrgent={hasUrgent} tooltip={urgentMentionTooltip} />
```

**Flutter**: `ChannelUnreadCounts` لا يحتوي على حقل `hasUrgent` — شارة المنشنات لا تُميّز بين Urgent و Normal.

---

### 15. Collapsed Threads Integration

**Webapp** [`sidebar_list.tsx#L329-L335`]:
```tsx
if (this.props.collapsedThreads) {
  allChannelIds.unshift(''); // Global threads كأول عنصر في التنقل
  if (this.props.hasUnreadThreads) {
    unreadChannelIds.unshift('');
  }
}
```

**Flutter** `GlobalThreadsLink` موجود لكن لا يتكامل مع نظام التنقل بالـ keyboard ولا unread indicators.

---

### 16. Invite Members Button غير موجود في Flutter

**Webapp**: يظهر `InviteMembersButton` في أسفل فئة direct_messages.
**Flutter**: ❌ مفقود تماماً.

---

### 17. `AddChannelsCtaButton` في أسفل فئة channels

**Webapp**: يظهر `AddChannelsCtaButton` في أسفل فئة channels — زر CTA لتشجيع المستخدم على إضافة قنوات.
**Flutter**: ❌ مفقود.

---

### 18. Resizable Sidebar — مفقود في Flutter

**Webapp** يُغلّف كل الـ sidebar في `<ResizableLhs>`:
```tsx
<ResizableLhs id='SidebarContainer' className={...}>
```

**Flutter**: عرض الـ sidebar ثابت — المستخدم لا يستطيع تغيير عرضه.

---

### 19. `DataPrefetch` و `SidebarJoinRequestCountsSync` — مفقودان

**Webapp** يضع في الـ sidebar:
```tsx
<DataPrefetch/>              // يُحمّل البيانات مسبقاً للقنوات المُختارة
<SidebarJoinRequestCountsSync/> // يزامن طلبات الانضمام لقنوات Private
```

**Flutter**: ❌ كلاهما مفقود — لا يوجد data prefetching ولا مزامنة طلبات الانضمام.

---

### 20. مزامنة حالة الـ Collapse مع الخادم

**Webapp** يحفظ حالة الطي على الخادم:
```tsx
// sidebar_category.tsx
this.props.actions.setCategoryCollapsed(category.id, !category.collapsed);
// يرسل PATCH /users/{userId}/teams/{teamId}/channels/categories/{categoryId}
```

**Flutter** [`LhsBloc.ToggleCategoryCollapsedEvent`]: الطي محلي فقط في الـ Bloc — يُفقَد عند إعادة التشغيل.

---

### 21. `sidebar.tsx` — مستمعو لوحة المفاتيح على مستوى `window`

**Webapp**:
```tsx
componentDidMount() {
  window.addEventListener('click', this.handleClickClearChannelSelection);
  window.addEventListener('keydown', this.handleKeyDownEvent);
}
```

**Flutter**: لا يوجد `clearChannelSelection` — تغيير التركيز لا يُلغي اختيار القنوات المتعددة.

---

### 22. Tooltip على اسم القناة عند الاقتطاع

**Webapp** [`sidebar_channel_link.tsx#L127-L130`]:
```tsx
enableToolTipIfNeeded = () => {
  const showTooltip = element && element.offsetWidth < element.scrollWidth;
  // تُظهر tooltip بالاسم الكامل فقط إذا كان النص مقطوعاً
};
```

**Flutter**: `SidebarChannelRow` يستخدم `overflow: TextOverflow.ellipsis` فقط بدون Tooltip.

---

### 23. Custom Status Emoji في DM

**Webapp** [`sidebar_channel_link.tsx#L232-L245`]:
```tsx
// يعرض الـ Custom Status Emoji للمستخدم المقابل في DM
const customStatus = this.props.teammateId ? (
  <CustomStatusEmoji userID={this.props.teammateId} ... />
) : null;
```

**Flutter**: ❌ لا يوجد دعم Custom Status.

---

### 24. Shared Channel Indicator

**Webapp**: `<SharedChannelIndicator>` يُظهر أيقونة للقنوات المُشتركة مع سيرفرات خارجية.
**Flutter**: ❌ مفقود.

---

### 25. Pending Join Requests Dot

**Webapp** [`sidebar_channel_link.tsx#L278-L286`]:
```tsx
{this.props.hasPendingJoinRequests && (
  <span className='SidebarChannelLink__join-request-dot'/>
)}
```

**Flutter**: ❌ مفقود.

---

### 26. قائمة الفئة: `Mark as Read` وترتيب الفرز — مفقوذان في Flutter

**Webapp** `sidebar_category_menu/index.tsx` يُتيح:
- ✅ Mute/Unmute Category
- ✅ Rename Category (مخصصة فقط)
- ✅ Delete Category (مخصصة فقط)
- ✅ **Sort Channels** (Alphabetically / Recent / Manually) — SubMenu كامل
- ✅ **Mark Category as Read**
- ✅ Create New Category

**Flutter** `_CategoryMenu`:
- ✅ Mute/Unmute
- ✅ Rename (مخصصة + Favorites فقط) — لكن Favorites لا يجب أن تُعاد تسميتها في الـ webapp
- ✅ Delete
- ❌ **Sort Channels مفقود**
- ❌ **Mark as Read مفقود**
- ✅ Create New Category

> [!WARNING]
> الـ webapp يسمح إعادة تسمية الـ Favorites فقط لـ CUSTOM categories، لكن Flutter يسمحها لـ Favorites أيضاً.

---

### 27. قائمة القناة: `Open in New Window` و `Mark as Read/Unread` — مفقودان

**Webapp** `sidebar_channel_menu.tsx`:
- ✅ Mark as Read / Mark as Unread (ديناميكي)
- ✅ Favorite / Unfavorite
- ✅ Mute / Unmute
- ✅ Move To (SubMenu)
- ✅ Copy Link (للعامة والخاصة فقط)
- ✅ **Add Members** (بصلاحية)
- ✅ **Open in New Window** (Desktop App)
- ✅ Leave Channel / Close Conversation

**Flutter** `channel_context_menu.dart`:
- ✅ Favorite / Unfavorite
- ✅ Move To
- ✅ Mute / Unmute
- ✅ **Notifications** (غير موجود في webapp sidebar_channel_menu!) ← Flutter لديه ما زاد
- ✅ Copy Link (لكن URL خاطئ)
- ✅ View Info
- ✅ Edit Channel
- ✅ Leave / Archive
- ❌ **Mark as Read/Unread مفقود**
- ❌ **Add Members مفقود**
- ❌ **Open in New Window مفقود**

---

## 🟢 ما أنجزه Flutter بشكل صحيح

| الميزة | الحالة |
|---|---|
| هيكل الفئات (favorites, channels, direct) | ✅ |
| أنيميشن الطي/فك الطي 180ms | ✅ |
| تمييز القناة المُختارة (خلفية + border) | ✅ |
| قائمة الـ ⋯ عند التمرير | ✅ |
| شارة المنشنات (mention badge) | ✅ |
| نقطة unread الصغيرة | ✅ |
| حالة المستخدم (online/away/dnd/offline) | ✅ |
| Quick Switcher | ✅ |
| Context Menu عند النقر اليميني | ✅ |
| Drag & Drop للقنوات داخل فئة | ✅ (جزئياً) |
| SidebarHeader — Team Name + Add Menu | ✅ (جزئياً) |
| إنشاء قناة جديدة | ✅ |
| مغادرة قناة مع تأكيد | ✅ |
| أرشفة قناة | ✅ |

---

## 📊 ملخص الأولويات

### أولوية 1 — حرجة (تأثر مباشر على الوظيفة الأساسية)
1. إصلاح رابط DM (`messages/@username`) و GM (`messages/channelName`)
2. إضافة دعم قناة GM (GroupMessage) مع الأيقونة والرابط الصحيح
3. إصلاح منطق Drag & Drop لـ DM (استخدام DragTarget)
4. إضافة `DraggingStateTypes` لمنع السحب غير المسموح به
5. إصلاح `_copyLink` — إزالة `/api/v4` من URL

### أولوية 2 — مهمة (تأثر على UX)
6. إضافة Unread Channel Indicators (أعلى/أسفل)
7. دعم Category Sorting (Alphabetical/Recency/Manual)
8. حفظ حالة الطي على الخادم
9. Mark as Read/Unread للقناة والفئة
10. إضافة التمييز البصري للقنوات المكتومة
11. إضافة "(you)" لمحادثة النفس

### أولوية 3 — تكميلية
12. Keyboard shortcuts (Alt+↑↓, Ctrl+Shift+U, Shift+Esc)
13. Tooltip عند اقتطاع اسم القناة
14. Add Members في قائمة القناة
15. Invite Members Button في فئة DM
16. دعم Managed Categories (نوع خاص من الـ categories)
17. Unread Filter (لوحة تحكم منفصلة)
18. Data Prefetch
19. Join Request Counts Sync
