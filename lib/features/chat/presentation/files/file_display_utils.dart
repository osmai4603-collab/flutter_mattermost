import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';

/// بناء رابط API لملف (أو مصغّرة/معاينة) على الخادم النشط.
String fileApiUrl(FileInfoEntity file, {String suffix = ''}) {
  final serverUrl = getIt<ServerManager>().activeServerUrl;
  return '$serverUrl/api/v4/files/${file.id}$suffix';
}

/// ترويسات توثيق Bearer لمكتبات تحميل الوسائط
/// (CachedNetworkImage، media_kit، ...). تُرجع خريطة فارغة عند غياب التوكن.
Future<Map<String, String>> authHeaders() async {
  final token = await getIt<SecureStorageService>().getAuthToken();
  if (token == null || token.isEmpty) return const {};
  return {'Authorization': 'Bearer $token'};
}

bool isImageExtension(String extension) {
  const set = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'svg'};
  return set.contains(extension.toLowerCase());
}

bool isImageFile(FileInfoEntity file) {
  final ext = file.extension.isNotEmpty
      ? file.extension
      : file.name.split('.').last.toLowerCase();
  if (isImageExtension(ext)) return true;
  if (file.mimeType.toLowerCase().startsWith('image/')) return true;
  if (file.hasPreviewImage) return true;
  if (file.width > 0 && file.height > 0) return true;
  return false;
}

bool isVideoExtension(String extension) {
  const set = {'mp4', 'webm', 'mov', 'm4v', 'mkv', 'avi', 'ogv', 'mpeg', 'mpg'};
  return set.contains(extension.toLowerCase());
}

bool isAudioExtension(String extension) {
  const set = {'mp3', 'wav', 'ogg', 'oga', 'flac', 'm4a', 'aac', 'opus', 'wma'};
  return set.contains(extension.toLowerCase());
}

bool isMediaExtension(String extension) =>
    isVideoExtension(extension) || isAudioExtension(extension);
