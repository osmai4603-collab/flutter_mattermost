import 'package:equatable/equatable.dart';

class StorageUsageEntity extends Equatable {
  final double? bytes;

  const StorageUsageEntity({
    this.bytes,
  });

  @override
  List<Object?> get props => [
        bytes,
      ];

  StorageUsageEntity copyWith({
    double? bytes,
  }) {
    return StorageUsageEntity(
      bytes: bytes ?? this.bytes,
    );
  }
}
