import 'package:flutter_mattermost/features/common/domain/entities/ai_bridge_test_helper_recorded_request_entity.dart';

final class AIBridgeTestHelperRecordedRequestModel extends AIBridgeTestHelperRecordedRequestEntity {
  const AIBridgeTestHelperRecordedRequestModel({
    required super.operation,
    required super.client_operation,
    required super.operation_sub_type,
    required super.session_user_id,
    required super.user_id,
    required super.channel_id,
    required super.agent_id,
    required super.service_id,
    required super.messages,
    required super.json_output_format,
  });

  factory AIBridgeTestHelperRecordedRequestModel.fromMap(Map<String, dynamic> map) {
    return AIBridgeTestHelperRecordedRequestModel(
      operation: map["operation"] as String?,
      client_operation: map["client_operation"] as String?,
      operation_sub_type: map["operation_sub_type"] as String?,
      session_user_id: map["session_user_id"] as String?,
      user_id: map["user_id"] as String?,
      channel_id: map["channel_id"] as String?,
      agent_id: map["agent_id"] as String?,
      service_id: map["service_id"] as String?,
      messages: (map["messages"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      json_output_format: map["json_output_format"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "operation": operation,
      "client_operation": client_operation,
      "operation_sub_type": operation_sub_type,
      "session_user_id": session_user_id,
      "user_id": user_id,
      "channel_id": channel_id,
      "agent_id": agent_id,
      "service_id": service_id,
      "messages": messages,
      "json_output_format": json_output_format,
    };
  }

  factory AIBridgeTestHelperRecordedRequestModel.fromEntity(AIBridgeTestHelperRecordedRequestEntity entity) {
    return AIBridgeTestHelperRecordedRequestModel(
      operation: entity.operation,
      client_operation: entity.client_operation,
      operation_sub_type: entity.operation_sub_type,
      session_user_id: entity.session_user_id,
      user_id: entity.user_id,
      channel_id: entity.channel_id,
      agent_id: entity.agent_id,
      service_id: entity.service_id,
      messages: entity.messages,
      json_output_format: entity.json_output_format,
    );
  }

  @override
  AIBridgeTestHelperRecordedRequestModel copyWith({
    String? operation,
    String? client_operation,
    String? operation_sub_type,
    String? session_user_id,
    String? user_id,
    String? channel_id,
    String? agent_id,
    String? service_id,
    List<Map<String, dynamic>>? messages,
    Map<String, dynamic>? json_output_format,
  }) {
    return AIBridgeTestHelperRecordedRequestModel(
      operation: operation ?? this.operation,
      client_operation: client_operation ?? this.client_operation,
      operation_sub_type: operation_sub_type ?? this.operation_sub_type,
      session_user_id: session_user_id ?? this.session_user_id,
      user_id: user_id ?? this.user_id,
      channel_id: channel_id ?? this.channel_id,
      agent_id: agent_id ?? this.agent_id,
      service_id: service_id ?? this.service_id,
      messages: messages ?? this.messages,
      json_output_format: json_output_format ?? this.json_output_format,
    );
  }

  AIBridgeTestHelperRecordedRequestEntity toEntity() => AIBridgeTestHelperRecordedRequestEntity(
        operation: operation,
        client_operation: client_operation,
        operation_sub_type: operation_sub_type,
        session_user_id: session_user_id,
        user_id: user_id,
        channel_id: channel_id,
        agent_id: agent_id,
        service_id: service_id,
        messages: messages,
        json_output_format: json_output_format,
      );
}
