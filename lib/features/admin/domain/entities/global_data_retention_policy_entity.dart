import 'package:equatable/equatable.dart';

class GlobalDataRetentionPolicyEntity extends Equatable {
  final bool? message_deletion_enabled;
  final bool? file_deletion_enabled;
  final int? message_retention_cutoff;
  final int? file_retention_cutoff;

  const GlobalDataRetentionPolicyEntity({
    this.message_deletion_enabled,
    this.file_deletion_enabled,
    this.message_retention_cutoff,
    this.file_retention_cutoff,
  });

  @override
  List<Object?> get props => [
        message_deletion_enabled,
        file_deletion_enabled,
        message_retention_cutoff,
        file_retention_cutoff,
      ];

  GlobalDataRetentionPolicyEntity copyWith({
    bool? message_deletion_enabled,
    bool? file_deletion_enabled,
    int? message_retention_cutoff,
    int? file_retention_cutoff,
  }) {
    return GlobalDataRetentionPolicyEntity(
      message_deletion_enabled: message_deletion_enabled ?? this.message_deletion_enabled,
      file_deletion_enabled: file_deletion_enabled ?? this.file_deletion_enabled,
      message_retention_cutoff: message_retention_cutoff ?? this.message_retention_cutoff,
      file_retention_cutoff: file_retention_cutoff ?? this.file_retention_cutoff,
    );
  }
}
