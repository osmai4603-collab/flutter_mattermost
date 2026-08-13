import 'package:flutter/material.dart';

enum AdminSettingType {
  boolSetting,
  textSetting,
  numberSetting,
  unlimitedNumberSetting,
  dropdownSetting,
  radioSetting,
  colorSetting,
  fileUploadSetting,
  multiSelectSetting,
  userAutocompleteSetting,
  bannerSetting,
  jobsTableSetting,
  customSetting,
}

class AdminSettingOptionSchema {
  final String value;
  final String displayName;
  final String? helpText;

  const AdminSettingOptionSchema({
    required this.value,
    required this.displayName,
    this.helpText,
  });
}

class AdminSettingFieldSchema {
  final String key;
  final AdminSettingType type;
  final String label;
  final String? helpText;
  final String? placeholder;
  final List<AdminSettingOptionSchema>? options;
  final dynamic defaultValue;
  final bool Function(Map<String, dynamic> config)? isHidden;
  final bool Function(Map<String, dynamic> config)? isDisabled;

  const AdminSettingFieldSchema({
    required this.key,
    required this.type,
    required this.label,
    this.helpText,
    this.placeholder,
    this.options,
    this.defaultValue,
    this.isHidden,
    this.isDisabled,
  });
}

class AdminSubSectionSchema {
  final String id;
  final String name;
  final String resourceKey;
  final List<AdminSettingFieldSchema> settings;
  final bool isEnterprise;

  const AdminSubSectionSchema({
    required this.id,
    required this.name,
    required this.resourceKey,
    required this.settings,
    this.isEnterprise = false,
  });
}
