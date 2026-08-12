import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/core/enums/draft_type.dart';

class DraftEntity extends Equatable {
  final String channelId;
  final String rootId;
  final String userId;
  final String message;
  final DraftType type;
  final Map<String, dynamic> propsData;
  final List<String> fileIds;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> priority;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final List<Map<String, dynamic>> fileInfos;
  final List<Map<String, dynamic>> uploadsInProgress;

  const DraftEntity({
    required this.channelId,
    this.rootId = '',
    this.userId = '',
    required this.message,
    this.type = DraftType.defaultType,
    this.propsData = const {},
    this.fileIds = const [],
    this.metadata = const {},
    this.priority = const {},
    this.createAt = 0,
    required this.updateAt,
    this.deleteAt = 0,
    this.fileInfos = const [],
    this.uploadsInProgress = const [],
  });

  DraftEntity copyWith({
    String? channelId,
    String? rootId,
    String? userId,
    String? message,
    DraftType? type,
    Map<String, dynamic>? propsData,
    List<String>? fileIds,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? priority,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    List<Map<String, dynamic>>? fileInfos,
    List<Map<String, dynamic>>? uploadsInProgress,
  }) {
    return DraftEntity(
      channelId: channelId ?? this.channelId,
      rootId: rootId ?? this.rootId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      propsData: propsData ?? this.propsData,
      fileIds: fileIds ?? this.fileIds,
      metadata: metadata ?? this.metadata,
      priority: priority ?? this.priority,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      fileInfos: fileInfos ?? this.fileInfos,
      uploadsInProgress: uploadsInProgress ?? this.uploadsInProgress,
    );
  }

  @override
  List<Object?> get props => [
        channelId,
        rootId,
        userId,
        message,
        type,
        propsData,
        fileIds,
        metadata,
        priority,
        createAt,
        updateAt,
        deleteAt,
        fileInfos,
        uploadsInProgress,
      ];
}