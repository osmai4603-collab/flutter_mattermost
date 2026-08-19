# خطة تطبيق: إضافة عضو في الفريق (Add Team Member)

## نظرة عامة
تطبيق ميزة إضافة عضو في الفريق مطابقة لـ Mattermost webapp.
**المسار:** `POST /api/v4/teams/{team_id}/members` مع `{"team_id": "...", "user_id": "..."}`

---

## الخطوة 1: تحديث Repository (Domain Layer)

### 1.1 تحديث `team_repository.dart` (الواجهة المجردة)
**الملف:** `lib/features/teams/domain/repositories/team_repository.dart`
- إضافة method: `Future<TeamMemberEntity> addToTeam(String teamId, String userId)`
- إضافة method: `Future<List<TeamMemberEntity>> addUsersToTeam(String teamId, List<String> userIds)`

### 1.2 تحديث `team_repository_impl.dart` (التنفيذ)
**الملف:** `lib/features/teams/data/repositories/team_repository_impl.dart`
- تنفيذ `addToTeam` عبر `_remoteDataSource.addToTeam(teamId, userId)`
- تنفيذ `addUsersToTeam` عبر `_remoteDataSource.addUsersToTeam(teamId, userIds)`
- ملاحظة: نحتاج حقن `TeamMembersRemoteDataSource` بدلاً من `TeamsRemoteDataSource`

---

## الخطوة 2: تحديث BLoC (Presentation Layer)

### 2.1 تحديث `team_bloc.dart`
**الملف:** `lib/features/teams/presentation/bloc/team_bloc.dart`
- إضافة Event: `AddTeamMemberEvent(String teamId, String userId)`
- إضافة Event: `AddTeamMembersEvent(String teamId, List<String> userIds)`
- إضافة State: `TeamMemberAddedState(TeamMemberEntity member)`
- إضافة handler: `_onAddTeamMember` - يستدعي repository ثم يعيد تحميل الأعضاء

---

## الخطوة 3: إنشاء Modal لإضافة الأعضاء (UI)

### 3.1 إنشاء `add_team_members_modal.dart`
**الملف:** `lib/features/teams/presentation/modals/add_team_members_modal.dart`
- نافذة منبثقة مطابقة لـ `AddChannelMembersModal`
- **المكونات:**
  - حقل بحث للمستخدمين (username, email, name)
  - قائمة مستخدمي الفريق الحاليين (للاستبعاد)
  - قائمة مرشحين من جميع المستخدمين في السيرفر (NOT in team)
  - اختيار متعدد (checkboxes)
  - زر "Add" لتنفيذ الإضافة
- **المنطق:**
  - تحميل أعضاء الفريق الحاليين عبر `TeamRepository.getTeamMembers()`
  - تحميل جميع المستخدمين عبر `UserRepository.getProfilesInTeam()` أو `searchUsers()`
  - استبعاد الأعضاء الحاليين من القائمة
  - عند الضغط على Add: استدعاء `TeamRepository.addToTeam()` لكل مستخدم محدد
  - إغلاق النافذة وإظهار رسالة نجاح

### 3.2 التكرار والأنماط المستخدمة
- نفس نمط `AddChannelMembersModal` (GenericModal + search + checkbox list)
- نفس نمط `TeamSettingsModal` (Same theme, tokens, responsive)
- استخدام `getIt<TeamRepository>()` و `getIt<UserRepository>()` مباشرة (نمط_admin)

---

## الخطوة 4: ربط الـ Modal بالواجهة

### 4.1 إضافة زر في Team Settings Modal
**الملف:** `lib/features/teams/presentation/modals/team_settings_modal.dart`
- إضافة تبويب "Members" في `_TeamSettingsSidebar`
- عرض قائمة الأعضاء الحاليين مع زر "+ Add Members"
- عند الضغط على الزر: فتح `AddTeamMembersModal`

---

## الملفات المتأثرة

| الملف | التغيير |
|-------|---------|
| `lib/features/teams/domain/repositories/team_repository.dart` | إضافة `addToTeam`, `addUsersToTeam` |
| `lib/features/teams/data/repositories/team_repository_impl.dart` | تنفيذ Methods الجديدة |
| `lib/features/teams/presentation/bloc/team_bloc.dart` | إضافة Events, States, Handlers |
| `lib/features/teams/presentation/modals/add_team_members_modal.dart` | **ملف جديد** - Modal إضافة الأعضاء |
| `lib/features/teams/presentation/modals/team_settings_modal.dart` | إضافة تبويب Members |

---

## التحقق
- `flutter analyze` يجب أن يمر بدون أخطاء
- `flutter build` يجب أن ينجح
- اختبار يدوي: فتح Team Settings → تبويب Members → Add Members → بحث واختيار → Add → تحقق من الإضافة
