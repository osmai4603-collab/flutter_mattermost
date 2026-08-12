import 'package:equatable/equatable.dart';

class ProductLimitsEntity extends Equatable {
  final dynamic boards;
  final dynamic files;
  final dynamic integrations;
  final dynamic messages;
  final dynamic teams;

  const ProductLimitsEntity({
    this.boards,
    this.files,
    this.integrations,
    this.messages,
    this.teams,
  });

  @override
  List<Object?> get props => [
        boards,
        files,
        integrations,
        messages,
        teams,
      ];

  ProductLimitsEntity copyWith({
    dynamic boards,
    dynamic files,
    dynamic integrations,
    dynamic messages,
    dynamic teams,
  }) {
    return ProductLimitsEntity(
      boards: boards ?? this.boards,
      files: files ?? this.files,
      integrations: integrations ?? this.integrations,
      messages: messages ?? this.messages,
      teams: teams ?? this.teams,
    );
  }
}
