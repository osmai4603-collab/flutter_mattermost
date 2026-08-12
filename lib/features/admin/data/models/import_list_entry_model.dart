import 'package:flutter_mattermost/features/admin/domain/entities/import_list_entry_entity.dart';

final class ImportListEntryModel extends ImportListEntryEntity {
  const ImportListEntryModel({
    required super.import_name,
    required super.import_no,
    required super.import_type,
  });

  factory ImportListEntryModel.fromMap(Map<String, dynamic> map) {
    return ImportListEntryModel(
      import_name: map["import_name"] as String?,
      import_no: (map["import_no"] as num?)?.toInt(),
      import_type: map["import_type"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "import_name": import_name,
      "import_no": import_no,
      "import_type": import_type,
    };
  }

  factory ImportListEntryModel.fromEntity(ImportListEntryEntity entity) {
    return ImportListEntryModel(
      import_name: entity.import_name,
      import_no: entity.import_no,
      import_type: entity.import_type,
    );
  }

  ImportListEntryModel copyWith({
    String? import_name,
    int? import_no,
    String? import_type,
  }) {
    return ImportListEntryModel(
      import_name: import_name ?? this.import_name,
      import_no: import_no ?? this.import_no,
      import_type: import_type ?? this.import_type,
    );
  }

  ImportListEntryEntity toEntity() => ImportListEntryEntity(
        import_name: import_name,
        import_no: import_no,
        import_type: import_type,
      );
}
