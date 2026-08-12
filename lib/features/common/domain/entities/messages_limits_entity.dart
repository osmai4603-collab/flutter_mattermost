import 'package:equatable/equatable.dart';

class MessagesLimitsEntity extends Equatable {
  final int? history;

  const MessagesLimitsEntity({
    this.history,
  });

  @override
  List<Object?> get props => [
        history,
      ];

  MessagesLimitsEntity copyWith({
    int? history,
  }) {
    return MessagesLimitsEntity(
      history: history ?? this.history,
    );
  }
}
