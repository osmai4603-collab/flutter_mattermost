import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/common/data/models/checklist_item_model.dart';
import 'package:flutter_mattermost/features/common/data/models/condition_list_model.dart';
import 'package:flutter_mattermost/features/common/data/models/condition_model.dart';
import 'package:flutter_mattermost/features/common/data/models/error_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_autofollows_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_list_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_run_list_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_run_metadata_model.dart';
import 'package:flutter_mattermost/features/common/data/models/playbook_run_model.dart';
import 'package:flutter_mattermost/features/common/data/models/property_field_model.dart';
import 'package:flutter_mattermost/features/common/data/models/property_field_request_model.dart';
import 'package:flutter_mattermost/features/common/data/models/property_value_model.dart';
import 'package:flutter_mattermost/features/common/data/models/property_value_request_model.dart';
import 'package:flutter_mattermost/features/common/data/models/trigger_id_return_model.dart';

abstract class PlaybooksRemoteDataSource {
  Future<PlaybookListModel> getPlaybooks({
    required String teamId,
    int page = 0,
    int perPage = 60,
    String? sort,
    String? direction,
    bool? withArchived,
  });
  Future<PlaybookModel> getPlaybook(String id);
  Future<PlaybookRunModel> createPlaybookRunFromPost(
    Map<String, dynamic> payload,
  );
  Future<PlaybookRunModel> createPlaybookRunFromDialog(
    Map<String, dynamic> payload,
  );
  Future<PlaybookRunModel> getPlaybookRun(String id);
  Future<PlaybookRunModel> getPlaybookRunByChannelId(String channelId);
  Future<PlaybookRunMetadataModel> getPlaybookRunMetadata(String id);
  Future<PlaybookRunListModel> listPlaybookRuns({
    required String teamId,
    int page = 0,
    int perPage = 60,
    String? sort,
    String? direction,
    List<String>? statuses,
    String? ownerUserId,
    String? participantId,
    String? searchTerm,
    String? channelId,
    bool? omitEnded,
    int? since,
  });
  Future<ConditionListModel> getPlaybookConditions(String id);
  Future<ConditionListModel> getRunConditions(String id);
  Future<ConditionModel> createPlaybookCondition(
    String id,
    ConditionModel condition,
  );
  Future<ConditionModel> updatePlaybookCondition(
    String id,
    String conditionId,
    ConditionModel condition,
  );
  Future<PropertyFieldModel> createPlaybookPropertyField(
    String id,
    PropertyFieldRequestModel field,
  );
  Future<PropertyFieldModel> updatePlaybookPropertyField(
    String id,
    String fieldId,
    PropertyFieldRequestModel field,
  );
  Future<PropertyValueModel> setRunPropertyValue(
    String id,
    String fieldId,
    PropertyValueRequestModel value,
  );
  Future<TriggerIdReturnModel> itemRun(
    String id,
    int checklistId,
    int itemId,
  );
  Future<ErrorModel> addChecklistItem(
    String id,
    int checklistId,
    ChecklistItemModel item,
  );
  Future<PlaybookModel> updatePlaybook(String id, PlaybookModel playbook);
  Future<PlaybookAutofollowsModel> getAutoFollows(String id);

  // Missing operations from docs
  Future<void> changeOwner(String runId, String ownerId);
  Future<void> deletePlaybook(String id);
  Future<void> deletePlaybookCondition(String id, String conditionId);
  Future<void> deletePlaybookPropertyField(String id, String fieldId);
  Future<void> endPlaybookRun(String id);
  Future<void> endPlaybookRunDialog(String id, Map<String, dynamic> data);
  Future<void> finish(String runId);
  Future<List<String>> getChecklistAutocomplete(String id);
  Future<List<String>> getOwners({required String teamId});
  Future<List<PropertyFieldModel>> getPlaybookPropertyFields(String id);
  Future<void> nextStageDialog(String runId);
  Future<void> reoderChecklistItem(String id, int checklistId, int itemId, int newIndex);
  Future<void> reorderPlaybookPropertyFields(String id, List<String> fieldIds);
  Future<void> restartPlaybookRun(String id);
  Future<void> updatePlaybookRun(String id, Map<String, dynamic> run);
  Future<void> updatePlaybookRunStatus(String id, Map<String, dynamic> status);
  Future<List<dynamic>> getChannelActions(String channelId, {String triggerType = 'new_member_joins'});
}

