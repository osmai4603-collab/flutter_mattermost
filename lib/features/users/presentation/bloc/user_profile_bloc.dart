import 'package:flutter/foundation.dart';
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

/// حفظ تعديلات الملف الشخصي (الاسم الأول/الأخير/اللقب/المنصب/اللغة).
class UpdateMyProfileEvent extends UserProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? nickname;
  final String? position;
  final String? locale;

  const UpdateMyProfileEvent({
    this.firstName,
    this.lastName,
    this.nickname,
    this.position,
    this.locale,
  });
  @override
  List<Object?> get props => [firstName, lastName, nickname, position, locale];
}

/// حفظ خصائص الإشعارات notify_props (desktop/push/email/...).
class UpdateNotifyPropsEvent extends UserProfileEvent {
  final UserNotifyPropsEntity notifyProps;
  const UpdateNotifyPropsEvent(this.notifyProps);
  @override
  List<Object?> get props => [notifyProps];
}

/// رفع صورة شخصية جديدة.
class UploadProfileImageEvent extends UserProfileEvent {
  final String filePath;
  const UploadProfileImageEvent(this.filePath);
  @override
  List<Object?> get props => [filePath];
}

/// تغيير كلمة المرور.
class ChangePasswordEvent extends UserProfileEvent {
  final String currentPassword;
  final String newPassword;
  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// تفعيل/تعطيل المصادقة الثنائية MFA.
class UpdateMfaEvent extends UserProfileEvent {
  final bool activate;
  final String? code;
  const UpdateMfaEvent({required this.activate, this.code});
  @override
  List<Object?> get props => [activate, code];
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

/// عملية حفظ قيد التنفيذ — يبقى `is UserProfileLoadedState` صحيحاً
/// حتى لا تختفي بيانات المستخدم أثناء الحفظ.
class UserProfileSavingState extends UserProfileLoadedState {
  const UserProfileSavingState({super.myProfile, super.profiles});
}

/// نجحت عملية الحفظ — يحمل المستخدم المحدّث ورسالة نجاح للواجهة.
class UserProfileSaveSuccessState extends UserProfileLoadedState {
  final String message;
  const UserProfileSaveSuccessState({
    super.myProfile,
    super.profiles,
    required this.message,
  });
  @override
  List<Object?> get props => [myProfile, profiles, message];
}

/// فشلت عملية الحفظ — يحمل المستخدم السابق ورسالة خطأ للواجهة.
class UserProfileSaveErrorState extends UserProfileLoadedState {
  final String message;
  const UserProfileSaveErrorState({
    super.myProfile,
    super.profiles,
    required this.message,
  });
  @override
  List<Object?> get props => [myProfile, profiles, message];
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
    on<UpdateMyProfileEvent>(_onUpdateMyProfile);
    on<UpdateNotifyPropsEvent>(_onUpdateNotifyProps);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
    on<ChangePasswordEvent>(_onChangePassword);
    on<UpdateMfaEvent>(_onUpdateMfa);
  }

  UserEntity? get _currentUser => state is UserProfileLoadedState
      ? (state as UserProfileLoadedState).myProfile
      : null;

  Future<void> _onLoadMyProfile(
    LoadMyProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final currentProfiles = _currentProfiles;
    if (state is! UserProfileLoadedState) {
      emit(UserProfileLoadingState());
    }
    try {
      final me = await _userRepository.getMyProfile();
      emit(UserProfileLoadedState(myProfile: me, profiles: currentProfiles));
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onLoadProfilesByIds(
    LoadProfilesByIdsEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    if (event.userIds.isEmpty) return;
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
      debugPrint('[UserProfileBloc] _onLoadProfilesByIds error: $e');
      // Keep current profiles on failure
    }
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final currentMe = _currentUser;
    final currentProfiles = _currentProfiles;
    try {
      final results = await _userRepository.searchUsers(event.term);
      // دمج نتائج البحث مع الملفات الشخصية الموجودة لضمان عدم فقدان بيانات المستخدمين
      // الذين تظهر رسائلهم في الدردشة الحالية.
      final byId = <String, UserEntity>{
        for (final p in currentProfiles) p.id: p,
        for (final p in results) p.id: p,
      };
      emit(
        UserProfileLoadedState(
          myProfile: currentMe,
          profiles: byId.values.toList(),
        ),
      );
    } catch (e) {
      emit(UserProfileErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateMyProfile(
    UpdateMyProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(_saving());
    try {
      final updated = await _userRepository.updateMyProfile(
        firstName: event.firstName,
        lastName: event.lastName,
        nickname: event.nickname,
        position: event.position,
        locale: event.locale,
      );
      emit(
        UserProfileSaveSuccessState(
          myProfile: updated,
          profiles: _currentProfiles,
          message: 'Profile updated successfully',
        ),
      );
    } catch (e) {
      emit(_saveError(e));
    }
  }

  Future<void> _onUpdateNotifyProps(
    UpdateNotifyPropsEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(_saving());
    try {
      final updated = await _userRepository.updateMyNotifyProps(
        event.notifyProps,
      );
      emit(
        UserProfileSaveSuccessState(
          myProfile: updated,
          profiles: _currentProfiles,
          message: 'Notification settings updated successfully',
        ),
      );
    } catch (e) {
      emit(_saveError(e));
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = _currentUser;
    if (user == null) {
      emit(
        UserProfileSaveErrorState(
          message: 'No current user to update the profile image',
        ),
      );
      return;
    }
    emit(_saving());
    try {
      await _userRepository.uploadProfileImage(user.id, event.filePath);
      final refreshed = await _userRepository.getMyProfile();
      emit(
        UserProfileSaveSuccessState(
          myProfile: refreshed,
          profiles: _currentProfiles,
          message: 'Profile picture uploaded successfully',
        ),
      );
    } catch (e) {
      emit(_saveError(e));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    final user = _currentUser;
    if (user == null) {
      emit(
        UserProfileSaveErrorState(
          message: 'No current user to change password',
        ),
      );
      return;
    }
    emit(_saving());
    try {
      await _userRepository.updatePassword(
        user.id,
        event.currentPassword,
        event.newPassword,
      );
      emit(
        UserProfileSaveSuccessState(
          myProfile: user,
          profiles: _currentProfiles,
          message: 'Password updated successfully',
        ),
      );
    } catch (e) {
      emit(_saveError(e));
    }
  }

  Future<void> _onUpdateMfa(
    UpdateMfaEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(_saving());
    try {
      await _userRepository.updateMyMfa(
        activate: event.activate,
        code: event.code,
      );
      final refreshed = await _userRepository.getMyProfile();
      emit(
        UserProfileSaveSuccessState(
          myProfile: refreshed,
          profiles: _currentProfiles,
          message: event.activate ? 'MFA enabled' : 'MFA disabled',
        ),
      );
    } catch (e) {
      emit(_saveError(e));
    }
  }

  List<UserEntity> get _currentProfiles => state is UserProfileLoadedState
      ? (state as UserProfileLoadedState).profiles
      : const [];

  UserProfileSavingState _saving() => UserProfileSavingState(
    myProfile: _currentUser,
    profiles: _currentProfiles,
  );

  UserProfileSaveErrorState _saveError(Object e) => UserProfileSaveErrorState(
    myProfile: _currentUser,
    profiles: _currentProfiles,
    message: e.toString(),
  );
}
