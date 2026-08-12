import 'package:equatable/equatable.dart';

class PropertyFieldRequestEntity extends Equatable {
  final String? name;
  final String? type;
  final Map<String, dynamic>? attrs;

  const PropertyFieldRequestEntity({
    required this.name,
    required this.type,
    this.attrs,
  });

  @override
  List<Object?> get props => [
        name,
        type,
        attrs,
      ];

  PropertyFieldRequestEntity copyWith({
    String? name,
    String? type,
    Map<String, dynamic>? attrs,
  }) {
    return PropertyFieldRequestEntity(
      name: name ?? this.name,
      type: type ?? this.type,
      attrs: attrs ?? this.attrs,
    );
  }
}
