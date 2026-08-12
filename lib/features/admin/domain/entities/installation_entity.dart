import 'package:equatable/equatable.dart';

class InstallationEntity extends Equatable {
  final String? id;
  final Map<String, dynamic>? allowed_ip_ranges;
  final String? state;

  const InstallationEntity({
    this.id,
    this.allowed_ip_ranges,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        allowed_ip_ranges,
        state,
      ];

  InstallationEntity copyWith({
    String? id,
    Map<String, dynamic>? allowed_ip_ranges,
    String? state,
  }) {
    return InstallationEntity(
      id: id ?? this.id,
      allowed_ip_ranges: allowed_ip_ranges ?? this.allowed_ip_ranges,
      state: state ?? this.state,
    );
  }
}
