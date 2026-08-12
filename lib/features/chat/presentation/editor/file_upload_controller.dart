import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_draft.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';

/// ملف مُختار للرفع (من منتقي الملفات أو drag/drop).
class FileUploadItem {
  final String path;
  final String name;
  final int size;
  final String mimeType;

  const FileUploadItem({
    required this.path,
    required this.name,
    required this.size,
    this.mimeType = 'application/octet-stream',
  });
}

/// مدير رفع الملفات — نظير use_upload_files + file_upload.tsx في webapp.
///
/// المسؤوليات:
/// - اختيار الملفات (FilePicker) + drag/drop + paste
/// - حدود العدد (MAX_UPLOAD_FILES = 10) والحجم (maxFileSize من إعدادات الخادم)
/// - رفض الملفات الفارغة والكبيرة مع رسائل خطأ مجمّعة
/// - رفع فعلي عبر FilesRemoteDataSource مع نسبة تقدم + إلغاء (CancelToken)
/// - دمج النتائج في ComposerDraft (uploadsInProgress → fileInfos مرتبة)
class FileUploadController extends ChangeNotifier {
  static const int maxUploadFiles = 10;

  final ComposerDraft draft;
  final FilesRemoteDataSource _filesDataSource;

  /// الحد الأقصى لحجم الملف (بايت) — يُضبط من إعدادات الخادم.
  int maxFileSizeBytes;

  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, StreamSubscription<dynamic>> _subs = {};
  bool _picking = false;
  String _lastError = '';

  /// آخر خطأ رفع (يُعرض في شريط حالة المحرر مثل serverError في webapp).
  String get lastError => _lastError;

  bool get isPicking => _picking;

  FileUploadController({
    required this.draft,
    required this._filesDataSource,
    this.maxFileSizeBytes = 104857600, // 100MB — الافتراضي في الخادم
  });

  void clearError() {
    if (_lastError.isEmpty) return;
    _lastError = '';
    notifyListeners();
  }

  /// يفتح منتقي الملفات ويرفع الاختيار.
  Future<void> pickFiles() async {
    if (_picking) return;
    _picking = true;
    notifyListeners();
    try {
      final result = await FilePicker.pickFiles(allowMultiple: true);
      if (result == null || result.files.isEmpty) return;
      final items = result.files
          .where((f) => f.path != null)
          .map(
            (f) => FileUploadItem(
              path: f.path!,
              name: f.name,
              size: f.size,
            ),
          )
          .toList();
      await uploadFiles(items);
    } catch (_) {
      _lastError = 'Failed to pick files';
      notifyListeners();
    } finally {
      _picking = false;
      notifyListeners();
    }
  }

  /// يُرفع قائمة ملفات (من منتقي/سحب/لصق) مع تطبيق القيود مثل file_upload.tsx.
  Future<void> uploadFiles(
    List<FileUploadItem> files, {
    AppLocalizations? l10n,
  }) async {
    if (files.isEmpty) return;
    clearError();

    final sorted = [...files]..sort(
      (a, b) => naturalCompare(a.name.toLowerCase(), b.name.toLowerCase()),
    );

    final uploadsRemaining = maxUploadFiles - draft.fileCount;
    var numUploads = 0;

    final tooLargeFiles = <FileUploadItem>[];
    final zeroFiles = <FileUploadItem>[];

    for (var i = 0;
        i < sorted.length && numUploads < uploadsRemaining;
        i++) {
      final file = sorted[i];
      if (file.size > maxFileSizeBytes) {
        tooLargeFiles.add(file);
        continue;
      }
      if (file.size == 0) {
        zeroFiles.add(file);
      }
      _startUpload(file);
      numUploads++;
    }

    final errors = <String>[];
    if (sorted.length > uploadsRemaining) {
      errors.add(
        l10n?.file_uploadLimited(maxUploadFiles) ??
            'Uploads limited to $maxUploadFiles files maximum. Please use additional posts for more files.',
      );
    }
    final maxMb = (maxFileSizeBytes / 1048576).toStringAsFixed(0);
    if (tooLargeFiles.length > 1) {
      final names = tooLargeFiles.map((f) => f.name).join(', ');
      errors.add(
        l10n?.file_uploadFilesAbove(names, maxMb) ??
            'Files above ${maxMb}MB could not be uploaded: $names',
      );
    } else if (tooLargeFiles.isNotEmpty) {
      final name = tooLargeFiles.first.name;
      errors.add(
        l10n?.file_uploadFileAbove(name, maxMb) ??
            'File above ${maxMb}MB could not be uploaded: $name',
      );
    }
    if (zeroFiles.length > 1) {
      final names = zeroFiles.map((f) => f.name).join(', ');
      errors.add(
        l10n?.file_uploadZeroBytesFiles(names) ??
            'You are uploading empty files: $names',
      );
    } else if (zeroFiles.isNotEmpty) {
      final name = zeroFiles.first.name;
      errors.add(
        l10n?.file_uploadZeroBytesFile(name) ??
            'You are uploading an empty file: $name',
      );
    }

    if (errors.isNotEmpty) {
      _lastError = errors.join(', ');
      notifyListeners();
    }
  }

