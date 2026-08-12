import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

// Events
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyProfileEvent extends UserProfileEvent {}

class SearchUsersEvent extends UserProfileEvent {
  final String term;
  const SearchUsersEvent(this.term);
  @override
  List<Object?> get props => [term];
}

class LoadProfilesByIdsEvent extends UserProfileEvent {
  final List<String> userIds;
  const LoadProfilesByIdsEvent(this.userIds);
  @override
  List<Object?> get props => [userIds];
}

// States
abstract class UserProfileState extends Equatable {
  const UserProfileState();
  @override
  List<Object?> get props => [];
}

class UserProfileInitialState extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileLoadedState extends UserProfileState {
  final UserEntity? myProfile;
  final List<UserEntity> profiles;

  const UserProfileLoadedState({this.myProfile, this.profiles = const []});
  @override
  List<Object?> get props => [myProfile, profiles];
}

class UserProfileErrorState extends UserProfileState {
  final String message;
  const UserProfileErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository _userRepository;

  UserProfileBloc(this._userRepository) : super(UserProfileInitialState()) {
    on<LoadMyProfileEvent>(_onLoadMyProfile);
    on<LoadProfilesByIdsEvent>(_onLoadProfilesByIds);
    on<SearchUsersEvent>(_onSearchUsers);
  }

  Future<void> _onLoadMyProfile(
    LoadMyProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoadingState());
    try {
      final me = await _userRepository.getMyProfile();
      emit(UserProfileLoadedState(myProfile: me));
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onLoadProfilesByIds(
    LoadProfilesByIdsEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final profiles = await _userRepository.getProfilesByIds(event.userIds);
      var existing = const <UserEntity>[];
      if (state is UserProfileLoadedState) {
        existing = (state as UserProfileLoadedState).profiles;
      }
      final byId = <String, UserEntity>{
        for (final p in existing) p.id: p,
        for (final p in profiles) p.id: p,
      };
      emit(
        UserProfileLoadedState(
          myProfile: state is UserProfileLoadedState
              ? (state as UserProfileLoadedState).myProfile
              : null,
          profiles: byId.values.toList(),
        ),
      );
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final results = await _userRepository.searchUsers(event.term);
      emit(
        UserProfileLoadedState(
          myProfile: state is UserProfileLoadedState
              ? (state as UserProfileLoadedState).myProfile
              : null,
          profiles: results,
        ),
      );
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }
}
