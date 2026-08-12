import 'package:equatable/equatable.dart';

class OpenGraphEntity extends Equatable {
  final String? type;
  final String? url;
  final String? title;
  final String? description;
  final String? determiner;
  final String? site_name;
  final String? locale;
  final List<String>? locales_alternate;
  final List<Map<String, dynamic>>? images;
  final List<Map<String, dynamic>>? videos;
  final List<Map<String, dynamic>>? audios;
  final Map<String, dynamic>? article;
  final Map<String, dynamic>? book;
  final Map<String, dynamic>? profile;

  const OpenGraphEntity({
    this.type,
    this.url,
    this.title,
    this.description,
    this.determiner,
    this.site_name,
    this.locale,
    this.locales_alternate,
    this.images,
    this.videos,
    this.audios,
    this.article,
    this.book,
    this.profile,
  });

  @override
  List<Object?> get props => [
        type,
        url,
        title,
        description,
        determiner,
        site_name,
        locale,
        locales_alternate,
        images,
        videos,
        audios,
        article,
        book,
        profile,
      ];

  OpenGraphEntity copyWith({
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
    return OpenGraphEntity(
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
}
