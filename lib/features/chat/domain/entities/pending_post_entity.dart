import 'package:equatable/equatable.dart';

enum PendingPostStatus {
  pending,
  sending,
  failedNetwork,
  failedPermanent,
  delivered,
}

class PendingPostEntity extends Equatable {
  final String id; // Local UUID
  final String channelId;
  final String message;
  final String rootId;
  final List<String> fileIds;
  final PendingPostStatus status;
  final int retryCount;
  final int createdAt;
  final int lastAttemptAt;

  const PendingPostEntity({
    required this.id,
    required this.channelId,
    required this.message,
    this.rootId = '',
    this.fileIds = const [],
    this.status = PendingPostStatus.pending,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt = 0,
  });

  PendingPostEntity copyWith({
    String? id,
    String? channelId,
    String? message,
    String? rootId,
    List<String>? fileIds,
    PendingPostStatus? status,
    int? retryCount,
    int? createdAt,
    int? lastAttemptAt,
  }) {
    return PendingPostEntity(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      message: message ?? this.message,
      rootId: rootId ?? this.rootId,
      fileIds: fileIds ?? this.fileIds,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        message,
        rootId,
        fileIds,
        status,
        retryCount,
        createdAt,
        lastAttemptAt,
      ];
}
