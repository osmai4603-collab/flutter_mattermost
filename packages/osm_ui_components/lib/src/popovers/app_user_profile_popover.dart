import 'package:flutter/material.dart';
import '../avatar/app_user_avatar.dart';
import '../avatar/app_user_status_badge.dart';

/// ============================================================================
/// [أداة #8]: بطاقات معلومات المستخدم الطافية (AppUserProfilePopover)
/// ============================================================================
/// المقابل لـ `profile_popover/profile_popover.tsx` في Mattermost Webapp.
/// 
/// تغلف أي ويدجت (مثل اسم المستخدم أو صورته)، وعند الضغط عليها تفتح بطاقة طافية
/// تفاعلية (Floating Card) تعرض تفاصيل الملف الشخصي، البريد، شارة الاتصال، وزر الإجراءات
/// السريعة لإرسال رسالة مباشرة دون مغادرة الشاشة.
class AppUserProfilePopover extends StatefulWidget {
  /// [child]: المكون المستهدف الذي يتم النقر عليه لإظهار البطاقة الطافية.
  /// الغرض: توفير عنصر تفاعلي (مثل الاسم أو الصورة) يفتح البطاقة عند النقر.
  final Widget child;

  /// [username]: اسم المستخدم المعروض داخل البطاقة الطافية.
  /// الغرض: عرض اسم الحساب في ترويسة البطاقة الشخصية.
  final String username;

  /// [email]: البريد الإلكتروني للمستخدم.
  /// الغرض: إظهار بريد المستخدم للتواصل والتأكد من هويته.
  final String email;

  /// [avatarUrl]: رابط صورة الملف الشخصي من الشبكة (اختياري).
  /// الغرض: عرض صورة تكبيرية للمستخدم داخل البطاقة.
  final String? avatarUrl;

  /// [status]: حالة الاتصال الحالية (online, away, dnd, offline).
  /// الغرض: إظهار حالة المستخدم وحضور اللحظي داخل البطاقة.
  final UserStatus status;

  /// [onDirectMessage]: الدالة المطلوبة عند الضغط على زر "إرسال رسالة مباشرة".
  /// الغرض: توجيه المستخدم لفتح محادثة مباشرة مع الشخص المعروض.
  final VoidCallback? onDirectMessage;

  const AppUserProfilePopover({
    super.key,
    required this.child,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.status = UserStatus.online,
    this.onDirectMessage,
  });

  @override
  State<AppUserProfilePopover> createState() => _AppUserProfilePopoverState();
}

class _AppUserProfilePopoverState extends State<AppUserProfilePopover> {
  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) {
          return CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topLeft,
            offset: const Offset(8, 8),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                child: Container(
                  width: 280,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppUserAvatar(
                        username: widget.username,
                        imageUrl: widget.avatarUrl,
                        status: widget.status,
                        size: 64,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.username,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('إرسال رسالة مباشرة'),
                          onPressed: () {
                            _overlayController.hide();
                            if (widget.onDirectMessage != null) {
                              widget.onDirectMessage!();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () => _overlayController.toggle(),
          child: widget.child,
        ),
      ),
    );
  }
}
