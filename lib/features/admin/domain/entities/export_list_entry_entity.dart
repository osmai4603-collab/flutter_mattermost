import 'package:equatable/equatable.dart';

class ExportListEntryEntity extends Equatable {
  final String? export_name;
  final int? export_no;
  final int? export_size;
  final String? export_type;
  const ExportListEntryEntity({
    this.export_name,
    this.export_no,
    this.export_size,
    this.export_type,
  });

  @override
  List<Object?> get props => [
      export_name,
      export_no,
      export_size,
      export_type,
  ];
}
