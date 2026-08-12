import 'package:equatable/equatable.dart';

class FilesLimitsEntity extends Equatable {
  final int? total_storage;

  const FilesLimitsEntity({
    this.total_storage,
  });

  @override
  List<Object?> get props => [
        total_storage,
      ];

  FilesLimitsEntity copyWith({
    int? total_storage,
  }) {
    return FilesLimitsEntity(
      total_storage: total_storage ?? this.total_storage,
    );
  }
}