@LazySingleton(as: PlaybooksRemoteDataSource)
class PlaybooksRemoteDataSourceImpl implements PlaybooksRemoteDataSource {
  final ApiClient _apiClient;

  PlaybooksRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PlaybookListModel> getPlaybooks({
    required String teamId,
    int page = 0,
    int perPage = 60,
    String? sort,
    String? direction,
    bool? withArchived,
  }) async {
    final result = await _apiClient.get<PlaybookListModel>(
      PlaybooksEndPoint.playbooks,
      queryParameters: {
        'team_id': teamId,
        'page': page,
        'per_page': perPage,
        if (sort != null) 'sort': sort,
        if (direction != null) 'direction': direction,
        if (withArchived != null) 'with_archived': withArchived,
      },
      fromJson: (json) =>
          PlaybookListModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookListModel>) {
      return result.data;
    }
    throw Exception('Failed to get playbooks');
  }

  @override
  Future<PlaybookModel> getPlaybook(String id) async {
    final result = await _apiClient.get<PlaybookModel>(
      PlaybooksEndPoint.playbook(id),
      fromJson: (json) => PlaybookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookModel>) {
      return result.data;
    }
    throw Exception('Failed to get playbook $id');
  }

  @override
  Future<PlaybookRunModel> createPlaybookRunFromPost(
    Map<String, dynamic> payload,
  ) async {
    final result = await _apiClient.post<PlaybookRunModel>(
      PlaybooksEndPoint.runs,
      data: payload,
      fromJson: (json) => PlaybookRunModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunModel>) {
      return result.data;
    }
    throw Exception('Failed to create playbook run');
  }

  @override
  Future<PlaybookRunModel> createPlaybookRunFromDialog(
    Map<String, dynamic> payload,
  ) async {
    final result = await _apiClient.post<PlaybookRunModel>(
      PlaybooksEndPoint.runDialog,
      data: payload,
      fromJson: (json) => PlaybookRunModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunModel>) {
      return result.data;
    }
    throw Exception('Failed to create playbook run from dialog');
  }

  @override
  Future<PlaybookRunModel> getPlaybookRun(String id) async {
    final result = await _apiClient.get<PlaybookRunModel>(
      PlaybooksEndPoint.run(id),
      fromJson: (json) => PlaybookRunModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunModel>) {
      return result.data;
    }
    throw Exception('Failed to get playbook run $id');
  }

  @override
  Future<PlaybookRunModel> getPlaybookRunByChannelId(String channelId) async {
    final result = await _apiClient.get<PlaybookRunModel>(
      PlaybooksEndPoint.runByChannel(channelId),
      fromJson: (json) => PlaybookRunModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunModel>) {
      return result.data;
    }
    throw Exception('Failed to get playbook run for channel $channelId');
  }

  @override
  Future<PlaybookRunMetadataModel> getPlaybookRunMetadata(String id) async {
    final result = await _apiClient.get<PlaybookRunMetadataModel>(
      PlaybooksEndPoint.runMetadata(id),
      fromJson: (json) =>
          PlaybookRunMetadataModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunMetadataModel>) {
      return result.data;
    }
    throw Exception('Failed to get metadata for playbook run $id');
  }

  @override
  Future<PlaybookRunListModel> listPlaybookRuns({
    required String teamId,
    int page = 0,
    int perPage = 60,
    String? sort,
    String? direction,
    List<String>? statuses,
    String? ownerUserId,
    String? participantId,
    String? searchTerm,
    String? channelId,
    bool? omitEnded,
    int? since,
  }) async {
    final result = await _apiClient.get<PlaybookRunListModel>(
      PlaybooksEndPoint.runs,
      queryParameters: {
        'team_id': teamId,
        'page': page,
        'per_page': perPage,
        if (sort != null) 'sort': sort,
        if (direction != null) 'direction': direction,
        if (statuses != null && statuses.isNotEmpty) 'statuses': statuses.join(','),
        if (ownerUserId != null) 'owner_user_id': ownerUserId,
        if (participantId != null) 'participant_id': participantId,
        if (searchTerm != null) 'search_term': searchTerm,
        if (channelId != null) 'channel_id': channelId,
        if (omitEnded != null) 'omit_ended': omitEnded,
        if (since != null) 'since': since,
      },
      fromJson: (json) =>
          PlaybookRunListModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookRunListModel>) {
      return result.data;
    }
    throw Exception('Failed to list playbook runs');
  }

