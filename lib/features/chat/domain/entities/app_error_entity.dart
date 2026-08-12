import 'package:equatable/equatable.dart';

class AppErrorEntity extends Equatable {
  final int? status_code;
  final String? id;
  final String? message;
  final String? request_id;

  const AppErrorEntity({
    this.status_code,
    this.id,
    this.message,
    this.request_id,
  });

  @override
  List<Object?> get props => [
        status_code,
        id,
        message,
        request_id,
      ];

  AppErrorEntity copyWith({
    int? status_code,
    String? id,
    String? message,
    String? request_id,
  }) {
    return AppErrorEntity(
      status_code: status_code ?? this.status_code,
      id: id ?? this.id,
      message: message ?? this.message,
      request_id: request_id ?? this.request_id,
    );
  }
}
