import 'package:flutter_mattermost/features/admin/domain/entities/allowed_ip_range_entity.dart';

final class AllowedIPRangeModel extends AllowedIPRangeEntity {
  const AllowedIPRangeModel({
    required super.CIDRBlock,
    required super.Description,
  });

  factory AllowedIPRangeModel.fromMap(Map<String, dynamic> map) {
    return AllowedIPRangeModel(
      CIDRBlock: map["CIDRBlock"] as String?,
      Description: map["Description"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "CIDRBlock": CIDRBlock,
      "Description": Description,
    };
  }

  factory AllowedIPRangeModel.fromEntity(AllowedIPRangeEntity entity) {
    return AllowedIPRangeModel(
      CIDRBlock: entity.CIDRBlock,
      Description: entity.Description,
    );
  }

  AllowedIPRangeModel copyWith({
    String? CIDRBlock,
    String? Description,
  }) {
    return AllowedIPRangeModel(
      CIDRBlock: CIDRBlock ?? this.CIDRBlock,
      Description: Description ?? this.Description,
    );
  }

  AllowedIPRangeEntity toEntity() => AllowedIPRangeEntity(
        CIDRBlock: CIDRBlock,
        Description: Description,
      );
}
