import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/integrations/domain/entities/oauth_app_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/integrations/domain/repositories/oauth_repository.dart';

// Events
abstract class OAuthAppsEvent extends Equatable {
  const OAuthAppsEvent();
  @override
  List<Object?> get props => [];
}

class LoadOAuthAppsEvent extends OAuthAppsEvent {}

class RegisterOAuthAppEvent extends OAuthAppsEvent {
  final String name;
  final String description;
  final String homepage;
  final List<String> callbackUrls;
  final bool isTrusted;
  const RegisterOAuthAppEvent({
    required this.name,
    this.description = '',
    this.homepage = '',
    this.callbackUrls = const [],
    this.isTrusted = false,
  });
  @override
  List<Object?> get props => [
    name,
    description,
    homepage,
    callbackUrls,
    isTrusted,
  ];
}

class UpdateOAuthAppEvent extends OAuthAppsEvent {
  final String appId;
  final String name;
  final String description;
  final String homepage;
  final List<String> callbackUrls;
  final bool isTrusted;
  const UpdateOAuthAppEvent({
    required this.appId,
    required this.name,
    this.description = '',
    this.homepage = '',
    this.callbackUrls = const [],
    this.isTrusted = false,
  });
  @override
  List<Object?> get props => [
    appId,
    name,
    description,
    homepage,
    callbackUrls,
    isTrusted,
  ];
}

class DeleteOAuthAppEvent extends OAuthAppsEvent {
  final String appId;
  const DeleteOAuthAppEvent(this.appId);
  @override
  List<Object?> get props => [appId];
}

class RegenerateOAuthAppSecretEvent extends OAuthAppsEvent {
  final String appId;
  const RegenerateOAuthAppSecretEvent(this.appId);
  @override
  List<Object?> get props => [appId];
}

// States
abstract class OAuthAppsState extends Equatable {
  const OAuthAppsState();
  @override
  List<Object?> get props => [];
}

class OAuthAppsInitialState extends OAuthAppsState {}

class OAuthAppsLoadingState extends OAuthAppsState {}

class OAuthAppsLoadedState extends OAuthAppsState {
  final List<OAuthAppEntity> apps;
  const OAuthAppsLoadedState(this.apps);
  @override
  List<Object?> get props => [apps];
}

class OAuthAppSecretState extends OAuthAppsState {
  final String appId;
  final String clientSecret;
  const OAuthAppSecretState({required this.appId, required this.clientSecret});
  @override
  List<Object?> get props => [appId, clientSecret];
}

class OAuthAppsErrorState extends OAuthAppsState {
  final String message;
  const OAuthAppsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class OAuthAppsBloc extends Bloc<OAuthAppsEvent, OAuthAppsState> {
  final OAuthRepository _oauthRepository;

  OAuthAppsBloc(this._oauthRepository) : super(OAuthAppsInitialState()) {
    on<LoadOAuthAppsEvent>(_onLoad);
    on<RegisterOAuthAppEvent>(_onRegister);
    on<UpdateOAuthAppEvent>(_onUpdate);
    on<DeleteOAuthAppEvent>(_onDelete);
    on<RegenerateOAuthAppSecretEvent>(_onRegenerateSecret);
  }

  Future<void> _onLoad(
    LoadOAuthAppsEvent event,
    Emitter<OAuthAppsState> emit,
  ) async {
    emit(OAuthAppsLoadingState());
    try {
      final apps = await _oauthRepository.getOAuthApps();
      emit(OAuthAppsLoadedState(apps));
    } catch (e) {
      emit(OAuthAppsErrorState(e.toString()));
    }
  }

  Future<void> _onRegister(
    RegisterOAuthAppEvent event,
    Emitter<OAuthAppsState> emit,
  ) async {
    emit(OAuthAppsLoadingState());
    try {
      await _oauthRepository.registerOAuthApp(
        name: event.name,
        description: event.description,
        homepage: event.homepage,
        callbackUrls: event.callbackUrls,
        isTrusted: event.isTrusted,
      );
      final apps = await _oauthRepository.getOAuthApps();
      emit(OAuthAppsLoadedState(apps));
    } catch (e) {
      emit(OAuthAppsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateOAuthAppEvent event,
    Emitter<OAuthAppsState> emit,
  ) async {
    emit(OAuthAppsLoadingState());
    try {
      await _oauthRepository.updateOAuthApp(
        event.appId,
        name: event.name,
        description: event.description,
        homepage: event.homepage,
        callbackUrls: event.callbackUrls,
        isTrusted: event.isTrusted,
      );
      final apps = await _oauthRepository.getOAuthApps();
      emit(OAuthAppsLoadedState(apps));
    } catch (e) {
      emit(OAuthAppsErrorState(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteOAuthAppEvent event,
    Emitter<OAuthAppsState> emit,
  ) async {
    try {
      await _oauthRepository.deleteOAuthApp(event.appId);
      if (state is OAuthAppsLoadedState) {
        final current = (state as OAuthAppsLoadedState).apps;
        emit(
          OAuthAppsLoadedState(
            current.where((a) => a.id != event.appId).toList(),
          ),
        );
      }
    } catch (e) {
      emit(OAuthAppsErrorState(e.toString()));
    }
  }

  Future<void> _onRegenerateSecret(
    RegenerateOAuthAppSecretEvent event,
    Emitter<OAuthAppsState> emit,
  ) async {
    try {
      final secret = await _oauthRepository.regenerateOAuthAppSecret(
        event.appId,
      );
      emit(OAuthAppSecretState(appId: event.appId, clientSecret: secret));
    } catch (e) {
      emit(OAuthAppsErrorState(e.toString()));
    }
  }
}
