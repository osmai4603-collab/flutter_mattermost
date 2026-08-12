import 'package:flutter_mattermost/features/common/domain/entities/message_descriptor_entity.dart';

final class MessageDescriptorModel extends MessageDescriptorEntity {
  const MessageDescriptorModel({
    required super.id,
    required super.defaultMessage,
    required super.values,
  });

  factory MessageDescriptorModel.fromMap(Map<String, dynamic> map) {
    return MessageDescriptorModel(
      id: map["id"] as String?,
      defaultMessage: map["defaultMessage"] as String?,
      values: map["values"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "defaultMessage": defaultMessage,
      "values": values,
    };
  }

  factory MessageDescriptorModel.fromEntity(MessageDescriptorEntity entity) {
    return MessageDescriptorModel(
      id: entity.id,
      defaultMessage: entity.defaultMessage,
      values: entity.values,
    );
  }

  @override
  MessageDescriptorModel copyWith({
    String? id,
    String? defaultMessage,
    Map<String, dynamic>? values,
  }) {
    return MessageDescriptorModel(
      id: id ?? this.id,
      defaultMessage: defaultMessage ?? this.defaultMessage,
      values: values ?? this.values,
    );
  }

  MessageDescriptorEntity toEntity() => MessageDescriptorEntity(
        id: id,
        defaultMessage: defaultMessage,
        values: values,
      );
}
