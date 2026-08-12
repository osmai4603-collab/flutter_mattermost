import 'package:flutter_mattermost/features/system/domain/entities/integrity_check_result_entity.dart';

final class IntegrityCheckResultModel extends IntegrityCheckResultEntity {
  const IntegrityCheckResultModel({
    required super.data,
    required super.err,
  });

  factory IntegrityCheckResultModel.fromMap(Map<String, dynamic> map) {
    return IntegrityCheckResultModel(
      data: map["data"] as Map<String, dynamic>?,
      err: map["err"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "data": data,
      "err": err,
    };
  }

  factory IntegrityCheckResultModel.fromEntity(IntegrityCheckResultEntity entity) {
    return IntegrityCheckResultModel(
      data: entity.data,
      err: entity.err,
    );
  }

  @override
  IntegrityCheckResultModel copyWith({
    Map<String, dynamic>? data,
    String? err,
  }) {
    return IntegrityCheckResultModel(
      data: data ?? this.data,
      err: err ?? this.err,
    );
  }

  IntegrityCheckResultEntity toEntity() => IntegrityCheckResultEntity(
        data: data,
        err: err,
      );
}