  @override
  Future<ConditionListModel> getPlaybookConditions(String id) async {
    final result = await _apiClient.get<ConditionListModel>(
      PlaybooksEndPoint.playbookConditions(id),
      fromJson: (json) =>
          ConditionListModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ConditionListModel>) {
      return result.data;
    }
    throw Exception('Failed to get conditions for playbook $id');
  }

  @override
  Future<ConditionListModel> getRunConditions(String id) async {
    final result = await _apiClient.get<ConditionListModel>(
      PlaybooksEndPoint.runConditions(id),
      fromJson: (json) =>
          ConditionListModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ConditionListModel>) {
      return result.data;
    }
    throw Exception('Failed to get conditions for playbook run $id');
  }

  @override
  Future<ConditionModel> createPlaybookCondition(
    String id,
    ConditionModel condition,
  ) async {
    final result = await _apiClient.post<ConditionModel>(
      PlaybooksEndPoint.playbookConditions(id),
      data: condition.toMap(),
      fromJson: (json) => ConditionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ConditionModel>) {
      return result.data;
    }
    throw Exception('Failed to create condition for playbook $id');
  }

  @override
  Future<ConditionModel> updatePlaybookCondition(
    String id,
    String conditionId,
    ConditionModel condition,
  ) async {
    final result = await _apiClient.put<ConditionModel>(
      PlaybooksEndPoint.playbookCondition(id, conditionId),
      data: condition.toMap(),
      fromJson: (json) => ConditionModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ConditionModel>) {
      return result.data;
    }
    throw Exception('Failed to update condition for playbook $id');
  }

