import 'package:equatable/equatable.dart';

class SystemStatusResponseEntity extends Equatable {
  final String? AndroidLatestVersion;
  final String? AndroidMinVersion;
  final String? DesktopLatestVersion;
  final String? DesktopMinVersion;
  final String? IosLatestVersion;
  final String? IosMinVersion;
  final String? database_status;
  final String? filestore_status;
  final String? status;
  final String? CanReceiveNotifications;

  const SystemStatusResponseEntity({
    this.AndroidLatestVersion,
    this.AndroidMinVersion,
    this.DesktopLatestVersion,
    this.DesktopMinVersion,
    this.IosLatestVersion,
    this.IosMinVersion,
    this.database_status,
    this.filestore_status,
    this.status,
    this.CanReceiveNotifications,
  });

  @override
  List<Object?> get props => [
    AndroidLatestVersion,
    AndroidMinVersion,
    DesktopLatestVersion,
    DesktopMinVersion,
    IosLatestVersion,
    IosMinVersion,
    database_status,
    filestore_status,
    status,
    CanReceiveNotifications,
  ];

  SystemStatusResponseEntity copyWith({
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
    return SystemStatusResponseEntity(
      AndroidLatestVersion: AndroidLatestVersion ?? this.AndroidLatestVersion,
      AndroidMinVersion: AndroidMinVersion ?? this.AndroidMinVersion,
      DesktopLatestVersion: DesktopLatestVersion ?? this.DesktopLatestVersion,
      DesktopMinVersion: DesktopMinVersion ?? this.DesktopMinVersion,
      IosLatestVersion: IosLatestVersion ?? this.IosLatestVersion,
      IosMinVersion: IosMinVersion ?? this.IosMinVersion,
      database_status: database_status ?? this.database_status,
      filestore_status: filestore_status ?? this.filestore_status,
      status: status ?? this.status,
      CanReceiveNotifications:
          CanReceiveNotifications ?? this.CanReceiveNotifications,
    );
  }
}
