import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/permissions/permissions_provider.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';

/// يغلف مكوناً ويعرضه فقط إذا كان المستخدم يملك الصلاحية المطلوبة.
///
/// ```dart
/// PermissionGate(
///   permission: Permissions.manageIncomingWebhooks,
///   child: CreateWebhookButton(),
/// )
/// ```
///
/// عند عدم توفر معرّف مستخدم صريح، يُقرأ من سجل الخادم النشط في Drift.
class PermissionGate extends StatefulWidget {
  const PermissionGate({
    super.key,
    required this.permission,
    required this.child,
    this.resourceId,
    this.userId,
    this.fallback = const SizedBox.shrink(),
    this.loading = const SizedBox.shrink(),
  });

  final String permission;
  final String? resourceId;

  /// معرّف المستخدم — عند تركه فارغاً يُقرأ المستخدم النشط من السجل المحلي.
  final String? userId;
  final Widget child;
  final Widget fallback;
  final Widget loading;

  @override
  State<PermissionGate> createState() => _PermissionGateState();
}

class _PermissionGateState extends State<PermissionGate> {
  late final Future<bool> _permissionFuture;

  @override
  void initState() {
    super.initState();
    _permissionFuture = _resolvePermission();
  }

  Future<bool> _resolvePermission() async {
    final provider = getIt<PermissionsProvider>();
    final userId = widget.userId ?? await _currentUserId();
    if (userId.isEmpty) {
      return false;
    }
    return provider.hasPermission(
      userId: userId,
      permission: widget.permission,
      resourceId: widget.resourceId,
    );
  }

  Future<String> _currentUserId() async {
    final database = getIt<AppDatabase>();
    final rows = await database.select(database.servers).get();
    for (final row in rows) {
      final userId = row.currentUserId;
      if (userId != null && userId.isNotEmpty) {
        return userId;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _permissionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.loading;
        }
        if (snapshot.data != true) {
          return widget.fallback;
        }
        return widget.child;
      },
    );
  }
}