  /// رفع ملف واحد مع تتبع التقدم ودعم الإلغاء.
  Future<void> _startUpload(FileUploadItem file) async {
    final clientId = generateClientId();
    final uploading = UploadingFile(
      clientId: clientId,
      name: file.name,
      size: file.size,
      localPath: file.path,
    );
    draft.addUploading(uploading);

    final cancelToken = CancelToken();
    _cancelTokens[clientId] = cancelToken;

    try {
      final fileInfos = await _filesDataSource.uploadFile(
        file.path,
        channelId: draft.channelId,
        clientId: clientId,
        cancelToken: cancelToken,
        onProgress: (sent, total) {
          if (total > 0) {
            draft.updateProgress(clientId, sent / total);
          }
        },
      );

      if (fileInfos.isEmpty) {
        throw Exception('No file infos returned for $clientId');
      }
      final info = _toEntity(fileInfos.first).copyWith(localPath: file.path);
      draft.completeUpload(uploading, info);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        draft.cancelUpload(clientId);
        return;
      }
      draft.failUpload(clientId);
      _reportSingleError(file.name);
    } catch (_) {
      draft.failUpload(clientId);
      _reportSingleError(file.name);
    } finally {
      _cancelTokens.remove(clientId);
    }
  }

  void _reportSingleError(String filename) {
    // أخطاء رفع فردية تُبلغ مرة واحدة دون تكرار نفس الرسالة.
    _lastError = 'Failed to upload file: $filename';
    notifyListeners();
  }

  /// إلغاء رفعة جارية (نظير cancelUpload في file_upload.tsx).
  void cancelUpload(String clientId) {
    _cancelTokens[clientId]?.cancel();
    _cancelTokens.remove(clientId);
    draft.cancelUpload(clientId);
  }

  /// إزالة مرفق من المعاينة: إلغاء الرفع إن كان جارياً،
  /// أو حذف المرفق المكتمل (نظير removePreview في use_upload_files.tsx).
  void removeFile(String idOrClientId) {
    final isUploading = draft.uploadsInProgress.any(
      (f) => f.clientId == idOrClientId,
    );
    if (isUploading) {
      cancelUpload(idOrClientId);
    } else {
      draft.removeFileInfo(idOrClientId);
    }
  }

  /// عدد الملفات المرتبطة (لتمكين/تعطيل زر الرفع).
  bool get canAddMore => draft.fileCount < maxUploadFiles;

  /// يرفع بايتات مباشرة (من الحافظة أو أي مصدر) — يكتبها في ملف مؤقت ثم يرفعها.
  Future<void> uploadFromBytes(
    Uint8List bytes, {
    required String name,
    String? mimeType,
  }) async {
    if (bytes.isEmpty) return;
    try {
      final dir = await getTemporaryDirectory();
      final safeName = name.replaceAll(RegExp(r'[^\w.\-]'), '_');
      final file = File('${dir.path}/$safeName');
      await file.writeAsBytes(bytes);
      await uploadFiles([
        FileUploadItem(
          path: file.path,
          name: safeName,
          size: bytes.length,
          mimeType: mimeType ?? 'application/octet-stream',
        ),
      ]);
    } catch (_) {
      _lastError = 'Failed to paste file';
      notifyListeners();
    }
  }

  /// لصق صورة من الحافظة إن وُجدت (Ctrl+V في المحرر) —
  /// لا يمنع لصق النص، ويتجاهل بصمت الحافظات النصية.
  Future<void> handlePaste() async {
    try {
      final bytes = await Pasteboard.image;
      if (bytes == null || bytes.isEmpty) return;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await uploadFromBytes(
        bytes,
        name: 'paste_$timestamp.png',
        mimeType: 'image/png',
      );
    } catch (_) {
      // فشل قراءة الحافظة — تجاهل بصمت.
    }
  }

  FileInfoEntity _toEntity(FileInfoModel dto) => FileInfoEntity(
    serverId: '',
    id: dto.id,
    postId: dto.postId,
    userId: dto.userId,
    name: dto.name,
    extension: dto.extension,
    size: dto.size,
    mimeType: dto.mimeType,
    width: dto.width,
    height: dto.height,
  );

  @override
  void dispose() {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    for (final sub in _subs.values) {
      sub.cancel();
    }
    _subs.clear();
    super.dispose();
  }
}
