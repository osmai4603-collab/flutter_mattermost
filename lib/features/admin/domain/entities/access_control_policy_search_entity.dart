import 'package:equatable/equatable.dart';

class AccessControlPolicySearchEntity extends Equatable {
  final String? term;
  final String? type;
  final String? parent_id;
  final List<String>? ids;
  final bool? active;
  final bool? include_children;
  final Map<String, dynamic>? cursor;
  final int? limit;

  const AccessControlPolicySearchEntity({
    this.term,
    this.type,
    this.parent_id,
    this.ids,
    this.active,
    this.include_children,
    this.cursor,
    this.limit,
  });

  @override
  List<Object?> get props => [
        term,
        type,
        parent_id,
        ids,
        active,
        include_children,
        cursor,
        limit,
      ];

  AccessControlPolicySearchEntity copyWith({
    String? term,
    String? type,
    String? parent_id,
    List<String>? ids,
    bool? active,
    bool? include_children,
    Map<String, dynamic>? cursor,
    int? limit,
  }) {
    return AccessControlPolicySearchEntity(
      term: term ?? this.term,
      type: type ?? this.type,
      parent_id: parent_id ?? this.parent_id,
      ids: ids ?? this.ids,
      active: active ?? this.active,
      include_children: include_children ?? this.include_children,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }
}
