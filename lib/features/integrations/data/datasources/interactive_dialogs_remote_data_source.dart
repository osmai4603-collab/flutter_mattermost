import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/integrations/data/models/dialog_lookup_option_model.dart';

abstract class InteractiveDialogsRemoteDataSource {
  Future<Map<String, dynamic>> executeDialogAction(
    Map<String, dynamic> payload,
  );
  Future<Map<String, dynamic>> submitDialog(Map<String, dynamic> payload);
  Future<Map<String, dynamic>> openDialog(Map<String, dynamic> payload);
  Future<List<DialogLookupOptionModel>> lookupDialog(
    Map<String, dynamic> payload,
  );
}

@LazySingleton(as: InteractiveDialogsRemoteDataSource)
class InteractiveDialogsRemoteDataSourceImpl
    implements InteractiveDialogsRemoteDataSource {
  final ApiClient _apiClient;

  InteractiveDialogsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> executeDialogAction(
    Map<String, dynamic> payload,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ActionsEndPoint.dialogsExecute,
      data: payload,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to execute dialog action');
  }

  @override
  Future<Map<String, dynamic>> submitDialog(
    Map<String, dynamic> payload,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ActionsEndPoint.dialogsSubmit,
      data: payload,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to submit interactive dialog');
  }

  @override
  Future<Map<String, dynamic>> openDialog(Map<String, dynamic> payload) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ActionsEndPoint.dialogsOpen,
      data: payload,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to open interactive dialog');
  }

  @override
  Future<List<DialogLookupOptionModel>> lookupDialog(
    Map<String, dynamic> payload,
  ) async {
    final result = await _apiClient.post<List<DialogLookupOptionModel>>(
      ActionsEndPoint.dialogsLookup,
      data: payload,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => DialogLookupOptionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<DialogLookupOptionModel>>) {
      return result.data;
    }
    throw Exception('Failed to lookup interactive dialog');
  }
}
