import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/admin/data/models/scheme_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';

abstract class SchemesRemoteDataSource {
  Future<List<SchemeModel>> getSchemes({
    String? scope,
    int page = 0,
    int perPage = 60,
  });
  Future<SchemeModel> createScheme({
    required String name,
    String? displayName,
    String? description,
    String? scope,
  });
  Future<SchemeModel> getScheme(String schemeId);
  Future<SchemeModel> patchScheme(
    String schemeId, {
    String? name,
    String? displayName,
    String? description,
    String? scope,
  });
  Future<void> deleteScheme(String schemeId);
  Future<List<ChannelModel>> getSchemeChannels(String schemeId);
  Future<List<TeamModel>> getSchemeTeams(String schemeId);
}

@LazySingleton(as: SchemesRemoteDataSource)
class SchemesRemoteDataSourceImpl implements SchemesRemoteDataSource {
  final ApiClient _apiClient;

  SchemesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SchemeModel>> getSchemes({
    String? scope,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<SchemeModel>>(
      SchemesEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage, 'scope': scope},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SchemeModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SchemeModel>>) {
      return result.data;
    }
    throw Exception('Failed to get schemes');
  }

  @override
  Future<SchemeModel> createScheme({
    required String name,
    String? displayName,
    String? description,
    String? scope,
  }) async {
    final result = await _apiClient.post<SchemeModel>(
      SchemesEndPoint.root,
      data: {
        'name': name,
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (scope != null) 'scope': scope,
      },
      fromJson: (json) => SchemeModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SchemeModel>) {
      return result.data;
    }
    throw Exception('Failed to create scheme');
  }

  @override
  Future<SchemeModel> getScheme(String schemeId) async {
    final result = await _apiClient.get<SchemeModel>(
      SchemesEndPoint.bySchemeId(schemeId),
      fromJson: (json) => SchemeModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SchemeModel>) {
      return result.data;
    }
    throw Exception('Failed to get scheme');
  }

  @override
  Future<SchemeModel> patchScheme(
    String schemeId, {
    String? name,
    String? displayName,
    String? description,
    String? scope,
  }) async {
    final result = await _apiClient.put<SchemeModel>(
      SchemesEndPoint.patch(schemeId),
      data: {
        if (name != null) 'name': name,
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (scope != null) 'scope': scope,
      },
      fromJson: (json) => SchemeModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<SchemeModel>) {
      return result.data;
    }
    throw Exception('Failed to patch scheme');
  }

  @override
  Future<void> deleteScheme(String schemeId) async {
    final result = await _apiClient.delete(
      SchemesEndPoint.bySchemeId(schemeId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete scheme');
    }
  }

  @override
  Future<List<ChannelModel>> getSchemeChannels(String schemeId) async {
    final result = await _apiClient.get<List<ChannelModel>>(
      SchemesEndPoint.channels(schemeId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelModel>>) {
      return result.data;
    }
    throw Exception('Failed to get scheme channels');
  }

  @override
  Future<List<TeamModel>> getSchemeTeams(String schemeId) async {
    final result = await _apiClient.get<List<TeamModel>>(
      SchemesEndPoint.teams(schemeId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get scheme teams');
  }
}