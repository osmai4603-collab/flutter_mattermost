import 'package:flutter_mattermost/features/auth/domain/entities/ldap_diagnostic_result_entity.dart';

final class LdapDiagnosticResultModel extends LdapDiagnosticResultEntity {
  const LdapDiagnosticResultModel({
    required super.test_name,
    required super.test_value,
    required super.total_count,
    required super.message,
    required super.error,
    required super.sample_results,
  });

  factory LdapDiagnosticResultModel.fromMap(Map<String, dynamic> map) {
    return LdapDiagnosticResultModel(
      test_name: map["test_name"] as String?,
      test_value: map["test_value"] as String?,
      total_count: (map["total_count"] as num?)?.toInt(),
      message: map["message"] as String?,
      error: map["error"] as String?,
      sample_results: (map["sample_results"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "test_name": test_name,
      "test_value": test_value,
      "total_count": total_count,
      "message": message,
      "error": error,
      "sample_results": sample_results,
    };
  }

  factory LdapDiagnosticResultModel.fromEntity(LdapDiagnosticResultEntity entity) {
    return LdapDiagnosticResultModel(
      test_name: entity.test_name,
      test_value: entity.test_value,
      total_count: entity.total_count,
      message: entity.message,
      error: entity.error,
      sample_results: entity.sample_results,
    );
  }

  @override
  LdapDiagnosticResultModel copyWith({
    String? test_name,
    String? test_value,
    int? total_count,
    String? message,
    String? error,
    List<Map<String, dynamic>>? sample_results,
  }) {
    return LdapDiagnosticResultModel(
      test_name: test_name ?? this.test_name,
      test_value: test_value ?? this.test_value,
      total_count: total_count ?? this.total_count,
      message: message ?? this.message,
      error: error ?? this.error,
      sample_results: sample_results ?? this.sample_results,
    );
  }

  LdapDiagnosticResultEntity toEntity() => LdapDiagnosticResultEntity(
        test_name: test_name,
        test_value: test_value,
        total_count: total_count,
        message: message,
        error: error,
        sample_results: sample_results,
      );
}
