import 'package:flutter/material.dart';

class AppFonts {
  static const String notoNaskhArabic = 'NotoNaskhArabic';
  static const menlo = 'Menlo';
  static const monaco = 'Monaco';
  static const consolas = 'Consolas';
  static const courierNew = 'Couries New';

  static const TextStyle monospace = TextStyle(
    fontFamilyFallback: ['Menlo', 'Monaco', 'Consolas', 'Courier New'],
  );
}
