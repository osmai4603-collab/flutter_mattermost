import 'package:flutter_mattermost/features/common/domain/entities/message_attachment_field_entity.dart';

final class MessageAttachmentFieldModel extends MessageAttachmentFieldEntity {
  const MessageAttachmentFieldModel({
    required super.Title,
    required super.Value,
    required super.Short,
  });

  factory MessageAttachmentFieldModel.fromMap(Map<String, dynamic> map) {
    return MessageAttachmentFieldModel(
      Title: map["Title"] as String?,
      Value: map["Value"] as String?,
      Short: map["Short"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Title": Title,
      "Value": Value,
      "Short": Short,
    };
  }

  factory MessageAttachmentFieldModel.fromEntity(MessageAttachmentFieldEntity entity) {
    return MessageAttachmentFieldModel(
      Title: entity.Title,
      Value: entity.Value,
      Short: entity.Short,
    );
  }

  @override
  MessageAttachmentFieldModel copyWith({
    String? Title,
    String? Value,
    bool? Short,
  }) {
    return MessageAttachmentFieldModel(
      Title: Title ?? this.Title,
      Value: Value ?? this.Value,
      Short: Short ?? this.Short,
    );
  }

  MessageAttachmentFieldEntity toEntity() => MessageAttachmentFieldEntity(
        Title: Title,
        Value: Value,
        Short: Short,
      );
}
