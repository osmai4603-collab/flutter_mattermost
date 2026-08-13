import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

@lazySingleton
class CallsRestRepository {
  final ApiClient _apiClient;

  CallsRestRepository(this._apiClient);

  /// جلب تكوينات وإعدادات الشبكة وملاحظات ICE من إضافة المكالمات
  Future<ApiResult<Map<String, dynamic>>> getCallsConfig() async {
    return _apiClient.get<Map<String, dynamic>>(
      '/plugins/com.mattermost.calls/config',
      fromJson: (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }

  /// جلب حالة المكالمة لقناة محددة
  Future<ApiResult<Map<String, dynamic>>> getChannelCallState(String channelId) async {
    return _apiClient.get<Map<String, dynamic>>(
      '/plugins/com.mattermost.calls/channel/$channelId',
      fromJson: (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }
}
