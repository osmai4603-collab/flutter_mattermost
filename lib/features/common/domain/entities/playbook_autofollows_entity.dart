import 'package:equatable/equatable.dart';

class PlaybookAutofollowsEntity extends Equatable {
  final int? total_count;
  final List<String>? items;

  const PlaybookAutofollowsEntity({
    this.total_count,
    this.items,
  });

  @override
  List<Object?> get props => [
        total_count,
        items,
      ];

  PlaybookAutofollowsEntity copyWith({
    int? total_count,
    List<String>? items,
  }) {
    return PlaybookAutofollowsEntity(
      total_count: total_count ?? this.total_count,
      items: items ?? this.items,
    );
  }
}
