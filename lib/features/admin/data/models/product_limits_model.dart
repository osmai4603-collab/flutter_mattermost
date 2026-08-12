import 'package:flutter_mattermost/features/admin/domain/entities/product_limits_entity.dart';

final class ProductLimitsModel extends ProductLimitsEntity {
  const ProductLimitsModel({
    required super.boards,
    required super.files,
    required super.integrations,
    required super.messages,
    required super.teams,
  });

  factory ProductLimitsModel.fromMap(Map<String, dynamic> map) {
    return ProductLimitsModel(
      boards: map["boards"] ?? null,
      files: map["files"] ?? null,
      integrations: map["integrations"] ?? null,
      messages: map["messages"] ?? null,
      teams: map["teams"] ?? null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "boards": boards,
      "files": files,
      "integrations": integrations,
      "messages": messages,
      "teams": teams,
    };
  }

  factory ProductLimitsModel.fromEntity(ProductLimitsEntity entity) {
    return ProductLimitsModel(
      boards: entity.boards,
      files: entity.files,
      integrations: entity.integrations,
      messages: entity.messages,
      teams: entity.teams,
    );
  }

  ProductLimitsModel copyWith({
    dynamic boards,
    dynamic files,
    dynamic integrations,
    dynamic messages,
    dynamic teams,
  }) {
    return ProductLimitsModel(
      boards: boards ?? this.boards,
      files: files ?? this.files,
      integrations: integrations ?? this.integrations,
      messages: messages ?? this.messages,
      teams: teams ?? this.teams,
    );
  }

  ProductLimitsEntity toEntity() => ProductLimitsEntity(
        boards: boards,
        files: files,
        integrations: integrations,
        messages: messages,
        teams: teams,
      );
}
