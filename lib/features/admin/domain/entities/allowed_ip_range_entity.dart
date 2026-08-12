import 'package:equatable/equatable.dart';

class AllowedIPRangeEntity extends Equatable {
  final String? CIDRBlock;
  final String? Description;

  const AllowedIPRangeEntity({
    this.CIDRBlock,
    this.Description,
  });

  @override
  List<Object?> get props => [
        CIDRBlock,
        Description,
      ];

  AllowedIPRangeEntity copyWith({
    String? CIDRBlock,
    String? Description,
  }) {
    return AllowedIPRangeEntity(
      CIDRBlock: CIDRBlock ?? this.CIDRBlock,
      Description: Description ?? this.Description,
    );
  }
}
