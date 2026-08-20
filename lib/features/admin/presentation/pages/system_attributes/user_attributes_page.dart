import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

enum UserPropertyType { text, select, multiSelect, date, users, channels }

extension UserPropertyTypeExtension on UserPropertyType {
  String get displayName {
    switch (this) {
      case UserPropertyType.text:
        return 'Text';
      case UserPropertyType.select:
        return 'Select';
      case UserPropertyType.multiSelect:
        return 'Multi Select';
      case UserPropertyType.date:
        return 'Date';
      case UserPropertyType.users:
        return 'Users';
      case UserPropertyType.channels:
        return 'Channels';
    }
  }
}

class UserProperty {
  final String id;
  final String name;
  final String? displayName;
  final UserPropertyType type;
  final List<String> values;
  final bool visible;
  final int sortOrder;

  const UserProperty({
    required this.id,
    required this.name,
    this.displayName,
    this.type = UserPropertyType.text,
    this.values = const [],
    this.visible = true,
    this.sortOrder = 0,
  });

  UserProperty copyWith({
    String? id,
    String? name,
    String? displayName,
    UserPropertyType? type,
    List<String>? values,
    bool? visible,
    int? sortOrder,
  }) {
    return UserProperty(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      type: type ?? this.type,
      values: values ?? this.values,
      visible: visible ?? this.visible,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'type': type.name,
      'values': values,
      'visible': visible,
      'sortOrder': sortOrder,
    };
  }

  factory UserProperty.fromMap(Map<String, dynamic> map) {
    return UserProperty(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      displayName: map['displayName'] as String?,
      type: UserPropertyType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => UserPropertyType.text,
      ),
      values:
          (map['values'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      visible: map['visible'] as bool? ?? true,
      sortOrder: map['sortOrder'] as int? ?? 0,
    );
  }
}

/// صفحة إدارة خصائص المستخدم (User Attributes Page)
/// تسمح بإنشاء وتعديل وحذف الخصائص المخصصة للمستخدمين
/// التي تظهر في ملف المستخدم ويمكن استخدامها في سياسات التحكم في الوصول.
class UserAttributesPage extends StatefulWidget {
  const UserAttributesPage({super.key});

