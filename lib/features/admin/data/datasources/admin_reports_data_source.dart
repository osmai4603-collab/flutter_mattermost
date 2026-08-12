import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

abstract class AdminReportsDataSource {
  Future<int> getUsersCount();
  Future<void> exportUsers({int page = 0, int perPage = 100, String? format});
  Future<Map<String, dynamic>> downloadSupportPacket();
  Future<Map<String, dynamic>> getPostsForReporting(
    Map<String, dynamic> params,
  );
  Future<Map<String, dynamic>> getUsersForReporting({
    String sortColumn = 'Username',
    String direction = 'next',
    String sortDirection = 'asc',
    int pageSize = 50,
    String? fromColumnValue,
    String? fromId,
    String dateRange = 'alltime',
    String? roleFilter,
    String? teamFilter,
    bool hasNoTeam = false,
    bool hideActive = false,
    bool hideInactive = false,
    String? searchTerm,
  });
}

@LazySingleton(as: AdminReportsDataSource)
class AdminReportsDataSourceImpl implements AdminReportsDataSource {
  final ApiClient _apiClient;

  AdminReportsDataSourceImpl(this._apiClient);

  @override
  Future<int> getUsersCount() async {
    final result = await _apiClient.get<int>(
      ReportsEndPoint.usersCount,
      fromJson: (json) => (json as num).toInt(),
    );
    if (result is ApiSuccess<int>) {
      return result.data;
    }
    throw Exception('Failed to get users report count');
  }

  @override
  Future<void> exportUsers({
    int page = 0,
    int perPage = 100,
    String? format,
  }) async {
    final response = await _apiClient.dio.get(
      ReportsEndPoint.usersExport,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (format != null) 'format': format,
      },
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to export users report');
    }
  }

  @override
  Future<Map<String, dynamic>> downloadSupportPacket() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SystemEndPoint.supportPacket,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to download support packet');
  }

  @override
  Future<Map<String, dynamic>> getPostsForReporting(
    Map<String, dynamic> params,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ReportsEndPoint.posts,
      data: params,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get posts for reporting');
  }

  @override
  Future<Map<String, dynamic>> getUsersForReporting({
    String sortColumn = 'Username',
    String direction = 'next',
    String sortDirection = 'asc',
    int pageSize = 50,
    String? fromColumnValue,
    String? fromId,
    String dateRange = 'alltime',
    String? roleFilter,
    String? teamFilter,
    bool hasNoTeam = false,
    bool hideActive = false,
    bool hideInactive = false,
    String? searchTerm,
  }) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ReportsEndPoint.users,
      queryParameters: {
        'sort_column': sortColumn,
        'direction': direction,
        'sort_direction': sortDirection,
        'page_size': pageSize,
        'date_range': dateRange,
        'has_no_team': hasNoTeam,
        'hide_active': hideActive,
        'hide_inactive': hideInactive,
        if (fromColumnValue != null && fromColumnValue.isNotEmpty)
          'from_column_value': fromColumnValue,
        if (fromId != null && fromId.isNotEmpty) 'from_id': fromId,
        if (roleFilter != null && roleFilter.isNotEmpty)
          'role_filter': roleFilter,
        if (teamFilter != null && teamFilter.isNotEmpty)
          'team_filter': teamFilter,
        if (searchTerm != null && searchTerm.isNotEmpty)
          'search_term': searchTerm,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get users for reporting');
  }
}
