import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/call_dto.dart';

/// REST API لإضافة المكالمات — المسارات موثقة من عميل الموبايل الرسمي
/// (app/products/calls/client/rest.ts) وخادم الإضافة v1.12.3
/// (server/api_router.go). الجذر: `/plugins/com.mattermost.calls`.
@lazySingleton
class CallsRestRepository {
  final ApiClient _apiClient;

  CallsRestRepository(this._apiClient);

  static const String _callsRoute = '/plugins/com.mattermost.calls';

  /// جلب تكوين إضافة المكالمات. المفاتيح PascalCase كما يرسلها الخادم
  /// (`ICEServersConfigs`, `NeedsTURNCredentials`, `EnableAV1`, ...).
  Future<ApiResult<Map<String, dynamic>>> getCallsConfig() async {
    return _apiClient.get<Map<String, dynamic>>(
      '$_callsRoute/config',
      fromJson: (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }

  /// جلب حالة المكالمة لقناة (CallChannelStateDto = {enabled, channel_id, call})
  /// — `call` يحوي `sessions[]` للمشاركين (CallParticipantDto من UserStateClient).
  Future<ApiResult<CallChannelStateDto>> getChannelCallState(
    String channelId,
  ) async {
    return _apiClient.get<CallChannelStateDto>(
      '$_callsRoute/$channelId',
      queryParameters: {'mobilev2': 'true'},
      fromJson: (data) => data is Map
          ? CallChannelStateDto.fromMap(Map<String, dynamic>.from(data))
          : CallChannelStateDto(enabled: false, channelId: channelId),
    );
  }

  /// توليد اعتمادات TURN المؤقتة عند NeedsTURNCredentials — يعيد RTCIceServer[].
  Future<ApiResult<List<Map<String, dynamic>>>> getTURNCredentials() async {
    return _apiClient.get<List<Map<String, dynamic>>>(
      '$_callsRoute/turn-credentials',
      fromJson: (data) {
        if (data is List) {
          return data
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        return <Map<String, dynamic>>[];
      },
    );
  }

  /// إنهاء المكالمة — المتاح لكل مشارك (يغادر الكل) عبر POST /calls/{channelId}/end.
  Future<ApiResult<dynamic>> endCall(String channelId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$channelId/end',
      fromJson: (data) => data,
    );
  }

  /// إزالة إشعار المكالمة الواردة (POST /calls/{channelId}/dismiss-notification).
  Future<ApiResult<dynamic>> dismissCall(String channelId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$channelId/dismiss-notification',
      fromJson: (data) => data,
    );
  }

  // ── تحكمات المضيف (host) ────────────────────────────────────

  Future<ApiResult<dynamic>> hostMake(String callId, String newHostId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$callId/host/make',
      data: {'new_host_id': newHostId},
      fromJson: (data) => data,
    );
  }

  Future<ApiResult<dynamic>> hostMute(String callId, String sessionId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$callId/host/mute',
      data: {'session_id': sessionId},
      fromJson: (data) => data,
    );
  }

  Future<ApiResult<dynamic>> hostScreenOff(
    String callId,
    String sessionId,
  ) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$callId/host/screen-off',
      data: {'session_id': sessionId},
      fromJson: (data) => data,
    );
  }

  Future<ApiResult<dynamic>> hostLowerHand(
    String callId,
    String sessionId,
  ) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$callId/host/lower-hand',
      data: {'session_id': sessionId},
      fromJson: (data) => data,
    );
  }

  Future<ApiResult<dynamic>> hostRemove(String callId, String sessionId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$callId/host/remove',
      data: {'session_id': sessionId},
      fromJson: (data) => data,
    );
  }

  // ── Recording ───────────────────────────────────────────────

  Future<ApiResult<dynamic>> startRecording(String channelId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$channelId/recording/start',
      fromJson: (data) => data,
    );
  }

  Future<ApiResult<dynamic>> stopRecording(String channelId) async {
    return _apiClient.post<dynamic>(
      '$_callsRoute/calls/$channelId/recording/stop',
      fromJson: (data) => data,
    );
  }
}
