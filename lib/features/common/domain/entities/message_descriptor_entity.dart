import 'package:equatable/equatable.dart';

class MessageDescriptorEntity extends Equatable {
  final String? id;
  final String? defaultMessage;
  final Map<String, dynamic>? values;

  const MessageDescriptorEntity({
    this.id,
    this.defaultMessage,
    this.values,
  });

  @override
  List<Object?> get props => [
        id,
        defaultMessage,
        values,
      ];

  MessageDescriptorEntity copyWith({
    String? id,
    String? defaultMessage,
    Map<String, dynamic>? values,
  }) {
    return MessageDescriptorEntity(
      id: id ?? this.id,
      defaultMessage: defaultMessage ?? this.defaultMessage,
      values: values ?? this.values,
    );
  }
}
