import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

// Events
abstract class AdminConfigEvent extends Equatable {
  const AdminConfigEvent();
  @override
  List<Object?> get props => [];
}

/// تحميل إحصاءات السيرفر لصفحة "نظرة عامة".
class LoadAdminOverviewEvent extends AdminConfigEvent {}

/// إعادة تحميل إعدادات السيرفر.
class ReloadAdminConfigEvent extends AdminConfigEvent {}

/// اختبار اتصال البريد الإلكتروني.
class TestAdminEmailEvent extends AdminConfigEvent {}

/// اختبار عنوان الموقع.
class TestAdminSiteUrlEvent extends AdminConfigEvent {}

/// إرسال إشعار تجريبي (Push).
class SendTestNotificationEvent extends AdminConfigEvent {}

/// حفظ إعدادات معدّلة (كاملة وقابلة للتحديث).
class SaveAdminConfigEvent extends AdminConfigEvent {
  final Map<String, dynamic> config;
  const SaveAdminConfigEvent(this.config);

  @override
  List<Object?> get props => [config];
}

// States
abstract class AdminConfigState extends Equatable {
  const AdminConfigState();
  @override
  List<Object?> get props => [];
}

class AdminConfigInitial extends AdminConfigState {}

class AdminConfigLoading extends AdminConfigState {}

class AdminConfigLoaded extends AdminConfigState {
  final AnalyticsEntity analytics;
  const AdminConfigLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class AdminConfigActionSuccess extends AdminConfigState {
  final String message;
  const AdminConfigActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminConfigError extends AdminConfigState {
  final String message;
  const AdminConfigError(this.message);

  @override
  List<Object?> get props => [message];
}

@injectable
class AdminConfigBloc extends Bloc<AdminConfigEvent, AdminConfigState> {
  final AdminConfigRepository _repository;

  AdminConfigBloc(this._repository) : super(AdminConfigInitial()) {
    on<LoadAdminOverviewEvent>(_onLoadOverview);
    on<ReloadAdminConfigEvent>(_onReloadConfig);
    on<TestAdminEmailEvent>(
      (event, emit) => _runAction(
        emit,
        () => _repository.testEmail(),
        'Email test successful',
      ),
    );
    on<TestAdminSiteUrlEvent>(
      (event, emit) =>
          _runAction(emit, _repository.testSiteURL, 'Site URL test successful'),
    );
    on<SendTestNotificationEvent>(
      (event, emit) => _runAction(
        emit,
        _repository.sendTestNotification,
        'Test notification sent',
      ),
    );
    on<SaveAdminConfigEvent>(_onSaveConfig);
  }

  Future<void> _onLoadOverview(
    LoadAdminOverviewEvent event,
    Emitter<AdminConfigState> emit,
  ) async {
    emit(AdminConfigLoading());
    try {
      final analytics = await _repository.getAnalytics();
      emit(AdminConfigLoaded(analytics));
    } catch (e) {
      emit(AdminConfigError(e.toString()));
    }
  }

  Future<void> _onReloadConfig(
    ReloadAdminConfigEvent event,
    Emitter<AdminConfigState> emit,
  ) async {
    try {
      await _repository.reloadConfig();
      emit(const AdminConfigActionSuccess('Configuration reloaded'));
    } catch (e) {
      emit(AdminConfigError(e.toString()));
    }
  }

  Future<void> _onSaveConfig(
    SaveAdminConfigEvent event,
    Emitter<AdminConfigState> emit,
  ) async {
    try {
      await _repository.updateConfig(event.config);
      emit(const AdminConfigActionSuccess('Configuration saved'));
    } catch (e) {
      emit(AdminConfigError(e.toString()));
    }
  }

  Future<void> _runAction(
    Emitter<AdminConfigState> emit,
    Future<void> Function() action,
    String successMessage,
  ) async {
    emit(AdminConfigLoading());
    try {
      await action();
      emit(AdminConfigActionSuccess(successMessage));
    } catch (e) {
      emit(AdminConfigError(e.toString()));
    }
  }
}
