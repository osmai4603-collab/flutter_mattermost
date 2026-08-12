import 'package:equatable/equatable.dart';

class BoardsLimitsEntity extends Equatable {
  final int? cards;
  final int? views;

  const BoardsLimitsEntity({
    this.cards,
    this.views,
  });

  @override
  List<Object?> get props => [
        cards,
        views,
      ];

  BoardsLimitsEntity copyWith({
    int? cards,
    int? views,
  }) {
    return BoardsLimitsEntity(
      cards: cards ?? this.cards,
      views: views ?? this.views,
    );
  }
}
