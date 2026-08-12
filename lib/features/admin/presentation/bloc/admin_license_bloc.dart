import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/license_info_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_license_repository.dart';

// Events
abstract class AdminLicenseEvent extends Equatable {
  const AdminLicenseEvent();
  @override
  List<Object?> get props => [];
}

class LoadLicenseEvent extends AdminLicenseEvent {}

class UploadLicenseEvent extends AdminLicenseEvent {
  final String filePath;
  const UploadLicenseEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class RemoveLicenseEvent extends AdminLicenseEvent {}

class UpgradeToEnterpriseEvent extends AdminLicenseEvent {}

// States
abstract class AdminLicenseState extends Equatable {
  const AdminLicenseState();
  @override
  List<Object?> get props => [];
}

class AdminLicenseInitial extends AdminLicenseState {}

class AdminLicenseLoading extends AdminLicenseState {}

class AdminLicenseLoaded extends AdminLicenseState {
  final LicenseInfoEntity license;
  const AdminLicenseLoaded(this.license);

  @override
  List<Object?> get props => [license];
}

class AdminLicenseActionSuccess extends AdminLicenseState {
  final String message;
  const AdminLicenseActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminLicenseError extends AdminLicenseState {
  final String message;
  const AdminLicenseError(this.message);

  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class AdminLicenseBloc extends Bloc<AdminLicenseEvent, AdminLicenseState> {
  final AdminLicenseRepository _repository;

  AdminLicenseBloc(this._repository) : super(AdminLicenseInitial()) {
    on<LoadLicenseEvent>(_onLoad);
    on<UploadLicenseEvent>(_onUpload);
    on<RemoveLicenseEvent>(_onRemove);
    on<UpgradeToEnterpriseEvent>(_onUpgrade);
  }

  Future<void> _onLoad(
    LoadLicenseEvent event,
    Emitter<AdminLicenseState> emit,
  ) async {
    emit(AdminLicenseLoading());
    try {
      final license = await _repository.getClientLicense();
      emit(AdminLicenseLoaded(license));
    } catch (e) {
      emit(AdminLicenseError(e.toString()));
    }
  }

  Future<void> _onUpload(
    UploadLicenseEvent event,
    Emitter<AdminLicenseState> emit,
  ) async {
    emit(AdminLicenseLoading());
    try {
      final license = await _repository.uploadLicense(event.filePath);
      emit(AdminLicenseLoaded(license));
    } catch (e) {
      emit(AdminLicenseError(e.toString()));
    }
  }

  Future<void> _onRemove(
    RemoveLicenseEvent event,
    Emitter<AdminLicenseState> emit,
  ) async {
    emit(AdminLicenseLoading());
    try {
      await _repository.removeLicense();
      emit(const AdminLicenseActionSuccess('License removed'));
    } catch (e) {
      emit(AdminLicenseError(e.toString()));
    }
  }

  Future<void> _onUpgrade(
    UpgradeToEnterpriseEvent event,
    Emitter<AdminLicenseState> emit,
  ) async {
    emit(AdminLicenseLoading());
    try {
      await _repository.upgradeToEnterprise();
      emit(const AdminLicenseActionSuccess('Upgrade requested'));
    } catch (e) {
      emit(AdminLicenseError(e.toString()));
    }
  }
}
