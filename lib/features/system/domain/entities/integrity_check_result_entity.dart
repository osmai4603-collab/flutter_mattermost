import 'package:equatable/equatable.dart';

class IntegrityCheckResultEntity extends Equatable {
  final Map<String, dynamic>? data;
  final String? err;

  const IntegrityCheckResultEntity({
    this.data,
    this.err,
  });

  @override
  List<Object?> get props => [
        data,
        err,
      ];

  IntegrityCheckResultEntity copyWith({
    Map<String, dynamic>? data,
    String? err,
  }) {
    return IntegrityCheckResultEntity(
      data: data ?? this.data,
      err: err ?? this.err,
    );
  }
}
