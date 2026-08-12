import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_value_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_field_model.dart';

abstract class AdminCustomPropertiesDataSource {
  Future<List<CustomAttributeFieldModel>> getCustomAttributesFields({
    int page = 0,
    int perPage = 60,
  });
  Future<CustomAttributeFieldModel> getCustomProfileField(String fieldId);
  Future<CustomAttributeFieldModel> createCustomProfileField(
    Map<String, dynamic> field,
  );
  Future<CustomAttributeFieldModel> updateCustomProfileField({
    required String fieldId,
    Map<String, dynamic>? renameOrg,
  });
  Future<void> deleteCustomProfileField(String fieldId);
  Future<List<CustomAttributeValueModel>> getCustomAttributeValues({String? userId});
  Future<bool> featureEnabled();
  Future<List<CustomAttributeFieldModel>> searchGroupFields(
    String groupName,
    String query,
  );
  Future<List<CustomAttributeFieldModel>> getGroupFields(
    String groupName,
    String objectType,
  );
  Future<CustomAttributeFieldModel> createGroupField(
    String groupName,
    String objectType,
    Map<String, dynamic> field,
  );
  Future<CustomAttributeFieldModel> updateGroupField(
    String groupName,
    String objectType,
    String fieldId,
    Map<String, dynamic> patch,
  );
  Future<void> deleteGroupField(
    String groupName,
    String objectType,
    String fieldId,
  );
  Future<Map<String, dynamic>> getGroupValues(
    String groupName,
    String objectType,
    String targetId,
  );
  Future<Map<String, dynamic>> setGroupValues(
    String groupName,
    String objectType,
    String targetId,
    Map<String, dynamic> values,
  );
  Future<Map<String, dynamic>> getSystemGroupValues(String groupName);
  Future<Map<String, dynamic>> getCPAGroup();

  // Missing operations from docs
  Future<CustomAttributeFieldModel> patchCPAField(String fieldId, Map<String, dynamic> patch);
  Future<void> patchCPAValues(Map<String, dynamic> values);
  Future<void> patchCPAValuesForUser(String userId, Map<String, dynamic> values);
}

