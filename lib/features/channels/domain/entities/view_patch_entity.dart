
class ViewPatchEntity {
  final String? title;
  final String? description;
  final int? sort_order;
  final Map<String, dynamic>? props;

  const ViewPatchEntity({
    this.title,
    this.description,
    this.sort_order,
    this.props,
  });
  ViewPatchEntity copyWith({
    String? title,
    String? description,
    int? sort_order,
    Map<String, dynamic>? props,
  }) {
    return ViewPatchEntity(
      title: title ?? this.title,
      description: description ?? this.description,
      sort_order: sort_order ?? this.sort_order,
      props: props ?? this.props,
    );
  }
}
