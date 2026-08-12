import 'package:flutter_mattermost/features/admin/domain/entities/export_list_entry_entity.dart';

final class ExportListEntryModel extends ExportListEntryEntity {
  const ExportListEntryModel({
    required super.export_name,
    required super.export_no,
    required super.export_size,
    required super.export_type,
  });

  factory ExportListEntryModel.fromMap(Map<String, dynamic> map) {
    return ExportListEntryModel(
      export_name: map["export_name"] as String?,
      export_no: (map["export_no"] as num?)?.toInt(),
      export_size: (map["export_size"] as num?)?.toInt(),
      export_type: map["export_type"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "export_name": export_name,
      "export_no": export_no,
      "export_size": export_size,
      "export_type": export_type,
    };
  }

  factory ExportListEntryModel.fromEntity(ExportListEntryEntity entity) {
    return ExportListEntryModel(
      export_name: entity.export_name,
      export_no: entity.export_no,
      export_size: entity.export_size,
      export_type: entity.export_type,
    );
  }

  ExportListEntryModel copyWith({
    String? export_name,
    int? export_no,
    int? export_size,
    String? export_type,
  }) {
    return ExportListEntryModel(
      export_name: export_name ?? this.export_name,
      export_no: export_no ?? this.export_no,
      export_size: export_size ?? this.export_size,
      export_type: export_type ?? this.export_type,
    );
  }

  ExportListEntryEntity toEntity() => ExportListEntryEntity(
        export_name: export_name,
        export_no: export_no,
        export_size: export_size,
        export_type: export_type,
      );
}
