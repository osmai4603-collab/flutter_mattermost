import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'dart:async';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final WebSocketClientManager _wsClient;
  StreamSubscription? _wsSubscription;

  LocalNotificationService(this._wsClient);

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  void startListening() {
    _wsSubscription?.cancel();
    _wsSubscription = _wsClient.eventStream.listen(_handleWsEvent);
  }

  void stopListening() {
    _wsSubscription?.cancel();
    _wsSubscription = null;
  }

  Future<void> _handleWsEvent(TypedWebSocketEvent event) async {
    // Show notification only if backgrounded? 
    // In a real app we'd check AppLifecycleState.
    
    if (event is PostCreatedEvent) {
      await showNotification(
        id: event.post.id.hashCode,
        title: 'New message',
        body: event.post.message,
        payload: jsonEncode({
          'type': 'post',
          'channelId': event.channelId,
          'postId': event.post.id,
        }),
      );
    } else if (event is CallStartedEvent) {
      await showNotification(
        id: event.callId.hashCode,
        title: 'Incoming Call',
        body: 'User ${event.ownerId} is calling you',
        payload: jsonEncode({
          'type': 'call',
          'channelId': event.channelId,
          'callId': event.callId,
        }),
      );
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mattermost_channel',
      'Mattermost Notifications',
      channelDescription: 'Notifications from Mattermost server',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      // Handle navigation via NotificationPayloadHandler (to be implemented)
      // For now, we just print
      print('Notification clicked: $data');
    }
  }
}
