import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/marketplace_plugin_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/plugin_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_plugins_repository.dart';

// Events
abstract class AdminPluginsEvent extends Equatable {
  const AdminPluginsEvent();
  @override
  List<Object?> get props => [];
}

class LoadPluginsEvent extends AdminPluginsEvent {}

class TogglePluginEvent extends AdminPluginsEvent {
  final PluginEntity plugin;
  const TogglePluginEvent(this.plugin);

  @override
  List<Object?> get props => [plugin];
}

class RemovePluginEvent extends AdminPluginsEvent {
  final String pluginId;
  const RemovePluginEvent(this.pluginId);

  @override
  List<Object?> get props => [pluginId];
}

class InstallPluginEvent extends AdminPluginsEvent {
  final String pluginId;
  const InstallPluginEvent(this.pluginId);

  @override
  List<Object?> get props => [pluginId];
}

// States
abstract class AdminPluginsState extends Equatable {
  const AdminPluginsState();
  @override
  List<Object?> get props => [];
}

class PluginsInitial extends AdminPluginsState {}

class PluginsLoading extends AdminPluginsState {}

class PluginsLoaded extends AdminPluginsState {
  final List<PluginEntity> installed;
  final List<MarketplacePluginEntity> marketplace;
  const PluginsLoaded({required this.installed, required this.marketplace});

  @override
  List<Object?> get props => [installed, marketplace];
}

class PluginsActionSuccess extends AdminPluginsState {
  final String message;
  const PluginsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PluginsError extends AdminPluginsState {
  final String message;
  const PluginsError(this.message);

  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class AdminPluginsBloc extends Bloc<AdminPluginsEvent, AdminPluginsState> {
  final AdminPluginsRepository _repository;

  AdminPluginsBloc(this._repository) : super(PluginsInitial()) {
    on<LoadPluginsEvent>(_onLoad);
    on<TogglePluginEvent>(_onToggle);
    on<RemovePluginEvent>(_onRemove);
    on<InstallPluginEvent>(_onInstall);
  }

  Future<void> _onLoad(
    LoadPluginsEvent event,
    Emitter<AdminPluginsState> emit,
  ) async {
    emit(PluginsLoading());
    try {
      final results = await Future.wait([
        _repository.getInstalledPlugins(),
        _repository.getMarketplacePlugins(),
      ]);
      emit(
        PluginsLoaded(
          installed: results[0] as List<PluginEntity>,
          marketplace: results[1] as List<MarketplacePluginEntity>,
        ),
      );
    } catch (e) {
      emit(PluginsError(e.toString()));
    }
  }

  Future<void> _onToggle(
    TogglePluginEvent event,
    Emitter<AdminPluginsState> emit,
  ) async {
    try {
      if (event.plugin.active) {
        await _repository.disablePlugin(event.plugin.id);
      } else {
        await _repository.enablePlugin(event.plugin.id);
      }
      add(LoadPluginsEvent());
    } catch (e) {
      emit(PluginsError(e.toString()));
    }
  }

  Future<void> _onRemove(
    RemovePluginEvent event,
    Emitter<AdminPluginsState> emit,
  ) async {
    try {
      await _repository.removePlugin(event.pluginId);
      emit(PluginsActionSuccess('Plugin removed'));
      add(LoadPluginsEvent());
    } catch (e) {
      emit(PluginsError(e.toString()));
    }
  }

  Future<void> _onInstall(
    InstallPluginEvent event,
    Emitter<AdminPluginsState> emit,
  ) async {
    try {
      await _repository.installPlugin(event.pluginId);
      emit(PluginsActionSuccess('Plugin installed'));
      add(LoadPluginsEvent());
    } catch (e) {
      emit(PluginsError(e.toString()));
    }
  }
}
