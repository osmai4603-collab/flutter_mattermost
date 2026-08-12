import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_with_team_data_entity.dart';

/// قائمة بالقنوات مع بيانات فريقها (ChannelListWithTeamData):
/// مصفوفة من ChannelWithTeamData.
class ChannelListWithTeamDataEntity extends Equatable {
  final List<ChannelWithTeamDataEntity> items;

  const ChannelListWithTeamDataEntity({
    this.items = const [],
  });

  @override
  List<Object?> get props => [items];

  ChannelListWithTeamDataEntity copyWith({
    List<ChannelWithTeamDataEntity>? items,
  }) {
    return ChannelListWithTeamDataEntity(
      items: items ?? this.items,
    );
  }
}
