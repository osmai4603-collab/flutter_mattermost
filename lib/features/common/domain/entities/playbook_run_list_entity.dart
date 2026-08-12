import 'package:equatable/equatable.dart';

class PlaybookRunListEntity extends Equatable {
  final int? total_count;
  final int? page_count;
  final bool? has_more;
  final List<Map<String, dynamic>>? items;

  const PlaybookRunListEntity({
    this.total_count,
    this.page_count,
    this.has_more,
    this.items,
  });

  @override
  List<Object?> get props => [
        total_count,
        page_count,
        has_more,
        items,
      ];

  PlaybookRunListEntity copyWith({
    int? total_count,
    int? page_count,
    bool? has_more,
    List<Map<String, dynamic>>? items,
  }) {
    return PlaybookRunListEntity(
      total_count: total_count ?? this.total_count,
      page_count: page_count ?? this.page_count,
      has_more: has_more ?? this.has_more,
      items: items ?? this.items,
    );
  }
}
