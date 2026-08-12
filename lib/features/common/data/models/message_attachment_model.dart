import 'package:flutter_mattermost/features/common/domain/entities/message_attachment_entity.dart';

final class MessageAttachmentModel extends MessageAttachmentEntity {
  const MessageAttachmentModel({
    required super.Id,
    required super.Fallback,
    required super.Color,
    required super.Pretext,
    required super.AuthorName,
    required super.AuthorLink,
    required super.AuthorIcon,
    required super.Title,
    required super.TitleLink,
    required super.Text,
    required super.Fields,
    required super.ImageURL,
    required super.ThumbURL,
    required super.Footer,
    required super.FooterIcon,
    required super.Timestamp,
  });

  factory MessageAttachmentModel.fromMap(Map<String, dynamic> map) {
    return MessageAttachmentModel(
      Id: map["Id"] as String?,
      Fallback: map["Fallback"] as String?,
      Color: map["Color"] as String?,
      Pretext: map["Pretext"] as String?,
      AuthorName: map["AuthorName"] as String?,
      AuthorLink: map["AuthorLink"] as String?,
      AuthorIcon: map["AuthorIcon"] as String?,
      Title: map["Title"] as String?,
      TitleLink: map["TitleLink"] as String?,
      Text: map["Text"] as String?,
      Fields: (map["Fields"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      ImageURL: map["ImageURL"] as String?,
      ThumbURL: map["ThumbURL"] as String?,
      Footer: map["Footer"] as String?,
      FooterIcon: map["FooterIcon"] as String?,
      Timestamp: map["Timestamp"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "Fallback": Fallback,
      "Color": Color,
      "Pretext": Pretext,
      "AuthorName": AuthorName,
      "AuthorLink": AuthorLink,
      "AuthorIcon": AuthorIcon,
      "Title": Title,
      "TitleLink": TitleLink,
      "Text": Text,
      "Fields": Fields,
      "ImageURL": ImageURL,
      "ThumbURL": ThumbURL,
      "Footer": Footer,
      "FooterIcon": FooterIcon,
      "Timestamp": Timestamp,
    };
  }

  factory MessageAttachmentModel.fromEntity(MessageAttachmentEntity entity) {
    return MessageAttachmentModel(
      Id: entity.Id,
      Fallback: entity.Fallback,
      Color: entity.Color,
      Pretext: entity.Pretext,
      AuthorName: entity.AuthorName,
      AuthorLink: entity.AuthorLink,
      AuthorIcon: entity.AuthorIcon,
      Title: entity.Title,
      TitleLink: entity.TitleLink,
      Text: entity.Text,
      Fields: entity.Fields,
      ImageURL: entity.ImageURL,
      ThumbURL: entity.ThumbURL,
      Footer: entity.Footer,
      FooterIcon: entity.FooterIcon,
      Timestamp: entity.Timestamp,
    );
  }

  @override
  MessageAttachmentModel copyWith({
    String? Id,
    String? Fallback,
    String? Color,
    String? Pretext,
    String? AuthorName,
    String? AuthorLink,
    String? AuthorIcon,
    String? Title,
    String? TitleLink,
    String? Text,
    List<Map<String, dynamic>>? Fields,
    String? ImageURL,
    String? ThumbURL,
    String? Footer,
    String? FooterIcon,
    String? Timestamp,
  }) {
    return MessageAttachmentModel(
      Id: Id ?? this.Id,
      Fallback: Fallback ?? this.Fallback,
      Color: Color ?? this.Color,
      Pretext: Pretext ?? this.Pretext,
      AuthorName: AuthorName ?? this.AuthorName,
      AuthorLink: AuthorLink ?? this.AuthorLink,
      AuthorIcon: AuthorIcon ?? this.AuthorIcon,
      Title: Title ?? this.Title,
      TitleLink: TitleLink ?? this.TitleLink,
      Text: Text ?? this.Text,
      Fields: Fields ?? this.Fields,
      ImageURL: ImageURL ?? this.ImageURL,
      ThumbURL: ThumbURL ?? this.ThumbURL,
      Footer: Footer ?? this.Footer,
      FooterIcon: FooterIcon ?? this.FooterIcon,
      Timestamp: Timestamp ?? this.Timestamp,
    );
  }

  MessageAttachmentEntity toEntity() => MessageAttachmentEntity(
        Id: Id,
        Fallback: Fallback,
        Color: Color,
        Pretext: Pretext,
        AuthorName: AuthorName,
        AuthorLink: AuthorLink,
        AuthorIcon: AuthorIcon,
        Title: Title,
        TitleLink: TitleLink,
        Text: Text,
        Fields: Fields,
        ImageURL: ImageURL,
        ThumbURL: ThumbURL,
        Footer: Footer,
        FooterIcon: FooterIcon,
        Timestamp: Timestamp,
      );
}
