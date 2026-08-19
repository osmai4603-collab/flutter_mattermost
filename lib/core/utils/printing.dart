import 'dart:convert';
import 'package:flutter/rendering.dart';

void printMap({required String title, required Map<String, dynamic> data}) {
  debugPrint(
    '\n$title: \n  ${data.keys.map((e) => '$e: ${_split(data[e])}').join('\n  ')}',
  );
}

String getPrintMap(Map<String, dynamic> data, String spaces) {
  return '{\n$spaces${data.keys.map((e) => '$e: ${_split(data[e], spaces: spaces)}').join('\n$spaces')}\n${spaces.substring(0, spaces.length - 2)}}';
}

String _split(dynamic value, {String spaces = '  '}) {
  if (value is String) {
    if (value.startsWith('{')) {
      final json = jsonDecode(value) as Map<String, dynamic>;
      return json.isEmpty ? '{}' : getPrintMap(json, '$spaces  ');
    }
    return value.split('.').last;
  } else if (value is List) {
    if (value.isEmpty) {
      return '[]';
    } else if (value.first is Map) {
      return '[\n$spaces  ${value.map((e) => getPrintMap(e, '$spaces    '))}\n$spaces  ]';
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
    return value.isEmpty
        ? '{}'
        : getPrintMap(value as Map<String, dynamic>, '$spaces  ');
  } else {
    return value.toString();
  }
}
