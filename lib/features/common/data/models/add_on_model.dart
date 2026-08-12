import 'package:flutter_mattermost/features/common/domain/entities/add_on_entity.dart';

final class AddOnModel extends AddOnEntity {
  const AddOnModel({
    required super.id,
    required super.name,
    required super.display_name,
    required super.price_per_seat,
  });

  factory AddOnModel.fromMap(Map<String, dynamic> map) {
    return AddOnModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      display_name: map["display_name"] as String?,
      price_per_seat: map["price_per_seat"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "display_name": display_name,
      "price_per_seat": price_per_seat,
    };
  }

  factory AddOnModel.fromEntity(AddOnEntity entity) {
    return AddOnModel(
      id: entity.id,
      name: entity.name,
      display_name: entity.display_name,
      price_per_seat: entity.price_per_seat,
    );
  }

  @override
  AddOnModel copyWith({
    String? id,
    String? name,
    String? display_name,
    String? price_per_seat,
  }) {
    return AddOnModel(
      id: id ?? this.id,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      price_per_seat: price_per_seat ?? this.price_per_seat,
    );
  }

  AddOnEntity toEntity() => AddOnEntity(
        id: id,
        name: name,
        display_name: display_name,
        price_per_seat: price_per_seat,
      );
}
