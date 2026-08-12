import 'dart:math' as math;
import 'dart:ui';

Color parseHexColor(String hex) {
  var value = hex.trim();
  if (value.startsWith('#')) {
    value = value.substring(1);
  }
  if (value.length == 3) {
    value = value.split('').map((char) => '$char$char').join();
  }
  final raw = int.tryParse(value, radix: 16);
  if (raw == null || (value.length != 6 && value.length != 8)) {
    throw ArgumentError.value(hex, 'hex', 'Invalid hex color');
  }
  if (value.length == 8) {
    return Color.fromARGB(
      raw >> 24 & 0xFF,
      raw >> 16 & 0xFF,
      raw >> 8 & 0xFF,
      raw & 0xFF,
    );
  }
  return Color(0xFF000000 | raw);
}

String colorToHex(Color color) {
  final red = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
  final green = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
  final blue = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
  return '#$red$green$blue';
}

Color changeOpacity(Color color, double opacity) {
  return color.withValues(alpha: color.a * opacity);
}

Color blendColors(Color background, Color foreground, double opacity) {
  double blendChannel(double bg, double fg) =>
      ((1 - opacity) * bg) + (opacity * fg);
  return Color.from(
    alpha: blendChannel(background.a, foreground.a),
    red: blendChannel(background.r, foreground.r),
    green: blendChannel(background.g, foreground.g),
    blue: blendChannel(background.b, foreground.b),
  );
}

double _linearizeChannel(double value) {
  if (value <= 0.04045) {
    return value / 12.92;
  }
  return math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}

bool isDarkColor(Color color) {
  final redLuminance = _linearizeChannel(color.r);
  final greenLuminance = _linearizeChannel(color.g);
  final blueLuminance = _linearizeChannel(color.b);
  final colorLuminance =
      (0.2126 * redLuminance) +
      (0.7152 * greenLuminance) +
      (0.0722 * blueLuminance);
  return colorLuminance <= 0.179;
}

Color getContrastingSimpleColor(Color color) {
  return isDarkColor(color) ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
}
