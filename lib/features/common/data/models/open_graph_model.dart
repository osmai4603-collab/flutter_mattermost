import 'package:flutter_mattermost/features/common/domain/entities/open_graph_entity.dart';

final class OpenGraphModel extends OpenGraphEntity {
  const OpenGraphModel({
    required super.type,
    required super.url,
    required super.title,
    required super.description,
    required super.determiner,
    required super.site_name,
    required super.locale,
    required super.locales_alternate,
    required super.images,
    required super.videos,
    required super.audios,
    required super.article,
    required super.book,
    required super.profile,
  });

  factory OpenGraphModel.fromMap(Map<String, dynamic> map) {
    return OpenGraphModel(
      type: map["type"] as String?,
      url: map["url"] as String?,
      title: map["title"] as String?,
      description: map["description"] as String?,
      determiner: map["determiner"] as String?,
      site_name: map["site_name"] as String?,
      locale: map["locale"] as String?,
      locales_alternate: List<String>.from(map["locales_alternate"] as List<dynamic>? ?? []),
      images: (map["images"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      videos: (map["videos"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      audios: (map["audios"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      article: map["article"] as Map<String, dynamic>?,
      book: map["book"] as Map<String, dynamic>?,
      profile: map["profile"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "url": url,
      "title": title,
      "description": description,
      "determiner": determiner,
      "site_name": site_name,
      "locale": locale,
      "locales_alternate": locales_alternate,
      "images": images,
      "videos": videos,
      "audios": audios,
      "article": article,
      "book": book,
      "profile": profile,
    };
  }

  factory OpenGraphModel.fromEntity(OpenGraphEntity entity) {
    return OpenGraphModel(
      type: entity.type,
      url: entity.url,
      title: entity.title,
      description: entity.description,
      determiner: entity.determiner,
      site_name: entity.site_name,
      locale: entity.locale,
      locales_alternate: entity.locales_alternate,
      images: entity.images,
      videos: entity.videos,
      audios: entity.audios,
      article: entity.article,
      book: entity.book,
      profile: entity.profile,
    );
  }

  @override
  OpenGraphModel copyWith({
    String? type,
    String? url,
    String? title,
    String? description,
    String? determiner,
    String? site_name,
    String? locale,
    List<String>? locales_alternate,
    List<Map<String, dynamic>>? images,
    List<Map<String, dynamic>>? videos,
    List<Map<String, dynamic>>? audios,
    Map<String, dynamic>? article,
    Map<String, dynamic>? book,
    Map<String, dynamic>? profile,
  }) {
    return OpenGraphModel(
      type: type ?? this.type,
      url: url ?? this.url,
      title: title ?? this.title,
      description: description ?? this.description,
      determiner: determiner ?? this.determiner,
      site_name: site_name ?? this.site_name,
      locale: locale ?? this.locale,
      locales_alternate: locales_alternate ?? this.locales_alternate,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      audios: audios ?? this.audios,
      article: article ?? this.article,
      book: book ?? this.book,
      profile: profile ?? this.profile,
    );
  }

  OpenGraphEntity toEntity() => OpenGraphEntity(
        type: type,
        url: url,
        title: title,
        description: description,
        determiner: determiner,
        site_name: site_name,
        locale: locale,
        locales_alternate: locales_alternate,
        images: images,
        videos: videos,
        audios: audios,
        article: article,
        book: book,
        profile: profile,
      );
}
