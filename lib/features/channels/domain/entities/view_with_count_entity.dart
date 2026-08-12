/// قائمة العروض مع العدد الإجمالي (ViewWithCount):
/// views مصفوفة من كائنات View.
class ViewWithCountEntity {
  final List<Map<String, dynamic>>? views;
  final int? total_count;

  const ViewWithCountEntity({
    this.views,
    this.total_count,
  });

  ViewWithCountEntity copyWith({
    List<Map<String, dynamic>>? views,
    int? total_count,
  }) {
    return ViewWithCountEntity(
      views: views ?? this.views,
      total_count: total_count ?? this.total_count,
    );
  }
}
