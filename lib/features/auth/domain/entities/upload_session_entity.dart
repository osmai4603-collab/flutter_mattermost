import 'package:equatable/equatable.dart';

class UploadSessionEntity extends Equatable {
  final String? id;
  final String? type;
  final int? create_at;
  final String? user_id;
  final String? channel_id;
  final String? filename;
  final int? file_size;
  final int? file_offset;

  const UploadSessionEntity({
    this.id,
    this.type,
    this.create_at,
    this.user_id,
    this.channel_id,
    this.filename,
    this.file_size,
    this.file_offset,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        create_at,
        user_id,
        channel_id,
        filename,
        file_size,
        file_offset,
      ];

  UploadSessionEntity copyWith({
    String? id,
    String? type,
    int? create_at,
    String? user_id,
    String? channel_id,
    String? filename,
    int? file_size,
    int? file_offset,
  }) {
    return UploadSessionEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      create_at: create_at ?? this.create_at,
      user_id: user_id ?? this.user_id,
      channel_id: channel_id ?? this.channel_id,
      filename: filename ?? this.filename,
      file_size: file_size ?? this.file_size,
      file_offset: file_offset ?? this.file_offset,
    );
  }
}
