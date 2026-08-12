import 'package:flutter_mattermost/features/chat/data/datasources/drafts_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/drafts_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: DraftsRepository)
class DraftsRepositoryImpl implements DraftsRepository {
  final DraftsRemoteDataSource _remoteDataSource;

  DraftsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<DraftModel>> getDraftsForTeam(String userId, String teamId) async {
    final drafts = await _remoteDataSource.getDraftsForTeam(userId, teamId);
    return drafts;
  }

  @override
  Future<DraftModel> saveDraft(DraftModel draft) async {
    final json = await _remoteDataSource.saveDraft(
      channelId: draft.channelId,
      rootId: draft.rootId,
      userId: draft.userId,
      message: draft.message,
      type: draft.type,
      props: draft.propsData,
      fileIds: draft.fileIds,
      metadata: draft.metadata,
      priority: draft.priority,
      createAt: draft.createAt,
      updateAt: draft.updateAt,
      deleteAt: draft.deleteAt,
      fileInfos: draft.fileInfos,
      uploadsInProgress: draft.uploadsInProgress,
    );
    return DraftModel.fromMap(json);
  }

  @override
  Future<void> deleteDraft(String userId, String channelId,
      {String? rootId}) {
    return _remoteDataSource.deleteDraft(userId, channelId, rootId: rootId);
  }
}
