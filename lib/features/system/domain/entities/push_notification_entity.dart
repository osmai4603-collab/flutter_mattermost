import 'package:equatable/equatable.dart';

class PushNotificationEntity extends Equatable {
  final String? ack_id;
  final String? platform;
  final String? server_id;
  final String? device_id;
  final String? post_id;
  final String? category;
  final String? sound;
  final String? message;
  final double? badge;
  final double? cont_ava;
  final String? team_id;
  final String? channel_id;
  final String? root_id;
  final String? channel_name;
  final String? type;
  final String? sub_type;
  final String? transport;
  final String? sender_id;
  final String? sender_name;
  final String? override_username;
  final String? override_icon_url;
  final String? from_webhook;
  final String? version;
  final bool? is_crt_enabled;
  final bool? is_id_loaded;
  final String? signature;

  const PushNotificationEntity({
    this.ack_id,
    this.platform,
    this.server_id,
    this.device_id,
    this.post_id,
    this.category,
    this.sound,
    this.message,
    this.badge,
    this.cont_ava,
    this.team_id,
    this.channel_id,
    this.root_id,
    this.channel_name,
    this.type,
    this.sub_type,
    this.transport,
    this.sender_id,
    this.sender_name,
    this.override_username,
    this.override_icon_url,
    this.from_webhook,
    this.version,
    this.is_crt_enabled,
    this.is_id_loaded,
    this.signature,
  });

  @override
  List<Object?> get props => [
        ack_id,
        platform,
        server_id,
        device_id,
        post_id,
        category,
        sound,
        message,
        badge,
        cont_ava,
        team_id,
        channel_id,
        root_id,
        channel_name,
        type,
        sub_type,
        transport,
        sender_id,
        sender_name,
        override_username,
        override_icon_url,
        from_webhook,
        version,
        is_crt_enabled,
        is_id_loaded,
        signature,
      ];

  PushNotificationEntity copyWith({
    String? ack_id,
    String? platform,
    String? server_id,
    String? device_id,
    String? post_id,
    String? category,
    String? sound,
    String? message,
    double? badge,
    double? cont_ava,
    String? team_id,
    String? channel_id,
    String? root_id,
    String? channel_name,
    String? type,
    String? sub_type,
    String? transport,
    String? sender_id,
    String? sender_name,
    String? override_username,
    String? override_icon_url,
    String? from_webhook,
    String? version,
    bool? is_crt_enabled,
    bool? is_id_loaded,
    String? signature,
  }) {
    return PushNotificationEntity(
      ack_id: ack_id ?? this.ack_id,
      platform: platform ?? this.platform,
      server_id: server_id ?? this.server_id,
      device_id: device_id ?? this.device_id,
      post_id: post_id ?? this.post_id,
      category: category ?? this.category,
      sound: sound ?? this.sound,
      message: message ?? this.message,
      badge: badge ?? this.badge,
      cont_ava: cont_ava ?? this.cont_ava,
      team_id: team_id ?? this.team_id,
      channel_id: channel_id ?? this.channel_id,
      root_id: root_id ?? this.root_id,
      channel_name: channel_name ?? this.channel_name,
      type: type ?? this.type,
      sub_type: sub_type ?? this.sub_type,
      transport: transport ?? this.transport,
      sender_id: sender_id ?? this.sender_id,
      sender_name: sender_name ?? this.sender_name,
      override_username: override_username ?? this.override_username,
      override_icon_url: override_icon_url ?? this.override_icon_url,
      from_webhook: from_webhook ?? this.from_webhook,
      version: version ?? this.version,
      is_crt_enabled: is_crt_enabled ?? this.is_crt_enabled,
      is_id_loaded: is_id_loaded ?? this.is_id_loaded,
      signature: signature ?? this.signature,
    );
  }
}
