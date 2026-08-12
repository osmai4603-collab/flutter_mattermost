import 'package:equatable/equatable.dart';

class ImportListEntryEntity extends Equatable {
  final String? import_name;
  final int? import_no;
  final String? import_type;
  const ImportListEntryEntity({
    this.import_name,
    this.import_no,
    this.import_type,
  });

  @override
  List<Object?> get props => [
      import_name,
      import_no,
      import_type,
  ];
}
