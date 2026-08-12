import 'package:equatable/equatable.dart';

class ChannelSearchEntity extends Equatable {
  final String? term;
  final List<String>? team_ids;
  final bool? public;
  final bool? private;
  final bool? deleted;
  final bool? include_deleted;

  const ChannelSearchEntity({
    this.term,
    this.team_ids,
    this.public,
    this.private,
    this.deleted,
    this.include_deleted,
  });

  @override
  List<Object?> get props => [
        term,
        team_ids,
        public,
        private,
        deleted,
        include_deleted,
      ];

  ChannelSearchEntity copyWith({
    String? term,
    List<String>? team_ids,
    bool? public,
    bool? private,
    bool? deleted,
    bool? include_deleted,
  }) {
    return ChannelSearchEntity(
      term: term ?? this.term,
      team_ids: team_ids ?? this.team_ids,
      public: public ?? this.public,
      private: private ?? this.private,
      deleted: deleted ?? this.deleted,
      include_deleted: include_deleted ?? this.include_deleted,
    );
  }
}
