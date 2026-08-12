import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_reattach_address_entity.dart';

final class PluginReattachAddressModel extends PluginReattachAddressEntity {
  const PluginReattachAddressModel({
    required super.Name,
    required super.Net,
  });

  factory PluginReattachAddressModel.fromMap(Map<String, dynamic> map) {
    return PluginReattachAddressModel(
      Name: map["Name"] as String?,
      Net: map["Net"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Name": Name,
      "Net": Net,
    };
  }

  factory PluginReattachAddressModel.fromEntity(PluginReattachAddressEntity entity) {
    return PluginReattachAddressModel(
      Name: entity.Name,
      Net: entity.Net,
    );
  }

  @override
  PluginReattachAddressModel copyWith({
    String? Name,
    String? Net,
  }) {
    return PluginReattachAddressModel(
      Name: Name ?? this.Name,
      Net: Net ?? this.Net,
    );
  }

  PluginReattachAddressEntity toEntity() => PluginReattachAddressEntity(
        Name: Name,
        Net: Net,
      );
}
