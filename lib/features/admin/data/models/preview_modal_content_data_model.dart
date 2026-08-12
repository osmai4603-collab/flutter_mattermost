import 'package:flutter_mattermost/features/admin/domain/entities/preview_modal_content_data_entity.dart';

final class PreviewModalContentDataModel extends PreviewModalContentDataEntity {
  const PreviewModalContentDataModel({
    required super.skuLabel,
    required super.title,
    required super.subtitle,
    required super.videoUrl,
    required super.videoPoster,
    required super.useCase,
  });

  factory PreviewModalContentDataModel.fromMap(Map<String, dynamic> map) {
    return PreviewModalContentDataModel(
      skuLabel: map["skuLabel"] as Map<String, dynamic>?,
      title: map["title"] as Map<String, dynamic>?,
      subtitle: map["subtitle"] as Map<String, dynamic>?,
      videoUrl: map["videoUrl"] as String?,
      videoPoster: map["videoPoster"] as String?,
      useCase: map["useCase"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "skuLabel": skuLabel,
      "title": title,
      "subtitle": subtitle,
      "videoUrl": videoUrl,
      "videoPoster": videoPoster,
      "useCase": useCase,
    };
  }

  factory PreviewModalContentDataModel.fromEntity(PreviewModalContentDataEntity entity) {
    return PreviewModalContentDataModel(
      skuLabel: entity.skuLabel,
      title: entity.title,
      subtitle: entity.subtitle,
      videoUrl: entity.videoUrl,
      videoPoster: entity.videoPoster,
      useCase: entity.useCase,
    );
  }

  PreviewModalContentDataModel copyWith({
    Map<String, dynamic>? skuLabel,
    Map<String, dynamic>? title,
    Map<String, dynamic>? subtitle,
    String? videoUrl,
    String? videoPoster,
    String? useCase,
  }) {
    return PreviewModalContentDataModel(
      skuLabel: skuLabel ?? this.skuLabel,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      videoUrl: videoUrl ?? this.videoUrl,
      videoPoster: videoPoster ?? this.videoPoster,
      useCase: useCase ?? this.useCase,
    );
  }

  PreviewModalContentDataEntity toEntity() => PreviewModalContentDataEntity(
        skuLabel: skuLabel,
        title: title,
        subtitle: subtitle,
        videoUrl: videoUrl,
        videoPoster: videoPoster,
        useCase: useCase,
      );
}
