import 'package:flutter/foundation.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/draft_entity.dart';

/// ملف قيد الرفع ضمن المسودة (يظهر في المعاينة أثناء الرفع).
class UploadingFile {
  final String clientId;
  final String name;
  final int size;

  /// المسار المحلي للملف — يُستخدم لعرض معاينة مصغّرة أثناء الرفع.
  final String? localPath;
  double progress;

  UploadingFile({
    required this.clientId,
    required this.name,
    required this.size,
    this.localPath,
    this.progress = 0,
  });
}

/// مسودة الرسالة — نظير PostDraft في webapp
/// (webapp/channels/src/types/store/draft.ts).
///
/// تحمل الرسالة + الملفات المرفوعة + ملفات قيد الرفع،
/// وتُعلم المستمعين عند أي تغيير (ChangeNotifier).
class ComposerDraft extends ChangeNotifier {
  final String channelId;
  final String rootId;

  String _message = '';
  final List<FileInfoEntity> _fileInfos = [];
  final List<UploadingFile> _uploadsInProgress = [];
  int createAt = 0;
  int updateAt = 0;

  ComposerDraft({required this.channelId, this.rootId = ''});

  String get message => _message;

  /// الملفات المرفوعة بنجاح (مع info من الخادم).
  List<FileInfoEntity> get fileInfos => List.unmodifiable(_fileInfos);

  /// معرفات clientIds للرفع الجاري.
  List<UploadingFile> get uploadsInProgress =>
      List.unmodifiable(_uploadsInProgress);

  int get fileCount => _fileInfos.length + _uploadsInProgress.length;

  bool get isEmpty => _message.trim().isEmpty && fileCount == 0;

  bool get hasUploadsInProgress => _uploadsInProgress.isNotEmpty;

  List<String> get fileIds => _fileInfos.map((f) => f.id).toList();

  void setMessage(String value) {
    if (_message == value) return;
    _message = value;
    updateAt = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void addUploading(UploadingFile file) {
    _uploadsInProgress.add(file);
    updateAt = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void updateProgress(String clientId, double progress) {
    for (final f in _uploadsInProgress) {
      if (f.clientId == clientId) {
        f.progress = progress;
        notifyListeners();
        return;
      }
    }
  }

  /// اكتمال الرفع: نقل الملف من "قيد الرفع" إلى المرفقات (مرتبة بالاسم).
  void completeUpload(UploadingFile file, FileInfoEntity info) {
    _uploadsInProgress.removeWhere((f) => f.clientId == file.clientId);
    _fileInfos.removeWhere((f) => f.id == info.id);
    _fileInfos.add(info);
    _sortFileInfos();
    updateAt = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void failUpload(String clientId) {
    _uploadsInProgress.removeWhere((f) => f.clientId == clientId);
    updateAt = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void cancelUpload(String clientId) => failUpload(clientId);

  /// إزالة مرفق مكتمل (بالـ id أو clientId).
  void removeFileInfo(String idOrClientId) {
    final before = _fileInfos.length;
    _fileInfos.removeWhere(
      (f) => f.id == idOrClientId || f.userId == idOrClientId,
    );
    if (_fileInfos.length == before) return;
    updateAt = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void clear() {
    _message = '';
    _fileInfos.clear();
    _uploadsInProgress.clear();
    createAt = 0;
    updateAt = 0;
    notifyListeners();
  }

  void _sortFileInfos() {
    _fileInfos.sort(
      (a, b) => naturalCompare(a.name.toLowerCase(), b.name.toLowerCase()),
    );
  }

  DraftEntity toEntity() {
    return DraftEntity(
      channelId: channelId,
      rootId: rootId,
      message: _message,
      fileIds: fileIds,
      updateAt: updateAt,
    );
  }

  void fromEntity(DraftEntity entity) {
    _message = entity.message;
    updateAt = entity.updateAt;
    // We can also load files if supported
    notifyListeners();
  }
}
