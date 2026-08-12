import 'package:equatable/equatable.dart';

class ViewsWithCountEntity extends Equatable {
  final List<Map<String, dynamic>>? views;
  final int? total_count;

  const ViewsWithCountEntity({
    this.views,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        views,
        total_count,
      ];

  ViewsWithCountEntity copyWith({
    List<Map<String, dynamic>>? views,
    int? total_count,
  }) {
    return ViewsWithCountEntity(
      views: views ?? this.views,
      total_count: total_count ?? this.total_count,
    );
  }
}
