import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/di/injection.config.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/repositories/threads_repository_impl.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/calls_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/threads_bloc.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true, asExtension: true)
Future<void> configureDependencies() async {
  getIt.init();

  // تسجيلات يدوية إضافية (دون الحاجة لإعادة توليد injection.config).
  getIt.registerLazySingleton<ThreadsRepository>(
    () => ThreadsRepositoryImpl(
      getIt<ThreadsRemoteDataSource>(),
      getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<ThreadsBloc>(
    () => ThreadsBloc(getIt<ThreadsRepository>()),
  );
  getIt.registerLazySingleton<DraftStorageService>(() => DraftStorageService());
}
