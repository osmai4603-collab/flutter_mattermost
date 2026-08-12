import 'package:equatable/equatable.dart';

class LdapDiagnosticResultEntity extends Equatable {
  final String? test_name;
  final String? test_value;
  final int? total_count;
  final String? message;
  final String? error;
  final List<Map<String, dynamic>>? sample_results;

  const LdapDiagnosticResultEntity({
    this.test_name,
    this.test_value,
    this.total_count,
    this.message,
    this.error,
    this.sample_results,
  });

  @override
  List<Object?> get props => [
        test_name,
        test_value,
        total_count,
        message,
        error,
        sample_results,
      ];

  LdapDiagnosticResultEntity copyWith({
    String? test_name,
    String? test_value,
    int? total_count,
    String? message,
    String? error,
    List<Map<String, dynamic>>? sample_results,
  }) {
    return LdapDiagnosticResultEntity(
      test_name: test_name ?? this.test_name,
      test_value: test_value ?? this.test_value,
      total_count: total_count ?? this.total_count,
      message: message ?? this.message,
      error: error ?? this.error,
      sample_results: sample_results ?? this.sample_results,
    );
  }
}
