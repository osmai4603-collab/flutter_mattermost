import 'package:equatable/equatable.dart';

class FileInfoListEntity extends Equatable {
  final List<String>? order;
  final Map<String, dynamic>? file_infos;
  final String? next_file_id;
  final String? prev_file_id;

  const FileInfoListEntity({
    this.order,
    this.file_infos,
    this.next_file_id,
    this.prev_file_id,
  });

  @override
  List<Object?> get props => [order, file_infos, next_file_id, prev_file_id];

  FileInfoListEntity copyWith({
    List<String>? order,
    Map<String, dynamic>? file_infos,
    String? next_file_id,
    String? prev_file_id,
  }) {
    return FileInfoListEntity(
      order: order ?? this.order,
      file_infos: file_infos ?? this.file_infos,
      next_file_id: next_file_id ?? this.next_file_id,
      prev_file_id: prev_file_id ?? this.prev_file_id,
    );
  }
}
