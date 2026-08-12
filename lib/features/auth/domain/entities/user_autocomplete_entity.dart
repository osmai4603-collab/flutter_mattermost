import 'package:equatable/equatable.dart';

class UserAutocompleteEntity extends Equatable {
  final List<Map<String, dynamic>>? users;
  final List<Map<String, dynamic>>? out_of_channel;

  const UserAutocompleteEntity({
    this.users,
    this.out_of_channel,
  });

  @override
  List<Object?> get props => [
        users,
        out_of_channel,
      ];

  UserAutocompleteEntity copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? out_of_channel,
  }) {
    return UserAutocompleteEntity(
      users: users ?? this.users,
      out_of_channel: out_of_channel ?? this.out_of_channel,
    );
  }
}
