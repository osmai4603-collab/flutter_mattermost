/// ============================================================================
/// مكتبة osm_ui_components
/// ============================================================================
/// حزمة مكونات بناء الواجهات المشتركة (Shared UI Building Blocks) المستنبطة
/// من معمارية Mattermost Webapp والمعدة للاستخدام في مشاريع Flutter.

library;

// 1. نظام الألوان والثيمات
export 'src/theme/compass_theme.dart';

// 2. إدارة المودال والحوارات المنبثقة
export 'src/modals/app_generic_dialog.dart';
export 'src/modals/app_modal_service.dart';

// 3. عناصر الإدخال والنماذج
export 'src/inputs/app_text_field.dart';
export 'src/inputs/app_autosize_textarea.dart';

// 4. الصور الشخصية ودبابيس حالة الاتصال
export 'src/avatar/app_user_status_badge.dart';
export 'src/avatar/app_user_avatar.dart';

// 5. البطاقات الطافية للمستخدمين
export 'src/popovers/app_user_profile_popover.dart';

// 6. التحميل الهيكلي (Skeleton / Shimmer)
export 'src/loaders/app_skeleton_loader.dart';

// 7. محرك القوائم الافتراضية عالية الأداء
export 'src/list/app_virtualized_list.dart';

// 8. محرر وشريط تنسيق النصوص الغنية
export 'src/editor/app_rich_text_editor.dart';