  @override
  State<UserAttributesPage> createState() => _UserAttributesPageState();
}

class _UserAttributesPageState extends State<UserAttributesPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  List<UserProperty> _properties = [];
  List<UserProperty> _originalProperties = [];
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final config = await _repository.getConfig();
      final propsData =
          (config['UserProperties'] as List<dynamic>?) ?? const [];
      final properties = propsData
          .map((e) => UserProperty.fromMap(e as Map<String, dynamic>))
          .toList();
      properties.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      if (mounted) {
        setState(() {
          _properties = properties;
          _originalProperties = properties.map((p) => p.copyWith()).toList();
          _hasChanges = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _checkChanges() {
    if (_properties.length != _originalProperties.length) {
      _hasChanges = true;
      return;
    }
    for (var i = 0; i < _properties.length; i++) {
      final current = _properties[i].toMap();
      final original = _originalProperties[i].toMap();
      if (current.toString() != original.toString()) {
        _hasChanges = true;
        return;
      }
    }
    _hasChanges = false;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final patch = {
        'UserProperties': _properties.map((p) => p.toMap()).toList(),
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        setState(() {
          _originalProperties = _properties.map((p) => p.copyWith()).toList();
          _hasChanges = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User attributes saved successfully'),
            backgroundColor: AppTheme.of(context).onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppTheme.of(context).errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _cancelChanges() {
    setState(() {
      _properties = _originalProperties.map((p) => p.copyWith()).toList();
      _hasChanges = false;
    });
  }

  void _addProperty() {
    final newId = 'property_${DateTime.now().millisecondsSinceEpoch}';
    final newProperty = UserProperty(
      id: newId,
      name: '',
      sortOrder: _properties.length,
    );
    _showPropertyDialog(newProperty, isNew: true);
  }

  void _showPropertyDialog(UserProperty property, {bool isNew = false}) {
    final nameController = TextEditingController(text: property.name);
    final displayNameController = TextEditingController(
      text: property.displayName ?? '',
    );
    UserPropertyType selectedType = property.type;
    final valuesController = TextEditingController(
      text: property.values.join(', '),
    );
    bool visible = property.visible;

    final colors = AppTheme.of(context);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: colors.centerChannelBg,
          title: Text(
            isNew ? 'Add User Attribute' : 'Edit User Attribute',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Name
                Text(
                  'Property Name *',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g.: department',
                    hintStyle: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: colors.mentionHighlightBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Display Name
                Text(
                  'Display Name',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: displayNameController,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g.: Department',
                    hintStyle: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 12,
                    ),
                    filled: true,
                    fillColor: colors.mentionHighlightBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Type Selector
                Text(
                  'Type',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.mentionHighlightBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                  ),
                  child: DropdownButton<UserPropertyType>(
                    value: selectedType,
                    dropdownColor: colors.mentionHighlightBg,
                    underline: const SizedBox(),
                    isExpanded: true,
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedType = val);
                      }
                    },
                    items: UserPropertyType.values.map((type) {
                      return DropdownMenuItem<UserPropertyType>(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Values (for select/multi-select types)
                if (selectedType == UserPropertyType.select ||
                    selectedType == UserPropertyType.multiSelect) ...[
                  Text(
                    'Values (comma-separated)',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: valuesController,
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g.: Engineering, Marketing, Sales',
                      hintStyle: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: colors.mentionHighlightBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Visibility Toggle
                SwitchListTile(
                  value: visible,
                  onChanged: (val) => setDialogState(() => visible = val),
                  activeThumbColor: colors.buttonBg,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Visible in Profile',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Show this attribute in user profiles',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
              ),
            ),
            FilledButton(
              onPressed: nameController.text.trim().isEmpty
                  ? null
                  : () {
                      final updated = property.copyWith(
                        name: nameController.text.trim(),
                        displayName:
                            displayNameController.text.trim().isNotEmpty
                            ? displayNameController.text.trim()
                            : null,
                        type: selectedType,
                        values: valuesController.text
                            .split(',')
                            .map((e) => e.trim())
                            .where((e) => e.isNotEmpty)
                            .toList(),
                        visible: visible,
                      );

                      setState(() {
                        if (isNew) {
                          _properties.add(updated);
                        } else {
                          final idx = _properties.indexWhere(
                            (p) => p.id == property.id,
                          );
                          if (idx != -1) _properties[idx] = updated;
                        }
                        _checkChanges();
                      });

                      Navigator.of(context).pop();
                    },
              style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
              child: Text(isNew ? 'Add' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProperty(UserProperty property) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.centerChannelBg,
        title: Text(
          'Delete Attribute',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${property.name}"? This action cannot be undone.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _properties.removeWhere((p) => p.id == property.id);
                _checkChanges();
              });
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colors.errorTextColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateProperty(UserProperty property) {
    final newId = 'property_${DateTime.now().millisecondsSinceEpoch}';
    final duplicate = property.copyWith(
      id: newId,
      name: '${property.name}_copy',
      displayName: property.displayName != null
          ? '${property.displayName} (Copy)'
          : null,
      sortOrder: _properties.length,
    );
    _showPropertyDialog(duplicate, isNew: true);
  }

  void _toggleVisibility(UserProperty property) {
    setState(() {
      final idx = _properties.indexWhere((p) => p.id == property.id);
      if (idx != -1) {
        _properties[idx] = _properties[idx].copyWith(
          visible: !_properties[idx].visible,
        );
        _checkChanges();
      }
    });
  }

  void _moveProperty(int oldIndex, int newIndex) {
    setState(() {
      final item = _properties.removeAt(oldIndex);
      _properties.insert(newIndex, item);
      for (var i = 0; i < _properties.length; i++) {
        _properties[i] = _properties[i].copyWith(sortOrder: i);
      }
      _checkChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header bar
        _buildHeader(context, colors),
        // Body
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colors.errorTextColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Error loading user attributes',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.54,
                          ),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Retry'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.buttonBg,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildContent(context, colors),
        ),
        // Save Changes Panel
        if (_hasChanges)
          SaveChangesPanel(
            isSaving: _isSaving,
            onSave: _save,
            onCancel: _cancelChanges,
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, MattermostColors colors) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border(
          bottom: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.table_chart_outlined, color: colors.buttonBg, size: 20),
          const SizedBox(width: 10),
          Text(
            'User Attributes',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, MattermostColors colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Text(
            'Configure user attributes',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Attributes will be shown in user profile and can be used in access control policies.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Add Attribute Button
          Row(
            children: [
              FilledButton.icon(
                onPressed: _addProperty,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Attribute'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.buttonBg,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_properties.isNotEmpty)
                Text(
                  '${_properties.length} attribute(s)',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.54),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Properties Table
          if (_properties.isEmpty)
            _buildEmptyState(colors)
          else
            _buildPropertiesTable(context, colors),
        ],
      ),
    );
  }

  Widget _buildEmptyState(MattermostColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_chart_outlined,
            color: colors.centerChannelColor.withValues(alpha: 0.24),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No user attributes defined',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create custom attributes to store additional information\nabout users. These can be used in access control policies.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.38),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _addProperty,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create First Attribute'),
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesTable(BuildContext context, MattermostColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.centerChannelBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              border: Border(
                bottom: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 24), // drag handle space
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Display Name',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Type',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Values',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'Visible',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 40), // actions space
              ],
            ),
          ),

          // Table Body - Reorderable List
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _properties.length,
            onReorderItem: (oldItem, newItem) {
              final oldIndex = _properties.indexWhere(
                (p) => p.id == oldItem.toString(),
              );
              final newIndex = _properties.indexWhere(
                (p) => p.id == newItem.toString(),
              );
              if (oldIndex != -1 && newIndex != -1) {
                _moveProperty(oldIndex, newIndex);
              }
            },
            proxyDecorator: (child, index, animation) {
              return Material(
                color: colors.buttonBg.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final property = _properties[index];
              return _buildPropertyRow(context, colors, property, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(
    BuildContext context,
    MattermostColors colors,
    UserProperty property,
    int index,
  ) {
    final isLast = index == _properties.length - 1;
    final valuesStr = property.values.isEmpty
        ? '-'
        : property.values.join(', ');

    return Container(
      key: ValueKey(property.id),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.08),
                ),
              ),
      ),
      child: Row(
        children: [
          // Drag handle
          Icon(
            Icons.drag_handle,
            color: colors.centerChannelColor.withValues(alpha: 0.24),
            size: 18,
          ),
          const SizedBox(width: 8),

          // Name
          Expanded(
            flex: 2,
            child: Text(
              property.name.isEmpty ? '(unnamed)' : property.name,
              style: TextStyle(
                color: property.name.isEmpty
                    ? colors.centerChannelColor.withValues(alpha: 0.38)
                    : colors.centerChannelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Display Name
          Expanded(
            flex: 2,
            child: Text(
              property.displayName ?? '-',
              style: TextStyle(
                color: property.displayName == null
                    ? colors.centerChannelColor.withValues(alpha: 0.38)
                    : colors.centerChannelColor.withValues(alpha: 0.70),
                fontSize: 13,
              ),
            ),
          ),

          // Type
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.buttonBg.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                property.type.displayName,
                style: TextStyle(
                  color: colors.buttonBg,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Values
          Expanded(
            flex: 2,
            child: Text(
              valuesStr,
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Visibility
          SizedBox(
            width: 50,
            child: Icon(
              property.visible ? Icons.visibility : Icons.visibility_off,
              color: property.visible
                  ? colors.onlineIndicator
                  : colors.centerChannelColor.withValues(alpha: 0.38),
              size: 16,
            ),
          ),

          // Actions Menu
          SizedBox(
            width: 40,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                size: 16,
              ),
              onSelected: (action) {
                switch (action) {
                  case 'edit':
                    _showPropertyDialog(property);
                    break;
                  case 'duplicate':
                    _duplicateProperty(property);
                    break;
                  case 'visibility':
                    _toggleVisibility(property);
                    break;
                  case 'delete':
                    _deleteProperty(property);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: colors.centerChannelColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(
                        Icons.content_copy,
                        size: 16,
                        color: colors.centerChannelColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Duplicate',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'visibility',
                  child: Row(
                    children: [
                      Icon(
                        property.visible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 16,
                        color: colors.centerChannelColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        property.visible ? 'Hide' : 'Show',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: colors.errorTextColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: colors.errorTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
