import 'package:flutter_mattermost/features/integrations/domain/entities/command_response_entity.dart';

final class CommandResponseModel extends CommandResponseEntity {
  const CommandResponseModel({
    required super.ResponseType,
    required super.Text,
    required super.Username,
    required super.IconURL,
    required super.GotoLocation,
    required super.Attachments,
  });

  factory CommandResponseModel.fromMap(Map<String, dynamic> map) {
    return CommandResponseModel(
      ResponseType: map["ResponseType"] as String?,
      Text: map["Text"] as String?,
      Username: map["Username"] as String?,
      IconURL: map["IconURL"] as String?,
      GotoLocation: map["GotoLocation"] as String?,
      Attachments: (map["Attachments"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "ResponseType": ResponseType,
      "Text": Text,
      "Username": Username,
      "IconURL": IconURL,
      "GotoLocation": GotoLocation,
      "Attachments": Attachments,
    };
  }

  factory CommandResponseModel.fromEntity(CommandResponseEntity entity) {
    return CommandResponseModel(
      ResponseType: entity.ResponseType,
      Text: entity.Text,
      Username: entity.Username,
      IconURL: entity.IconURL,
      GotoLocation: entity.GotoLocation,
      Attachments: entity.Attachments,
    );
  }

  @override
  CommandResponseModel copyWith({
    String? ResponseType,
    String? Text,
    String? Username,
    String? IconURL,
    String? GotoLocation,
    List<Map<String, dynamic>>? Attachments,
  }) {
    return CommandResponseModel(
      ResponseType: ResponseType ?? this.ResponseType,
      Text: Text ?? this.Text,
      Username: Username ?? this.Username,
      IconURL: IconURL ?? this.IconURL,
      GotoLocation: GotoLocation ?? this.GotoLocation,
      Attachments: Attachments ?? this.Attachments,
    );
  }

  CommandResponseEntity toEntity() => CommandResponseEntity(
        ResponseType: ResponseType,
        Text: Text,
        Username: Username,
        IconURL: IconURL,
        GotoLocation: GotoLocation,
        Attachments: Attachments,
      );
}
