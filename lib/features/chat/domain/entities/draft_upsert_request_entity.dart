
class DraftUpsertRequestEntity {
  final String? channel_id;
  final String? root_id;
  final String? message;
  final String? type;
  final Map<String, dynamic>? props;
  final List<String>? file_ids;
  final Map<String, dynamic>? priority;

  const DraftUpsertRequestEntity({
    required this.channel_id,
    this.root_id,
    required this.message,
    this.type,
    this.props,
    this.file_ids,
    this.priority,
  });
  DraftUpsertRequestEntity copyWith({
    String? channel_id,
    String? root_id,
    String? message,
    String? type,
    Map<String, dynamic>? props,
    List<String>? file_ids,
    Map<String, dynamic>? priority,
  }) {
    return DraftUpsertRequestEntity(
      channel_id: channel_id ?? this.channel_id,
      root_id: root_id ?? this.root_id,
      message: message ?? this.message,
      type: type ?? this.type,
      props: props ?? this.props,
      file_ids: file_ids ?? this.file_ids,
      priority: priority ?? this.priority,
    );
  }
}
