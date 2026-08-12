import 'package:equatable/equatable.dart';

/// طلب إنشاء سياسة احتفاظ بالبيانات (DataRetentionPolicyCreate):
/// مركّب من بيانات السياسة (DataRetentionPolicyWithoutId) وقوائم الفرق والقنوات.
class DataRetentionPolicyCreateEntity extends Equatable {
  final String? display_name;
  final int? post_duration;
  final List<String>? team_ids;
  final List<String>? channel_ids;

  const DataRetentionPolicyCreateEntity({
    this.display_name,
    this.post_duration,
    this.team_ids,
    this.channel_ids,
  });

  @override
  List<Object?> get props => [
        display_name,
        post_duration,
        team_ids,
        channel_ids,
      ];

  DataRetentionPolicyCreateEntity copyWith({
    String? display_name,
    int? post_duration,
    List<String>? team_ids,
    List<String>? channel_ids,
  }) {
    return DataRetentionPolicyCreateEntity(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      team_ids: team_ids ?? this.team_ids,
      channel_ids: channel_ids ?? this.channel_ids,
    );
  }
}
