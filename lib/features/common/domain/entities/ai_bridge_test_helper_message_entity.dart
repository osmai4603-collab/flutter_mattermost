import 'package:equatable/equatable.dart';

class AIBridgeTestHelperMessageEntity extends Equatable {
  final String? role;
  final String? message;
  final List<String>? file_ids;

  const AIBridgeTestHelperMessageEntity({
    this.role,
    this.message,
    this.file_ids,
  });

  @override
  List<Object?> get props => [
        role,
        message,
        file_ids,
      ];

  AIBridgeTestHelperMessageEntity copyWith({
    String? role,
    String? message,
    List<String>? file_ids,
  }) {
    return AIBridgeTestHelperMessageEntity(
      role: role ?? this.role,
      message: message ?? this.message,
      file_ids: file_ids ?? this.file_ids,
    );
  }
}
