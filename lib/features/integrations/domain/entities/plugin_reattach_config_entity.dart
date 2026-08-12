import 'package:equatable/equatable.dart';

class PluginReattachConfigEntity extends Equatable {
  final String? Protocol;
  final int? ProtocolVersion;
  final Map<String, dynamic>? Addr;
  final int? Pid;
  final bool? Test;

  const PluginReattachConfigEntity({
    this.Protocol,
    this.ProtocolVersion,
    this.Addr,
    this.Pid,
    this.Test,
  });

  @override
  List<Object?> get props => [
        Protocol,
        ProtocolVersion,
        Addr,
        Pid,
        Test,
      ];

  PluginReattachConfigEntity copyWith({
    String? Protocol,
    int? ProtocolVersion,
    Map<String, dynamic>? Addr,
    int? Pid,
    bool? Test,
  }) {
    return PluginReattachConfigEntity(
      Protocol: Protocol ?? this.Protocol,
      ProtocolVersion: ProtocolVersion ?? this.ProtocolVersion,
      Addr: Addr ?? this.Addr,
      Pid: Pid ?? this.Pid,
      Test: Test ?? this.Test,
    );
  }
}
