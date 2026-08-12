// ignore_for_file: use_null_aware_elements

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/system/data/models/emoji_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class EmojiRemoteDataSource {
  Future<List<EmojiModel>> getEmojiList({
    int page = 0,
    int perPage = 60,
    String? sort,
  });
  Future<EmojiModel> getEmojiById(String emojiId);
  Future<EmojiModel> getEmojiByName(String emojiName);
  Future<Uint8List> getEmojiImageBytes(String emojiId);
  Future<EmojiModel> createEmoji(String name, String imagePath);
  Future<void> deleteEmoji(String emojiId);
  Future<List<EmojiModel>> searchEmoji(Map<String, dynamic> searchParams);
  Future<List<EmojiModel>> autocompleteEmoji(String name);
  Future<List<String>> getEmojiNames(List<Map<String, dynamic>> emojiIds);
}

@LazySingleton(as: EmojiRemoteDataSource)
class EmojiRemoteDataSourceImpl implements EmojiRemoteDataSource {
  final ApiClient _apiClient;

  EmojiRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<EmojiModel>> getEmojiList({
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
    if (result is ApiSuccess<List<EmojiModel>>) {
      return result.data;
    }
    throw Exception('Failed to get emoji list');
  }

  @override
  Future<EmojiModel> getEmojiById(String emojiId) async {
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
  Future<EmojiModel> getEmojiByName(String emojiName) async {
    final result = await _apiClient.get<EmojiModel>(
      EmojiEndPoint.name(emojiName),
      fromJson: (json) => EmojiModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<EmojiModel>) {
      return result.data;
    }
    throw Exception('Failed to get emoji by name $emojiName');
  }

  @override
  Future<Uint8List> getEmojiImageBytes(String emojiId) async {
    final response = await _apiClient.dio.get(
      EmojiEndPoint.image(emojiId),
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get image of emoji $emojiId');
    }
    return response.data as Uint8List;
  }

  @override
  Future<EmojiModel> createEmoji(String name, String imagePath) async {
    final formData = FormData.fromMap({
      'emoji': await MultipartFile.fromFile(imagePath),
      'name': name,
    });
    final response = await _apiClient.dio.post(
      EmojiEndPoint.root,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create emoji $name');
    }
    return EmojiModel.fromMap(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteEmoji(String emojiId) async {
    await _apiClient.delete(EmojiEndPoint.byEmojiId(emojiId));
  }

  @override
  Future<List<EmojiModel>> searchEmoji(Map<String, dynamic> searchParams) async {
    final result = await _apiClient.post<List<EmojiModel>>(
      EmojiEndPoint.search,
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<EmojiModel>>) {
      return result.data;
    }
    throw Exception('Failed to search emoji');
  }

  @override
  Future<List<EmojiModel>> autocompleteEmoji(String name) async {
    final result = await _apiClient.get<List<EmojiModel>>(
      EmojiEndPoint.autocomplete,
      queryParameters: {'name': name},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => EmojiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<EmojiModel>>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete emoji');
  }

  @override
  Future<List<String>> getEmojiNames(
    List<Map<String, dynamic>> emojiIds,
  ) async {
    final result = await _apiClient.post<List<String>>(
      EmojiEndPoint.names,
      data: emojiIds,
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get emoji names');
  }
}
