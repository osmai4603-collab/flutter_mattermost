import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/system/data/models/emoji_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

abstract class EmojiRemoteDataSource {
  Future<List<EmojiModel>> getCustomEmojis({
    int page = 0,
    int perPage = 60,
    String? sort,
  });
  Future<EmojiModel> createCustomEmoji({
    required String name,
    required String creatorId,
    required String imagePath,
  });
  Future<List<EmojiModel>> getCustomEmojisByNames(List<String> names);
  Future<List<EmojiModel>> searchCustomEmoji({
    String? name,
    String? prefix,
    int page = 0,
    int perPage = 60,
  });
  Future<List<EmojiModel>> autocompleteCustomEmoji({
    String? name,
    String? prefix,
  });
  Future<EmojiModel> getCustomEmojiByName(String name);
  Future<EmojiModel> getCustomEmoji(String emojiId);
  Future<void> deleteCustomEmoji(String emojiId);
}

@LazySingleton(as: EmojiRemoteDataSource)
class EmojiRemoteDataSourceImpl implements EmojiRemoteDataSource {
  final ApiClient _apiClient;

  EmojiRemoteDataSourceImpl(this._apiClient);

  List<EmojiModel> _parseList(ApiResult<List<EmojiModel>> result, String error) {
    if (result is ApiSuccess<List<EmojiModel>>) {
      return result.data;
    }
    throw Exception(error);
  }

  @override
  Future<List<EmojiModel>> getCustomEmojis({
    int page = 0,
    int perPage = 60,
    String? sort,
  }) async {
    final result = await _apiClient.get<List<EmojiModel>>(
      EmojiEndPoint.root,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (sort != null) 'sort': sort,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return _parseList(result, 'Failed to get custom emojis');
  }

  @override
  Future<EmojiModel> createCustomEmoji({
    required String name,
    required String creatorId,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'creator_id': creatorId,
      'image': await MultipartFile.fromFile(imagePath),
    });
    final response = await _apiClient.dio.post(
      EmojiEndPoint.root,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create custom emoji');
    }
    return EmojiModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<EmojiModel>> getCustomEmojisByNames(List<String> names) async {
    final result = await _apiClient.post<List<EmojiModel>>(
      EmojiEndPoint.names,
      data: names,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return _parseList(result, 'Failed to get emojis by names');
  }

  @override
  Future<List<EmojiModel>> searchCustomEmoji({
    String? name,
    String? prefix,
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.post<List<EmojiModel>>(
      EmojiEndPoint.search,
      data: {
        if (name != null) 'name': name,
        if (prefix != null) 'prefix': prefix,
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return _parseList(result, 'Failed to search custom emojis');
  }

  @override
  Future<List<EmojiModel>> autocompleteCustomEmoji({
    String? name,
    String? prefix,
  }) async {
    final result = await _apiClient.get<List<EmojiModel>>(
      EmojiEndPoint.autocomplete,
      queryParameters: {
        if (name != null) 'name': name,
        if (prefix != null) 'prefix': prefix,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    return _parseList(result, 'Failed to autocomplete emojis');
  }

  @override
  Future<EmojiModel> getCustomEmojiByName(String name) async {
    final result = await _apiClient.get<EmojiModel>(
      EmojiEndPoint.name(name),
      fromJson: (json) => EmojiModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<EmojiModel>) {
      return result.data;
    }
    throw Exception('Failed to get emoji by name');
  }

  @override
  Future<EmojiModel> getCustomEmoji(String emojiId) async {
    final result = await _apiClient.get<EmojiModel>(
      EmojiEndPoint.byEmojiId(emojiId),
      fromJson: (json) => EmojiModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<EmojiModel>) {
      return result.data;
    }
    throw Exception('Failed to get emoji $emojiId');
  }

  @override
  Future<void> deleteCustomEmoji(String emojiId) async {
    final result = await _apiClient.delete(EmojiEndPoint.byEmojiId(emojiId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete emoji $emojiId');
    }
  }
}
