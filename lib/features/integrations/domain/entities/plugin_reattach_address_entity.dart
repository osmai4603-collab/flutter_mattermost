import 'package:equatable/equatable.dart';

class PluginReattachAddressEntity extends Equatable {
  final String? Name;
  final String? Net;

  const PluginReattachAddressEntity({
    this.Name,
    this.Net,
  });

  @override
  List<Object?> get props => [
        Name,
        Net,
      ];

  PluginReattachAddressEntity copyWith({
    String? Name,
    String? Net,
  }) {
    return PluginReattachAddressEntity(
      Name: Name ?? this.Name,
      Net: Net ?? this.Net,
    );
  }
}
