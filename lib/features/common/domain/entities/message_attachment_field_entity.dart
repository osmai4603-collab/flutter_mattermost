import 'package:equatable/equatable.dart';

class MessageAttachmentFieldEntity extends Equatable {
  final String? Title;
  final String? Value;
  final bool? Short;

  const MessageAttachmentFieldEntity({
    this.Title,
    this.Value,
    this.Short,
  });

  @override
  List<Object?> get props => [
        Title,
        Value,
        Short,
      ];

  MessageAttachmentFieldEntity copyWith({
    String? Title,
    String? Value,
    bool? Short,
  }) {
    return MessageAttachmentFieldEntity(
      Title: Title ?? this.Title,
      Value: Value ?? this.Value,
      Short: Short ?? this.Short,
    );
  }
}
