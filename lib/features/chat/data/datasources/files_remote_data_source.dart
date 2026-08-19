import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/auth/data/models/upload_session_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class FilesRemoteDataSource {
  Future<List<FileInfoModel>> uploadFile(
    String filePath, {
    required String channelId,
    String? clientId,
    CancelToken? cancelToken,
    void Function(int, int)? onProgress,
  });
  Future<Uint8List> getFile(String fileId);
  Future<Uint8List> getFileThumbnail(String fileId);
  Future<Uint8List> getFilePreview(String fileId);
  Future<Uint8List> getFilePublic(String fileId, {required String hash});
  Future<Map<String, String>> headFilePublic(
    String fileId, {
    required String hash,
  });
  Future<Uint8List> getImageByUrl(String url);
  Future<FileInfoModel> getFileInfo(String fileId);
  Future<Map<String, dynamic>> getFileLink(String fileId);
  Future<List<FileInfoModel>> getFilesForPost(String postId);
  Future<void> removeFile(String fileId);
  Future<UploadSessionModel> createUpload({
    required String channelId,
    required String filename,
    required int fileSize,
    List<String>? clientIds,
  });
  Future<FileInfoModel> uploadFileChunk(
    String uploadId,
    String filePath,
  );
  Future<List<FileInfoModel>> searchFilesInTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  );
  Future<List<FileInfoModel>> searchFilesAcrossAllTeams(
    Map<String, dynamic> searchParams,
  );

  // Missing operations from docs
  Future<Map<String, String>> headFile(String fileId);
  Future<Map<String, String>> headFilePreview(String fileId);
  Future<Map<String, String>> headFileThumbnail(String fileId);
}

@LazySingleton(as: FilesRemoteDataSource)
class FilesRemoteDataSourceImpl implements FilesRemoteDataSource {
  final ApiClient _apiClient;

  FilesRemoteDataSourceImpl(this._apiClient);

  Future<Uint8List> _downloadBytes(String endpoint) async {
    final response = await _apiClient.dio.get(
      endpoint,
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to download file from $endpoint');
    }
    return response.data as Uint8List;
  }

  @override
  Future<List<FileInfoModel>> uploadFile(
    String filePath, {
    required String channelId,
    String? clientId,
    CancelToken? cancelToken,
    void Function(int, int)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'channel_id': channelId,
      'client_ids': clientId ?? '',
      'files': [await MultipartFile.fromFile(filePath)],
    });
    final response = await _apiClient.dio.post(
      FilesEndPoint.root,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: onProgress,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to upload file');
    }
    final data = response.data as Map<String, dynamic>;
    final fileInfos = data['file_infos'] as List<dynamic>? ?? [];
    return fileInfos.map((e) => FileInfoModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Uint8List> getFile(String fileId) =>
      _downloadBytes(FilesEndPoint.byFileId(fileId));

  @override
  Future<Uint8List> getFileThumbnail(String fileId) =>
      _downloadBytes(FilesEndPoint.thumbnail(fileId));

  @override
  Future<Uint8List> getFilePreview(String fileId) =>
      _downloadBytes(FilesEndPoint.preview(fileId));

  @override
  Future<Uint8List> getFilePublic(
    String fileId, {
    required String hash,
  }) async {
    final response = await _apiClient.dio.get(
      FilesEndPoint.public(fileId),
      queryParameters: {'h': hash},
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to download public file $fileId');
    }
    return response.data as Uint8List;
  }

  @override
  Future<Map<String, String>> headFilePublic(
    String fileId, {
    required String hash,
  }) async {
    final response = await _apiClient.dio.head(
      FilesEndPoint.public(fileId),
      queryParameters: {'h': hash},
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to head public file $fileId');
    }
    return response.headers.map.map((key, values) => MapEntry(key, values.join(',')));
  }

  @override
  Future<Uint8List> getImageByUrl(String url) async {
    final response = await _apiClient.dio.get(
      ImageEndPoint.root,
      queryParameters: {'url': url},
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch image by url');
    }
    return response.data as Uint8List;
  }

  @override
  Future<FileInfoModel> getFileInfo(String fileId) async {
    final result = await _apiClient.get<FileInfoModel>(
      FilesEndPoint.info(fileId),
      fromJson: (json) => FileInfoModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<FileInfoModel>) {
      return result.data;
    }
    throw Exception('Failed to get info for file $fileId');
  }

  @override
  Future<Map<String, dynamic>> getFileLink(String fileId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      FilesEndPoint.link(fileId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get link for file $fileId');
  }

  @override
  Future<List<FileInfoModel>> getFilesForPost(String postId) async {
    final result = await _apiClient.get<List<FileInfoModel>>(
      PostsEndPoint.filesInfo(postId),
      fromJson: (json) => json == null
          ? const <FileInfoModel>[]
          : (json as List<dynamic>)
                .map((e) => FileInfoModel.fromMap(e as Map<String, dynamic>))
                .toList(),
    );
    if (result is ApiSuccess<List<FileInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to get files for post $postId');
  }

  @override
  Future<void> removeFile(String fileId) async {
    await _apiClient.delete(FilesEndPoint.byFileId(fileId));
  }

  @override
  Future<UploadSessionModel> createUpload({
    required String channelId,
    required String filename,
    required int fileSize,
    List<String>? clientIds,
  }) async {
    final result = await _apiClient.post<UploadSessionModel>(
      UploadsEndPoint.root,
      data: {
        'channel_id': channelId,
        'filename': filename,
        'file_size': fileSize,
        if (clientIds != null) 'client_ids': clientIds,
      },
      fromJson: (json) => UploadSessionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UploadSessionModel>) {
      return result.data;
    }
    throw Exception('Failed to create upload');
  }

  @override
  Future<FileInfoModel> uploadFileChunk(
    String uploadId,
    String filePath,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiClient.dio.post(
      UploadsEndPoint.byUploadId(uploadId),
      data: formData,
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to upload chunk to $uploadId');
    }
    return FileInfoModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<FileInfoModel>> searchFilesInTeam(
    String teamId,
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.get<List<FileInfoModel>>(
      TeamsEndPoint.filesSearch(teamId),
      queryParameters: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => FileInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<FileInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to search files in team $teamId');
  }

  @override
  Future<List<FileInfoModel>> searchFilesAcrossAllTeams(
    Map<String, dynamic> searchParams,
  ) async {
    final result = await _apiClient.post<List<FileInfoModel>>(
      FilesEndPoint.search,
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => FileInfoModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<FileInfoModel>>) {
      return result.data;
    }
    throw Exception('Failed to search files across all teams');
  }

  @override
  Future<Map<String, String>> headFile(String fileId) async {
    final response = await _apiClient.dio.head(FilesEndPoint.byFileId(fileId));
    return response.headers.map.map((key, values) => MapEntry(key, values.join(',')));
  }

  @override
  Future<Map<String, String>> headFilePreview(String fileId) async {
    final response = await _apiClient.dio.head(FilesEndPoint.preview(fileId));
    return response.headers.map.map((key, values) => MapEntry(key, values.join(',')));
  }

  @override
  Future<Map<String, String>> headFileThumbnail(String fileId) async {
    final response = await _apiClient.dio.head(FilesEndPoint.thumbnail(fileId));
    return response.headers.map.map((key, values) => MapEntry(key, values.join(',')));
  }
}
