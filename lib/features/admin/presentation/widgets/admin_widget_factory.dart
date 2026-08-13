import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';

typedef OnSettingChanged = void Function(String key, dynamic value);

class AdminWidgetFactory extends StatelessWidget {
  final AdminSettingFieldSchema schema;
  final dynamic currentValue;
  final bool isDisabled;
  final OnSettingChanged onChanged;

  const AdminWidgetFactory({
    super.key,
    required this.schema,
    required this.currentValue,
    required this.isDisabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (schema.type) {
      case AdminSettingType.boolSetting:
        final boolVal = (currentValue as bool?) ?? (schema.defaultValue as bool? ?? false);
        child = Switch(
          value: boolVal,
          onChanged: isDisabled ? null : (v) => onChanged(schema.key, v),
          activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
        );
        break;

      case AdminSettingType.textSetting:
        final textVal = (currentValue as String?) ?? (schema.defaultValue as String? ?? '');
        child = TextFormField(
          initialValue: textVal,
          enabled: !isDisabled,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: (v) => onChanged(schema.key, v),
          decoration: _inputDecoration(schema.placeholder),
        );
        break;

      case AdminSettingType.numberSetting:
      case AdminSettingType.unlimitedNumberSetting:
        final numVal = currentValue?.toString() ?? schema.defaultValue?.toString() ?? '';
        child = SizedBox(
          width: 140,
          child: TextFormField(
            initialValue: numVal,
            enabled: !isDisabled,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (v) => onChanged(schema.key, int.tryParse(v) ?? v),
            decoration: _inputDecoration(schema.placeholder ?? 'E.g.: 10'),
          ),
        );
        break;

      case AdminSettingType.dropdownSetting:
        final options = schema.options ?? [];
        final selectedVal = currentValue?.toString() ?? schema.defaultValue?.toString() ?? (options.isNotEmpty ? options.first.value : '');
        child = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF181825),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white12),
          ),
          child: DropdownButton<String>(
            value: options.any((o) => o.value == selectedVal) ? selectedVal : (options.isNotEmpty ? options.first.value : null),
            dropdownColor: const Color(0xFF181825),
            underline: const SizedBox(),
            isExpanded: true,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: isDisabled ? null : (v) {
              if (v != null) onChanged(schema.key, v);
            },
            items: options.map((opt) {
              return DropdownMenuItem<String>(
                value: opt.value,
                child: Text(opt.displayName),
              );
            }).toList(),
          ),
        );
        break;

      case AdminSettingType.colorSetting:
        final colorHex = (currentValue as String?) ?? (schema.defaultValue as String? ?? '#000000');
        child = Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _parseHexColor(colorHex),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                initialValue: colorHex,
                enabled: !isDisabled,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                onChanged: (v) => onChanged(schema.key, v),
                decoration: _inputDecoration('#FFFFFF'),
              ),
            ),
          ],
        );
        break;

      case AdminSettingType.bannerSetting:
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  schema.label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        );

      default:
        final val = currentValue?.toString() ?? '';
        child = TextFormField(
          initialValue: val,
          enabled: !isDisabled,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          onChanged: (v) => onChanged(schema.key, v),
          decoration: _inputDecoration(schema.placeholder),
        );
    }

    return AdminSettingField(
      label: schema.label,
      description: schema.helpText,
      child: child,
    );
  }

  InputDecoration _inputDecoration(String? placeholder) {
    return InputDecoration(
      hintText: placeholder,
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF181825),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
    } catch (_) {}
    return Colors.blueAccent;
  }
}
