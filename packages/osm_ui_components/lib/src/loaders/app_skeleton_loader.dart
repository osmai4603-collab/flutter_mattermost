import 'package:flutter/material.dart';

/// ============================================================================
/// [أداة #9]: عناصر التحميل الهيكلي (AppSkeletonLoader)
/// ============================================================================
/// المقابل لـ `skeleton_loader/skeleton_loader.tsx` في Mattermost Webapp.
/// 
/// توفر ويدجت هيكلية نبضية ناعمة (Pulse Animation) كبديل بصري جذاب أثناء انتظار
/// جلب وتصيير الرسائل، القنوات، أو الصور، مما يمنع تجمد الشاشة أو إظهار دوائر تحميل جافة.
class AppSkeletonLoader extends StatefulWidget {
  /// [width]: عرض عنصر التحميل الهيكلي بالبكسل (مطلوب).
  /// الغرض: محاكاة عرض العنصر القادم (مثل سطر نصي أو صورة).
  final double width;

  /// [height]: ارتفاع عنصر التحميل الهيكلي بالبكسل (مطلوب).
  /// الغرض: محاكاة ارتفاع المستطيل أو الدائرة المراد تحميلها.
  final double height;

  /// [borderRadius]: انحناء حواف المستطيل الهيكلي (الافتراضي: 8.0).
  /// الغرض: جعل حواف النبض مستديرة ومطابقة لعناصر التصميم.
  final double borderRadius;

  /// [isCircle]: هل العنصر الهيكلي دائري الشكل؟ (الافتراضي: false).
  /// الغرض: استخدام الشكل الدائري عند انتظار تحميل الصور الشخصية (Avatars).
  final bool isCircle;

  const AppSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.isCircle = false,
  });

  @override
  State<AppSkeletonLoader> createState() => _AppSkeletonLoaderState();
}

class _AppSkeletonLoaderState extends State<AppSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius:
                  widget.isCircle ? null : BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}
