import 'package:equatable/equatable.dart';

class CommandResponseEntity extends Equatable {
  final String? ResponseType;
  final String? Text;
  final String? Username;
  final String? IconURL;
  final String? GotoLocation;
  final List<Map<String, dynamic>>? Attachments;

  const CommandResponseEntity({
    this.ResponseType,
    this.Text,
    this.Username,
    this.IconURL,
    this.GotoLocation,
    this.Attachments,
  });

  @override
  List<Object?> get props => [
        ResponseType,
        Text,
        Username,
        IconURL,
        GotoLocation,
        Attachments,
      ];

  CommandResponseEntity copyWith({
    String? ResponseType,
    String? Text,
    String? Username,
    String? IconURL,
    String? GotoLocation,
    List<Map<String, dynamic>>? Attachments,
  }) {
    return CommandResponseEntity(
      ResponseType: ResponseType ?? this.ResponseType,
      Text: Text ?? this.Text,
      Username: Username ?? this.Username,
      IconURL: IconURL ?? this.IconURL,
      GotoLocation: GotoLocation ?? this.GotoLocation,
      Attachments: Attachments ?? this.Attachments,
    );
  }
}
