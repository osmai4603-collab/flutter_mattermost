import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/notifications/notification_payload_handler.dart';
import 'package:flutter_mattermost/core/notifications/web_notifier.dart'
    if (dart.library.js_interop) 'package:flutter_mattermost/core/notifications/web_notifier_web.dart';

@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final WebSocketClientManager _wsClient;
  final NotificationPayloadHandler _payloadHandler;
  StreamSubscription? _wsSubscription;

  LocalNotificationService(this._wsClient, this._payloadHandler);

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) {
      const WebNotifier().requestNotificationPermission();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      await androidImplementation?.requestNotificationsPermission();
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
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
    if (kIsWeb) {
      const WebNotifier().showNotification(title, body);
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'mattermost_channel',
          'Mattermost Notifications',
          channelDescription: 'Notifications from Mattermost server',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
          defaultActionName: 'Open',
          urgency: LinuxNotificationUrgency.critical,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      linux: linuxPlatformChannelSpecifics,
    );

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
      _payloadHandler.handlePayload(data);
    }
  }
}
