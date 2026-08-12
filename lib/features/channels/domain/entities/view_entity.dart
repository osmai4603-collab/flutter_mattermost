
class ViewEntity {
  final String? id;
  final String? channel_id;
  final String? type;
  final String? creator_id;
  final String? title;
  final String? description;
  final int? sort_order;
  final Map<String, dynamic>? props;
  final int? create_at;
  final int? update_at;
  final int? delete_at;

  const ViewEntity({
    this.id,
    this.channel_id,
    this.type,
    this.creator_id,
    this.title,
    this.description,
    this.sort_order,
    this.props,
    this.create_at,
    this.update_at,
    this.delete_at,
  });
  ViewEntity copyWith({
    String? id,
    String? channel_id,
    String? type,
    String? creator_id,
    String? title,
    String? description,
    int? sort_order,
    Map<String, dynamic>? props,
    int? create_at,
    int? update_at,
    int? delete_at,
  }) {
    return ViewEntity(
      id: id ?? this.id,
      channel_id: channel_id ?? this.channel_id,
      type: type ?? this.type,
      creator_id: creator_id ?? this.creator_id,
      title: title ?? this.title,
      description: description ?? this.description,
      sort_order: sort_order ?? this.sort_order,
      props: props ?? this.props,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
    );
  }
}
