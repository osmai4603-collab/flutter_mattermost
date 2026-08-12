import 'package:equatable/equatable.dart';

class MessageAttachmentEntity extends Equatable {
  final String? Id;
  final String? Fallback;
  final String? Color;
  final String? Pretext;
  final String? AuthorName;
  final String? AuthorLink;
  final String? AuthorIcon;
  final String? Title;
  final String? TitleLink;
  final String? Text;
  final List<Map<String, dynamic>>? Fields;
  final String? ImageURL;
  final String? ThumbURL;
  final String? Footer;
  final String? FooterIcon;
  final String? Timestamp;

  const MessageAttachmentEntity({
    this.Id,
    this.Fallback,
    this.Color,
    this.Pretext,
    this.AuthorName,
    this.AuthorLink,
    this.AuthorIcon,
    this.Title,
    this.TitleLink,
    this.Text,
    this.Fields,
    this.ImageURL,
    this.ThumbURL,
    this.Footer,
    this.FooterIcon,
    this.Timestamp,
  });

  @override
  List<Object?> get props => [
        Id,
        Fallback,
        Color,
        Pretext,
        AuthorName,
        AuthorLink,
        AuthorIcon,
        Title,
        TitleLink,
        Text,
        Fields,
        ImageURL,
        ThumbURL,
        Footer,
        FooterIcon,
        Timestamp,
      ];

  MessageAttachmentEntity copyWith({
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
    return MessageAttachmentEntity(
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
}
