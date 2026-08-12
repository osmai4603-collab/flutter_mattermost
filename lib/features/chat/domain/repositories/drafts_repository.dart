import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';

/// مستودع المسودات — /drafts.
abstract class DraftsRepository {
  Future<List<DraftModel>> getDraftsForTeam(String userId, String teamId);

  Future<DraftModel> saveDraft(DraftModel draft);

  Future<void> deleteDraft(String userId, String channelId, {String? rootId});
}
