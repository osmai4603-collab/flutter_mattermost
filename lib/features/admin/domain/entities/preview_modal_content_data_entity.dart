import 'package:equatable/equatable.dart';

class PreviewModalContentDataEntity extends Equatable {
  final Map<String, dynamic>? skuLabel;
  final Map<String, dynamic>? title;
  final Map<String, dynamic>? subtitle;
  final String? videoUrl;
  final String? videoPoster;
  final String? useCase;

  const PreviewModalContentDataEntity({
    this.skuLabel,
    this.title,
    this.subtitle,
    this.videoUrl,
    this.videoPoster,
    this.useCase,
  });

  @override
  List<Object?> get props => [
        skuLabel,
        title,
        subtitle,
        videoUrl,
        videoPoster,
        useCase,
      ];

  PreviewModalContentDataEntity copyWith({
    Map<String, dynamic>? skuLabel,
    Map<String, dynamic>? title,
    Map<String, dynamic>? subtitle,
    String? videoUrl,
    String? videoPoster,
    String? useCase,
  }) {
    return PreviewModalContentDataEntity(
      skuLabel: skuLabel ?? this.skuLabel,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      videoUrl: videoUrl ?? this.videoUrl,
      videoPoster: videoPoster ?? this.videoPoster,
      useCase: useCase ?? this.useCase,
    );
  }
}
