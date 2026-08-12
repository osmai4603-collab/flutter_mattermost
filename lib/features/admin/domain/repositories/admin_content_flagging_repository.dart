import 'package:flutter_mattermost/features/admin/data/models/content_reviewer_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_field_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_value_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/content_flagging_config_model.dart';

abstract class AdminContentFlaggingRepository {
  Future<ContentFlaggingConfigModel> getConfig();
  Future<List<CustomAttributeFieldModel>> getFields();
  Future<Map<String, dynamic>> getFlagConfig();
  Future<Map<String, dynamic>> getPost(String postId);
  Future<void> assignContentReviewer(String postId, String contentReviewerId);
  Future<List<CustomAttributeValueModel>> getPostFieldValues(String postId);
  Future<Map<String, dynamic>> flagPost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> keepPost(String postId);
  Future<Map<String, dynamic>> removePost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> reportPost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<List<ContentReviewerModel>> searchTeamReviewers(
    String teamId,
    Map<String, dynamic> query,
  );
  Future<Map<String, dynamic>> getTeamStatus(String teamId);
}
