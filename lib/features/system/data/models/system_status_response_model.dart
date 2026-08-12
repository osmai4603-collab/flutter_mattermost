import 'package:flutter_mattermost/features/system/domain/entities/system_status_response_entity.dart';

final class SystemStatusResponseModel extends SystemStatusResponseEntity {
  const SystemStatusResponseModel({
    required super.AndroidLatestVersion,
    required super.AndroidMinVersion,
    required super.DesktopLatestVersion,
    required super.DesktopMinVersion,
    required super.IosLatestVersion,
    required super.IosMinVersion,
    required super.database_status,
    required super.filestore_status,
    required super.status,
    required super.CanReceiveNotifications,
  });

  factory SystemStatusResponseModel.fromMap(Map<String, dynamic> map) {
    return SystemStatusResponseModel(
      AndroidLatestVersion: map["AndroidLatestVersion"] as String?,
      AndroidMinVersion: map["AndroidMinVersion"] as String?,
      DesktopLatestVersion: map["DesktopLatestVersion"] as String?,
      DesktopMinVersion: map["DesktopMinVersion"] as String?,
      IosLatestVersion: map["IosLatestVersion"] as String?,
      IosMinVersion: map["IosMinVersion"] as String?,
      database_status: map["database_status"] as String?,
      filestore_status: map["filestore_status"] as String?,
      status: map["status"] as String?,
      CanReceiveNotifications: map["CanReceiveNotifications"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "AndroidLatestVersion": AndroidLatestVersion,
      "AndroidMinVersion": AndroidMinVersion,
      "DesktopLatestVersion": DesktopLatestVersion,
      "DesktopMinVersion": DesktopMinVersion,
      "IosLatestVersion": IosLatestVersion,
      "IosMinVersion": IosMinVersion,
      "database_status": database_status,
      "filestore_status": filestore_status,
      "status": status,
      "CanReceiveNotifications": CanReceiveNotifications,
    };
  }

  factory SystemStatusResponseModel.fromEntity(SystemStatusResponseEntity entity) {
    return SystemStatusResponseModel(
      AndroidLatestVersion: entity.AndroidLatestVersion,
      AndroidMinVersion: entity.AndroidMinVersion,
      DesktopLatestVersion: entity.DesktopLatestVersion,
      DesktopMinVersion: entity.DesktopMinVersion,
      IosLatestVersion: entity.IosLatestVersion,
      IosMinVersion: entity.IosMinVersion,
      database_status: entity.database_status,
      filestore_status: entity.filestore_status,
      status: entity.status,
      CanReceiveNotifications: entity.CanReceiveNotifications,
    );
  }

  @override
  SystemStatusResponseModel copyWith({
    String? AndroidLatestVersion,
    String? AndroidMinVersion,
    String? DesktopLatestVersion,
    String? DesktopMinVersion,
    String? IosLatestVersion,
    String? IosMinVersion,
    String? database_status,
    String? filestore_status,
    String? status,
    String? CanReceiveNotifications,
  }) {
    return SystemStatusResponseModel(
      AndroidLatestVersion: AndroidLatestVersion ?? this.AndroidLatestVersion,
      AndroidMinVersion: AndroidMinVersion ?? this.AndroidMinVersion,
      DesktopLatestVersion: DesktopLatestVersion ?? this.DesktopLatestVersion,
      DesktopMinVersion: DesktopMinVersion ?? this.DesktopMinVersion,
      IosLatestVersion: IosLatestVersion ?? this.IosLatestVersion,
      IosMinVersion: IosMinVersion ?? this.IosMinVersion,
      database_status: database_status ?? this.database_status,
      filestore_status: filestore_status ?? this.filestore_status,
      status: status ?? this.status,
      CanReceiveNotifications: CanReceiveNotifications ?? this.CanReceiveNotifications,
    );
  }

  SystemStatusResponseEntity toEntity() => SystemStatusResponseEntity(
        AndroidLatestVersion: AndroidLatestVersion,
        AndroidMinVersion: AndroidMinVersion,
        DesktopLatestVersion: DesktopLatestVersion,
        DesktopMinVersion: DesktopMinVersion,
        IosLatestVersion: IosLatestVersion,
        IosMinVersion: IosMinVersion,
        database_status: database_status,
        filestore_status: filestore_status,
        status: status,
        CanReceiveNotifications: CanReceiveNotifications,
      );
}
