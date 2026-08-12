import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/export_list_entry_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/import_list_entry_model.dart';

abstract class AdminImportsExportsDataSource {
  Future<List<ImportListEntryModel>> listImports();
  Future<void> createImport(String importName, {required String filePath});
  Future<void> deleteImport(String importName);
  Future<List<ExportListEntryModel>> listExports();
  Future<void> downloadExport(String exportName, String savePath);
  Future<Map<String, dynamic>> getExportPresignUrl(String exportName);
  Future<void> deleteExport(String exportName);
}

@LazySingleton(as: AdminImportsExportsDataSource)
class AdminImportsExportsDataSourceImpl
    implements AdminImportsExportsDataSource {
  final ApiClient _apiClient;

  AdminImportsExportsDataSourceImpl(this._apiClient);

  @override
  Future<List<ImportListEntryModel>> listImports() async {
    final result = await _apiClient.get<List<ImportListEntryModel>>(
      ImportsEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ImportListEntryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ImportListEntryModel>>) {
      return result.data;
    }
    throw Exception('Failed to list imports');
  }

  @override
  Future<void> createImport(
    String importName, {
    required String filePath,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await _apiClient.dio.post(
      ImportsEndPoint.byImportName(importName),
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to create import');
    }
  }

  @override
  Future<void> deleteImport(String importName) async {
    final result = await _apiClient.delete(
      ImportsEndPoint.byImportName(importName),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete import');
    }
  }

  @override
  Future<List<ExportListEntryModel>> listExports() async {
    final result = await _apiClient.get<List<ExportListEntryModel>>(
      ExportsEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ExportListEntryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ExportListEntryModel>>) {
      return result.data;
    }
    throw Exception('Failed to list exports');
  }

  @override
  Future<void> downloadExport(String exportName, String savePath) async {
    final response = await _apiClient.dio.download(
      ExportsEndPoint.byExportName(exportName),
      savePath,
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to download export');
    }
  }

  @override
  Future<Map<String, dynamic>> getExportPresignUrl(String exportName) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ExportsEndPoint.presignUrl(exportName),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get export presign url');
  }

  @override
  Future<void> deleteExport(String exportName) async {
    final result = await _apiClient.delete(
      ExportsEndPoint.byExportName(exportName),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete export $exportName');
    }
  }
}
