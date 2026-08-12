import 'package:equatable/equatable.dart';

class AccessControlPolicyActiveUpdateRequestEntity extends Equatable {
  final List<Map<String, dynamic>>? entries;

  const AccessControlPolicyActiveUpdateRequestEntity({
    this.entries,
  });

  @override
  List<Object?> get props => [
        entries,
      ];

  AccessControlPolicyActiveUpdateRequestEntity copyWith({
    List<Map<String, dynamic>>? entries,
  }) {
    return AccessControlPolicyActiveUpdateRequestEntity(
      entries: entries ?? this.entries,
    );
  }
}
