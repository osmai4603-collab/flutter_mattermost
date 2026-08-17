import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/app/config/app_config.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

enum ProfileSize { sm, md, lg, xl }

/// رابط صورة المستخدم (يتطلب ترخيص — يقع الاحتياط على الأحرف الأولى عند الفشل).
String serverUserAvatarUrl(String userId) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/users/$userId/image';
}

const List<Color> avatarColors = [
  Color(0xFFC5087E), // {197, 8, 126, 255}
  Color(0xFFE3CF12), // {227, 207, 18, 255}
  Color(0xFF1CB569), // {28, 181, 105, 255}
  Color(0xFF23BCE0), // {35, 188, 224, 255}
  Color(0xFF7431C4), // {116, 49, 196, 255}
  Color(0xFFC5087E), // {197, 8, 126, 255}
  Color(0xFFC51313), // {197, 19, 19, 255}
  Color(0xFFFA8606), // {250, 134, 6, 255}
  Color(0xFFE3CF12), // {227, 207, 18, 255}
  Color(0xFF7BC947), // {123, 201, 71, 255}
  Color(0xFF1CB569), // {28, 181, 105, 255}
  Color(0xFF23BCE0), // {35, 188, 224, 255}
  Color(0xFF7431C4), // {116, 49, 196, 255}
  Color(0xFFC5087E), // {197, 8, 126, 255}
  Color(0xFFC51313), // {197, 19, 19, 255}
  Color(0xFFFA8606), // {250, 134, 6, 255}
  Color(0xFFE3CF12), // {227, 207, 18, 255}
  Color(0xFF7BC947), // {123, 201, 71, 255}
  Color(0xFF1CB569), // {28, 181, 105, 255}
  Color(0xFF23BCE0), // {35, 188, 224, 255}
  Color(0xFF7431C4), // {116, 49, 196, 255}
  Color(0xFFC5087E), // {197, 8, 126, 255}
  Color(0xFFC51313), // {197, 19, 19, 255}
  Color(0xFFFA8606), // {250, 134, 6, 255}
  Color(0xFFE3CF12), // {227, 207, 18, 255}
  Color(0xFF7BC947), // {123, 201, 71, 255}
];

/// صورة المستخدم مع الحالة (مطابقة components/profile_picture في webapp).
class ProfilePicture extends StatelessWidget {
  final String? userId;
  final String? avatarUrl;
  final String username;
  final UserStatus? status;
  final double size;
  final bool showStatus;

  const ProfilePicture({
    super.key,
    this.userId,
    this.avatarUrl,
    required this.username,
    this.status,
    this.size = 32,
    this.showStatus = false,
  });

  factory ProfilePicture.sm({
    String? userId,
    String? avatarUrl,
    required String username,
    UserStatus? status,
    bool showStatus = false,
  }) => ProfilePicture(
    userId: userId,
    avatarUrl: avatarUrl,
    username: username,
    status: status,
    size: 24,
    showStatus: showStatus,
  );

  factory ProfilePicture.md({
    String? userId,
    String? avatarUrl,
    required String username,
    UserStatus? status,
    bool showStatus = true,
  }) => ProfilePicture(
    userId: userId,
    avatarUrl: avatarUrl,
    username: username,
    status: status,
    size: 32,
    showStatus: showStatus,
  );

  factory ProfilePicture.lg({
    String? userId,
    String? avatarUrl,
    required String username,
    UserStatus? status,
  }) => ProfilePicture(
    userId: userId,
    avatarUrl: avatarUrl,
    username: username,
    status: status,
    size: 36,
    showStatus: true,
  );

  factory ProfilePicture.xl({
    String? userId,
    String? avatarUrl,
    required String username,
    UserStatus? status,
  }) => ProfilePicture(
    userId: userId,
    avatarUrl: avatarUrl,
    username: username,
    status: status,
    size: 72,
    showStatus: true,
  );

  Color _getAvatarColor(String? userId, String username) {
    final seedString = userId != null && userId.isNotEmpty ? userId : username;
    if (seedString.isEmpty) return const Color(0xFFC5087E);
    
    // FNV-1a 32-bit hash implementation
    int hash = 2166136261;
    final bytes = utf8.encode(seedString);
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    
    return avatarColors[hash % avatarColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final Widget picture = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getAvatarColor(userId, username),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: _resolve(avatarUrl!),
              fit: BoxFit.cover,
              placeholder: (_, _) => _initials(theme),
              errorWidget: (_, _, _) => _initials(theme),
            )
          : _initials(theme),
    );

    if (!showStatus || status == null) return picture;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        picture,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: _statusColor(theme, status!),
              border: Border.all(color: theme.centerChannelBg, width: 1.5),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Color _statusColor(MattermostColors theme, UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return theme.onlineIndicator;
      case UserStatus.away:
        return theme.awayIndicator;
      case UserStatus.dnd:
        return theme.dndIndicator;
      case UserStatus.offline:
        return theme.centerChannelColor.withValues(alpha: 0.3);
    }
  }

  String _resolve(String url) {
    if (url.startsWith('http')) return url;
    final base = AppConfig.defaultBaseUrl;
    if (url.startsWith('/')) return '$base$url';
    return '$base/$url';
  }

  Widget _initials(dynamic theme) {
    final initials = username.isEmpty
        ? '?'
        : username.length > 1
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
