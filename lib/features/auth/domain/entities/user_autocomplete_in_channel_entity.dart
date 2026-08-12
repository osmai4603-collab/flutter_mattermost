import 'package:equatable/equatable.dart';

class UserAutocompleteInChannelEntity extends Equatable {
  final List<Map<String, dynamic>>? in_channel;
  final List<Map<String, dynamic>>? out_of_channel;

  const UserAutocompleteInChannelEntity({
    this.in_channel,
    this.out_of_channel,
  });

  @override
  List<Object?> get props => [
        in_channel,
        out_of_channel,
      ];

  UserAutocompleteInChannelEntity copyWith({
    List<Map<String, dynamic>>? in_channel,
    List<Map<String, dynamic>>? out_of_channel,
  }) {
    return UserAutocompleteInChannelEntity(
      in_channel: in_channel ?? this.in_channel,
      out_of_channel: out_of_channel ?? this.out_of_channel,
    );
  }
}
