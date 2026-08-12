import 'package:equatable/equatable.dart';

class DataRetentionPolicyWithoutIdEntity extends Equatable {
  final String? display_name;
  final int? post_duration;

  const DataRetentionPolicyWithoutIdEntity({
    this.display_name,
    this.post_duration,
  });

  @override
  List<Object?> get props => [
        display_name,
        post_duration,
      ];

  DataRetentionPolicyWithoutIdEntity copyWith({
    String? display_name,
    int? post_duration,
  }) {
    return DataRetentionPolicyWithoutIdEntity(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
    );
  }
}
