import 'package:flutter_mattermost/features/chat/data/models/content_flagging_config_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_content_flagging_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/content_reviewer_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_field_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_value_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_content_flagging_repository.dart';

@LazySingleton(as: AdminContentFlaggingRepository)
class AdminContentFlaggingRepositoryImpl
    implements AdminContentFlaggingRepository {
  final AdminContentFlaggingDataSource _dataSource;

  AdminContentFlaggingRepositoryImpl(this._dataSource);

  @override
  Future<ContentFlaggingConfigModel> getConfig() => _dataSource.getConfig();

  @override
  Future<List<CustomAttributeFieldModel>> getFields() => _dataSource.getFields();

  @override
  Future<Map<String, dynamic>> getFlagConfig() => _dataSource.getFlagConfig();

  @override
  Future<Map<String, dynamic>> getPost(String postId) =>
      _dataSource.getPost(postId);

  @override
  Future<void> assignContentReviewer(String postId, String contentReviewerId) =>
      _dataSource.assignContentReviewer(postId, contentReviewerId);

  @override
  Future<List<CustomAttributeValueModel>> getPostFieldValues(String postId) =>
      _dataSource.getPostFieldValues(postId);

  @override
  Future<Map<String, dynamic>> flagPost(
    String postId,
    Map<String, dynamic> data,
  ) => _dataSource.flagPost(postId, data);

  @override
  Future<Map<String, dynamic>> keepPost(String postId) =>
      _dataSource.keepPost(postId);

  @override
  Future<Map<String, dynamic>> removePost(
    String postId,
    Map<String, dynamic> data,
  ) => _dataSource.removePost(postId, data);

  @override
  Future<Map<String, dynamic>> reportPost(
    String postId,
    Map<String, dynamic> data,
  ) => _dataSource.reportPost(postId, data);

  @override
  Future<List<ContentReviewerModel>> searchTeamReviewers(
    String teamId,
    Map<String, dynamic> query,
  ) => _dataSource.searchTeamReviewers(teamId, query);

  @override
  Future<Map<String, dynamic>> getTeamStatus(String teamId) =>
      _dataSource.getTeamStatus(teamId);
}