@LazySingleton(as: AdminCustomPropertiesDataSource)
class AdminCustomPropertiesDataSourceImpl
    implements AdminCustomPropertiesDataSource {
  final ApiClient _apiClient;

  AdminCustomPropertiesDataSourceImpl(this._apiClient);

  @override
  Future<List<CustomAttributeFieldModel>> getCustomAttributesFields({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<CustomAttributeFieldModel>>(
      CustomProfileAttributesEndPoint.fields,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              CustomAttributeFieldModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeFieldModel>>) {
      return result.data;
    }
    throw Exception('Failed to get custom profile attributes');
  }

  @override
  Future<CustomAttributeFieldModel> getCustomProfileField(String fieldId) async {
    final result = await _apiClient.get<CustomAttributeFieldModel>(
      CustomProfileAttributesEndPoint.fields2(fieldId),
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to get custom profile field');
  }

  @override
  Future<CustomAttributeFieldModel> createCustomProfileField(
    Map<String, dynamic> field,
  ) async {
    final result = await _apiClient.post<CustomAttributeFieldModel>(
      CustomProfileAttributesEndPoint.fields,
      data: field,
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to create custom profile field');
  }

  @override
  Future<CustomAttributeFieldModel> updateCustomProfileField({
    required String fieldId,
    Map<String, dynamic>? renameOrg,
  }) async {
    final result = await _apiClient.put<CustomAttributeFieldModel>(
      CustomProfileAttributesEndPoint.fields2(fieldId),
      data: renameOrg,
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to update custom profile field');
  }

  @override
  Future<void> deleteCustomProfileField(String fieldId) async {
    final result = await _apiClient.delete(
      CustomProfileAttributesEndPoint.fields2(fieldId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete custom profile field');
    }
  }

  @override
  Future<List<CustomAttributeValueModel>> getCustomAttributeValues({
    String? userId,
  }) async {
    final result = await _apiClient.get<List<CustomAttributeValueModel>>(
      CustomProfileAttributesEndPoint.values,
      queryParameters: {if (userId != null) 'user_id': userId},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => CustomAttributeValueModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeValueModel>>) {
      return result.data;
    }
    throw Exception('Failed to get custom attribute values');
  }

  @override
  Future<bool> featureEnabled() async {
    final result = await _apiClient.get<bool>(
      CustomProfileAttributesEndPoint.base,
      fromJson: (json) => json == true,
    );
    if (result is ApiSuccess<bool>) {
      return result.data;
    }
    return false;
  }

  @override
  Future<List<CustomAttributeFieldModel>> searchGroupFields(
    String groupName,
    String query,
  ) async {
    final result = await _apiClient.get<List<CustomAttributeFieldModel>>(
      PropertiesEndPoint.groupsFieldsSearch(groupName),
      queryParameters: {'search_term': query},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              CustomAttributeFieldModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeFieldModel>>) {
      return result.data;
    }
    throw Exception('Failed to search group fields');
  }

  @override
  Future<List<CustomAttributeFieldModel>> getGroupFields(
    String groupName,
    String objectType,
  ) async {
    final result = await _apiClient.get<List<CustomAttributeFieldModel>>(
      PropertiesEndPoint.groupsFields(groupName, objectType),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              CustomAttributeFieldModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeFieldModel>>) {
      return result.data;
    }
    throw Exception('Failed to get group fields');
  }

  @override
  Future<CustomAttributeFieldModel> createGroupField(
    String groupName,
    String objectType,
    Map<String, dynamic> field,
  ) async {
    final result = await _apiClient.post<CustomAttributeFieldModel>(
      PropertiesEndPoint.groupsFields(groupName, objectType),
      data: field,
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to create group field');
  }

  @override
  Future<CustomAttributeFieldModel> updateGroupField(
    String groupName,
    String objectType,
    String fieldId,
    Map<String, dynamic> patch,
  ) async {
    final result = await _apiClient.put<CustomAttributeFieldModel>(
      PropertiesEndPoint.groupsFields2(groupName, objectType, fieldId),
      data: patch,
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to update group field');
  }

  @override
  Future<void> deleteGroupField(
    String groupName,
    String objectType,
    String fieldId,
  ) async {
    final result = await _apiClient.delete(
      PropertiesEndPoint.groupsFields2(groupName, objectType, fieldId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete group field');
    }
  }

  @override
  Future<Map<String, dynamic>> getGroupValues(
    String groupName,
    String objectType,
    String targetId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PropertiesEndPoint.groupsValues(groupName, objectType, targetId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get group values');
  }

  @override
  Future<Map<String, dynamic>> setGroupValues(
    String groupName,
    String objectType,
    String targetId,
    Map<String, dynamic> values,
  ) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      PropertiesEndPoint.groupsValues(groupName, objectType, targetId),
      data: values,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to set group values');
  }

  @override
  Future<Map<String, dynamic>> getSystemGroupValues(String groupName) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      PropertiesEndPoint.groupsSystemValues(groupName),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get system group values');
  }

  @override
  Future<Map<String, dynamic>> getCPAGroup() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      CustomProfileAttributesEndPoint.group,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get custom profile attributes group');
  }

  @override
  Future<CustomAttributeFieldModel> patchCPAField(String fieldId, Map<String, dynamic> patch) async {
    final result = await _apiClient.patch<CustomAttributeFieldModel>(
      CustomProfileAttributesEndPoint.fields2(fieldId),
      data: patch,
      fromJson: (json) => CustomAttributeFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<CustomAttributeFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to patch custom profile field');
  }

  @override
  Future<void> patchCPAValues(Map<String, dynamic> values) async {
    await _apiClient.patch<void>(
      CustomProfileAttributesEndPoint.values,
      data: values,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> patchCPAValuesForUser(String userId, Map<String, dynamic> values) async {
    await _apiClient.patch<void>(
      UsersEndPoint.customProfileAttributes(userId),
      data: values,
      fromJson: (_) {},
    );
  }
}
