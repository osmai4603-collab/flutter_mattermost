import 'package:equatable/equatable.dart';

class DialogLookupOptionEntity extends Equatable {
  final String? text;
  final String? value;
  const DialogLookupOptionEntity({
    this.text,
    this.value,
  });

  @override
  List<Object?> get props => [
      text,
      value,
  ];
}
