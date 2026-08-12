import 'package:flutter_mattermost/features/integrations/domain/entities/plugin_reattach_config_entity.dart';

final class PluginReattachConfigModel extends PluginReattachConfigEntity {
  const PluginReattachConfigModel({
    required super.Protocol,
    required super.ProtocolVersion,
    required super.Addr,
    required super.Pid,
    required super.Test,
  });

  factory PluginReattachConfigModel.fromMap(Map<String, dynamic> map) {
    return PluginReattachConfigModel(
      Protocol: map["Protocol"] as String?,
      ProtocolVersion: (map["ProtocolVersion"] as num?)?.toInt(),
      Addr: map["Addr"] as Map<String, dynamic>?,
      Pid: (map["Pid"] as num?)?.toInt(),
      Test: map["Test"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Protocol": Protocol,
      "ProtocolVersion": ProtocolVersion,
      "Addr": Addr,
      "Pid": Pid,
      "Test": Test,
    };
  }

  factory PluginReattachConfigModel.fromEntity(PluginReattachConfigEntity entity) {
    return PluginReattachConfigModel(
      Protocol: entity.Protocol,
      ProtocolVersion: entity.ProtocolVersion,
      Addr: entity.Addr,
      Pid: entity.Pid,
      Test: entity.Test,
    );
  }

  @override
  PluginReattachConfigModel copyWith({
    String? Protocol,
    int? ProtocolVersion,
    Map<String, dynamic>? Addr,
    int? Pid,
    bool? Test,
  }) {
    return PluginReattachConfigModel(
      Protocol: Protocol ?? this.Protocol,
      ProtocolVersion: ProtocolVersion ?? this.ProtocolVersion,
      Addr: Addr ?? this.Addr,
      Pid: Pid ?? this.Pid,
      Test: Test ?? this.Test,
    );
  }

  PluginReattachConfigEntity toEntity() => PluginReattachConfigEntity(
        Protocol: Protocol,
        ProtocolVersion: ProtocolVersion,
        Addr: Addr,
        Pid: Pid,
        Test: Test,
      );
}
