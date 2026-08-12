import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_bookmark_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ChannelBookmarksRemoteDataSource {
  Future<List<ChannelBookmarkModel>> getChannelBookmarks(String channelId);
  Future<ChannelBookmarkModel> createChannelBookmark(
    String channelId, {
    String? linkUrl,
    String? postId,
    String? fileId,
    String? emoji,
    String? label,
  });
  Future<void> deleteChannelBookmark(String channelId, String bookmarkId);
  Future<ChannelBookmarkModel> updateChannelBookmark(
    String channelId,
    String bookmarkId, {
    String? linkUrl,
    String? label,
    String? emoji,
  });
  Future<ChannelBookmarkModel> updateChannelBookmarkSortOrder(
    String channelId,
    String bookmarkId,
    int sortOrder,
  );
}

@LazySingleton(as: ChannelBookmarksRemoteDataSource)
class ChannelBookmarksRemoteDataSourceImpl
    implements ChannelBookmarksRemoteDataSource {
  final ApiClient _apiClient;

  ChannelBookmarksRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ChannelBookmarkModel>> getChannelBookmarks(String channelId) async {
    final result = await _apiClient.get<List<ChannelBookmarkModel>>(
      ChannelsEndPoint.bookmarks(channelId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelBookmarkModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelBookmarkModel>>) {
      return result.data;
    }
    throw Exception('Failed to get bookmarks of channel $channelId');
  }

  @override
  Future<ChannelBookmarkModel> createChannelBookmark(
    String channelId, {
    String? linkUrl,
    String? postId,
    String? fileId,
    String? emoji,
    String? label,
  }) async {
    final result = await _apiClient.post<ChannelBookmarkModel>(
      ChannelsEndPoint.bookmarks(channelId),
      data: {
        if (linkUrl != null) 'link_url': linkUrl,
        if (postId != null) 'post_id': postId,
        if (fileId != null) 'file_id': fileId,
        if (emoji != null) 'emoji': emoji,
        if (label != null) 'label': label,
      },
      fromJson: (json) =>
          ChannelBookmarkModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelBookmarkModel>) {
      return result.data;
    }
    throw Exception('Failed to create bookmark in channel $channelId');
  }

  @override
  Future<void> deleteChannelBookmark(
    String channelId,
    String bookmarkId,
  ) async {
    await _apiClient.delete(ChannelsEndPoint.bookmarks2(channelId, bookmarkId));
  }

  @override
  Future<ChannelBookmarkModel> updateChannelBookmark(
    String channelId,
    String bookmarkId, {
    String? linkUrl,
    String? label,
    String? emoji,
  }) async {
    final result = await _apiClient.patch<ChannelBookmarkModel>(
      ChannelsEndPoint.bookmarks2(channelId, bookmarkId),
      data: {
        if (linkUrl != null) 'link_url': linkUrl,
        if (label != null) 'label': label,
        if (emoji != null) 'emoji': emoji,
      },
      fromJson: (json) =>
          ChannelBookmarkModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelBookmarkModel>) {
      return result.data;
    }
    throw Exception('Failed to update bookmark $bookmarkId');
  }

  @override
  Future<ChannelBookmarkModel> updateChannelBookmarkSortOrder(
    String channelId,
    String bookmarkId,
    int sortOrder,
  ) async {
    final result = await _apiClient.post<ChannelBookmarkModel>(
      ChannelsEndPoint.bookmarksSortOrder(channelId, bookmarkId),
      data: {'sort_order': sortOrder},
      fromJson: (json) =>
          ChannelBookmarkModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelBookmarkModel>) {
      return result.data;
    }
    throw Exception('Failed to update sort order of bookmark $bookmarkId');
  }
}
