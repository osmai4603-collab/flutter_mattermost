import 'package:equatable/equatable.dart';

class ContentFlaggingConfigEntity extends Equatable {
  final bool? EnableContentFlagging;

  const ContentFlaggingConfigEntity({
    this.EnableContentFlagging,
  });

  @override
  List<Object?> get props => [
        EnableContentFlagging,
      ];

  ContentFlaggingConfigEntity copyWith({
    bool? EnableContentFlagging,
  }) {
    return ContentFlaggingConfigEntity(
      EnableContentFlagging: EnableContentFlagging ?? this.EnableContentFlagging,
    );
  }
}
