import 'package:equatable/equatable.dart';

class InstallMarketplacePluginRequestEntity extends Equatable {
  final String? id;
  final String? version;

  const InstallMarketplacePluginRequestEntity({
    required this.id,
    this.version,
  });

  @override
  List<Object?> get props => [
        id,
        version,
      ];

  InstallMarketplacePluginRequestEntity copyWith({
    String? id,
    String? version,
  }) {
    return InstallMarketplacePluginRequestEntity(
      id: id ?? this.id,
      version: version ?? this.version,
    );
  }
}