  @override
  Future<PropertyFieldModel> createPlaybookPropertyField(
    String id,
    PropertyFieldRequestModel field,
  ) async {
    final result = await _apiClient.post<PropertyFieldModel>(
      PlaybooksEndPoint.playbookPropertyFields(id),
      data: field.toMap(),
      fromJson: (json) =>
          PropertyFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PropertyFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to create property field for playbook $id');
  }

  @override
  Future<PropertyFieldModel> updatePlaybookPropertyField(
    String id,
    String fieldId,
    PropertyFieldRequestModel field,
  ) async {
    final result = await _apiClient.put<PropertyFieldModel>(
      PlaybooksEndPoint.playbookPropertyField(id, fieldId),
      data: field.toMap(),
      fromJson: (json) =>
          PropertyFieldModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PropertyFieldModel>) {
      return result.data;
    }
    throw Exception('Failed to update property field $fieldId for playbook $id');
  }

  @override
  Future<PropertyValueModel> setRunPropertyValue(
    String id,
    String fieldId,
    PropertyValueRequestModel value,
  ) async {
    final result = await _apiClient.put<PropertyValueModel>(
      PlaybooksEndPoint.runPropertyValue(id, fieldId),
      data: value.toMap(),
      fromJson: (json) =>
          PropertyValueModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PropertyValueModel>) {
      return result.data;
    }
    throw Exception('Failed to set property value $fieldId for run $id');
  }

  @override
  Future<TriggerIdReturnModel> itemRun(
    String id,
    int checklistId,
    int itemId,
  ) async {
    final result = await _apiClient.put<TriggerIdReturnModel>(
      PlaybooksEndPoint.runItem(id, checklistId, itemId),
      fromJson: (json) =>
          TriggerIdReturnModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TriggerIdReturnModel>) {
      return result.data;
    }
    throw Exception('Failed to run item $itemId of run $id');
  }

  @override
  Future<ErrorModel> addChecklistItem(
    String id,
    int checklistId,
    ChecklistItemModel item,
  ) async {
    final result = await _apiClient.post<ErrorModel>(
      PlaybooksEndPoint.runChecklistAdd(id, checklistId),
      data: item.toMap(),
      fromJson: (json) => ErrorModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ErrorModel>) {
      return result.data;
    }
    throw Exception('Failed to add checklist item to run $id');
  }

  @override
  Future<PlaybookModel> updatePlaybook(
    String id, PlaybookModel playbook,
  ) async {
    final result = await _apiClient.put<PlaybookModel>(
      PlaybooksEndPoint.playbook(id),
      data: playbook.toMap(),
      fromJson: (json) => PlaybookModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookModel>) {
      return result.data;
    }
    throw Exception('Failed to update playbook $id');
  }

  @override
  Future<PlaybookAutofollowsModel> getAutoFollows(String id) async {
    final result = await _apiClient.get<PlaybookAutofollowsModel>(
      PlaybooksEndPoint.playbookAutoFollows(id),
      fromJson: (json) =>
          PlaybookAutofollowsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PlaybookAutofollowsModel>) {
      return result.data;
    }
    throw Exception('Failed to get auto-follows for playbook $id');
  }

  @override
  Future<void> changeOwner(String runId, String ownerId) async {
    await _apiClient.post<void>(
      PlaybooksEndPoint.runOwner(runId),
      data: {'owner_id': ownerId},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> deletePlaybook(String id) async {
    await _apiClient.delete(PlaybooksEndPoint.playbook(id));
  }

  @override
  Future<void> deletePlaybookCondition(String id, String conditionId) async {
    await _apiClient.delete(PlaybooksEndPoint.playbookCondition(id, conditionId));
  }

  @override
  Future<void> deletePlaybookPropertyField(String id, String fieldId) async {
    await _apiClient.delete(PlaybooksEndPoint.playbookPropertyField(id, fieldId));
  }

  @override
  Future<void> endPlaybookRun(String id) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runEnd(id), fromJson: (_) {});
  }

  @override
  Future<void> endPlaybookRunDialog(String id, Map<String, dynamic> data) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runEndDialog(id), data: data, fromJson: (_) {});
  }

  @override
  Future<void> finish(String runId) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runFinish(runId), fromJson: (_) {});
  }

  @override
  Future<List<String>> getChecklistAutocomplete(String id) async {
    final result = await _apiClient.get<List<String>>(
      PlaybooksEndPoint.runChecklistAutocomplete(id),
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get checklist autocomplete');
  }

  @override
  Future<List<String>> getOwners({required String teamId}) async {
    final result = await _apiClient.get<List<String>>(
      PlaybooksEndPoint.owners,
      queryParameters: {'team_id': teamId},
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get owners');
  }

  @override
  Future<List<PropertyFieldModel>> getPlaybookPropertyFields(String id) async {
    final result = await _apiClient.get<List<PropertyFieldModel>>(
      PlaybooksEndPoint.playbookPropertyFields(id),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PropertyFieldModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PropertyFieldModel>>) {
      return result.data;
    }
    throw Exception('Failed to get playbook property fields');
  }

  @override
  Future<void> nextStageDialog(String runId) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runNextStageDialog(runId), fromJson: (_) {});
  }

  @override
  Future<void> reoderChecklistItem(String id, int checklistId, int itemId, int newIndex) async {
    await _apiClient.put<void>(
      PlaybooksEndPoint.runChecklistReorder(id, checklistId, itemId),
      data: {'new_index': newIndex},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> reorderPlaybookPropertyFields(String id, List<String> fieldIds) async {
    await _apiClient.put<void>(
      PlaybooksEndPoint.playbookPropertyFieldsReorder(id),
      data: fieldIds,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> restartPlaybookRun(String id) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runRestart(id), fromJson: (_) {});
  }

  @override
  Future<void> updatePlaybookRun(String id, Map<String, dynamic> run) async {
    await _apiClient.put<void>(PlaybooksEndPoint.run(id), data: run, fromJson: (_) {});
  }

  @override
  Future<void> updatePlaybookRunStatus(String id, Map<String, dynamic> status) async {
    await _apiClient.post<void>(PlaybooksEndPoint.runStatus(id), data: status, fromJson: (_) {});
  }

  @override
  Future<List<dynamic>> getChannelActions(
    String channelId, {
    String triggerType = 'new_member_joins',
  }) async {
    try {
      final result = await _apiClient.get<List<dynamic>>(
        PlaybooksEndPoint.channelActions(channelId),
        queryParameters: {'trigger_type': triggerType},
        fromJson: (json) => json is List ? json : [],
      );
      if (result is ApiSuccess<List<dynamic>>) {
        return result.data;
      }
    } catch (_) {
      // التعامل السلس مع غياب Playbooks plugin أو عودة خطأ 404
    }
    return [];
  }
}
