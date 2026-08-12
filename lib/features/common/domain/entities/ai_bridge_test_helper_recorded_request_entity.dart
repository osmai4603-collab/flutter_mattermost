import 'package:equatable/equatable.dart';

class AIBridgeTestHelperRecordedRequestEntity extends Equatable {
  final String? operation;
  final String? client_operation;
  final String? operation_sub_type;
  final String? session_user_id;
  final String? user_id;
  final String? channel_id;
  final String? agent_id;
  final String? service_id;
  final List<Map<String, dynamic>>? messages;
  final Map<String, dynamic>? json_output_format;

  const AIBridgeTestHelperRecordedRequestEntity({
    this.operation,
    this.client_operation,
    this.operation_sub_type,
    this.session_user_id,
    this.user_id,
    this.channel_id,
    this.agent_id,
    this.service_id,
    this.messages,
    this.json_output_format,
  });

  @override
  List<Object?> get props => [
        operation,
        client_operation,
        operation_sub_type,
        session_user_id,
        user_id,
        channel_id,
        agent_id,
        service_id,
        messages,
        json_output_format,
      ];

  AIBridgeTestHelperRecordedRequestEntity copyWith({
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
    return AIBridgeTestHelperRecordedRequestEntity(
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
}
