import 'package:equatable/equatable.dart';

class IntegrationsLimitsEntity extends Equatable {
  final int? enabled;

  const IntegrationsLimitsEntity({
    this.enabled,
  });

  @override
  List<Object?> get props => [
        enabled,
      ];

  IntegrationsLimitsEntity copyWith({
    int? enabled,
  }) {
    return IntegrationsLimitsEntity(
      enabled: enabled ?? this.enabled,
    );
  }
}
