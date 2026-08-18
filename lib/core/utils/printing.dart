import 'package:flutter/rendering.dart';

void printMap({required String title, required Map<String, dynamic> data}) {
  debugPrint(
    '\n$title: \n  ${data.keys.map((e) => '$e: ${_split(data[e])}').join('\n  ')}',
  );
}

String _split(dynamic value) {
  if (value is String) {
    return value.split('.').last;
  } else if (value is List) {
    if (value.isEmpty) {
      return '[]';
    } else if (value.first is Map) {
      return '[(Map<String, dynamic>) ${value.length} items]';
    } else if (value is List<String>) {
      if (value.length > 10) {
        return '[\n    ${value.join(',\n    ')}\n  ]';
      }
      return '[${value.join(', ')}]';
    } else if (value is List<Map>) {
      if (value.length > 10) {
        return '[${value.length} items]';
      }
      return '[${value.map((e) => e.toString()).join(', ')}]';
    } else if (value.length > 10) {
      return '[${value.length} items]';
    }
    return '[${value.map((e) => e.toString()).join(', ')}]';
  } else if (value is Map) {
    return '(Map<String, dynamic>)';
  } else {
    return value.toString();
  }
}
