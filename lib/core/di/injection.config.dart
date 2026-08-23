// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:drift/drift.dart' as _i500;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:osm_network/osm_network.dart' as _i960;

import '../../features/admin/data/datasources/admin_access_control_data_source.dart'
    as _i117;
import '../../features/admin/data/datasources/admin_agents_data_source.dart'
    as _i548;
import '../../features/admin/data/datasources/admin_cloud_data_source.dart'
    as _i431;
import '../../features/admin/data/datasources/admin_compliance_data_source.dart'
    as _i995;
import '../../features/admin/data/datasources/admin_config_data_source.dart'
    as _i261;
import '../../features/admin/data/datasources/admin_content_flagging_data_source.dart'
    as _i1051;
import '../../features/admin/data/datasources/admin_custom_properties_data_source.dart'
    as _i274;
import '../../features/admin/data/datasources/admin_data_retention_data_source.dart'
    as _i197;
import '../../features/admin/data/datasources/admin_imports_exports_data_source.dart'
    as _i648;
import '../../features/admin/data/datasources/admin_jobs_data_source.dart'
    as _i949;
import '../../features/admin/data/datasources/admin_license_data_source.dart'
    as _i963;
import '../../features/admin/data/datasources/admin_plugins_data_source.dart'
    as _i434;
import '../../features/admin/data/datasources/admin_remotecluster_data_source.dart'
    as _i187;
import '../../features/admin/data/datasources/admin_reports_data_source.dart'
    as _i722;
import '../../features/admin/data/datasources/admin_security_data_source.dart'
    as _i844;
import '../../features/admin/data/datasources/admin_shared_channels_data_source.dart'
    as _i851;
import '../../features/admin/data/datasources/permissions_remote_data_source.dart'
    as _i377;
import '../../features/admin/data/datasources/roles_remote_data_source.dart'
    as _i147;
import '../../features/admin/data/datasources/schemes_remote_data_source.dart'
    as _i1009;
import '../../features/admin/data/repositories/admin_access_control_repository_impl.dart'
    as _i925;
import '../../features/admin/data/repositories/admin_compliance_repository_impl.dart'
    as _i759;
import '../../features/admin/data/repositories/admin_config_repository_impl.dart'
    as _i556;
import '../../features/admin/data/repositories/admin_content_flagging_repository_impl.dart'
    as _i996;
import '../../features/admin/data/repositories/admin_data_retention_repository_impl.dart'
    as _i556;
import '../../features/admin/data/repositories/admin_jobs_repository_impl.dart'
    as _i469;
import '../../features/admin/data/repositories/admin_license_repository_impl.dart'
    as _i463;
import '../../features/admin/data/repositories/admin_plugins_repository_impl.dart'
    as _i495;
import '../../features/admin/data/repositories/admin_roles_schemes_repository_impl.dart'
    as _i29;
import '../../features/admin/data/repositories/admin_security_repository_impl.dart'
    as _i360;
import '../../features/admin/data/repositories/admin_shared_channels_repository_impl.dart'
    as _i458;
import '../../features/admin/domain/repositories/admin_access_control_repository.dart'
    as _i252;
import '../../features/admin/domain/repositories/admin_compliance_repository.dart'
    as _i894;
import '../../features/admin/domain/repositories/admin_config_repository.dart'
    as _i260;
import '../../features/admin/domain/repositories/admin_content_flagging_repository.dart'
    as _i779;
import '../../features/admin/domain/repositories/admin_data_retention_repository.dart'
    as _i929;
import '../../features/admin/domain/repositories/admin_jobs_repository.dart'
    as _i958;
import '../../features/admin/domain/repositories/admin_license_repository.dart'
    as _i1016;
import '../../features/admin/domain/repositories/admin_plugins_repository.dart'
    as _i386;
import '../../features/admin/domain/repositories/admin_roles_schemes_repository.dart'
    as _i57;
import '../../features/admin/domain/repositories/admin_security_repository.dart'
    as _i942;
import '../../features/admin/domain/repositories/admin_shared_channels_repository.dart'
    as _i915;
import '../../features/admin/presentation/bloc/admin_config_bloc.dart' as _i859;
import '../../features/admin/presentation/bloc/admin_license_bloc.dart'
    as _i233;
import '../../features/admin/presentation/bloc/admin_plugins_bloc.dart'
    as _i174;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/channels/data/datasources/channel_bookmarks_remote_data_source.dart'
    as _i580;
import '../../features/channels/data/datasources/channel_categories_remote_data_source.dart'
    as _i804;
import '../../features/channels/data/datasources/channel_join_requests_remote_data_source.dart'
    as _i410;
import '../../features/channels/data/datasources/channel_members_remote_data_source.dart'
    as _i1058;
import '../../features/channels/data/datasources/channels_remote_data_source.dart'
    as _i571;
import '../../features/channels/data/repositories/channel_repository_impl.dart'
    as _i585;
import '../../features/channels/domain/repositories/channel_repository.dart'
    as _i236;
import '../../features/channels/presentation/bloc/channel_bloc.dart' as _i515;
import '../../features/chat/data/datasources/chat_local_data_source.dart'
    as _i94;
import '../../features/chat/data/datasources/chat_remote_data_sources.dart'
    as _i20;
import '../../features/chat/data/datasources/drafts_remote_data_source.dart'
    as _i995;
import '../../features/chat/data/datasources/emoji_remote_data_source.dart'
    as _i715;
import '../../features/chat/data/datasources/files_remote_data_source.dart'
    as _i937;
import '../../features/chat/data/datasources/reactions_remote_data_source.dart'
    as _i1010;
import '../../features/chat/data/datasources/recaps_remote_data_source.dart'
    as _i644;
import '../../features/chat/data/datasources/scheduled_posts_remote_data_source.dart'
    as _i582;
import '../../features/chat/data/datasources/scheduled_recaps_remote_data_source.dart'
    as _i776;
import '../../features/chat/data/datasources/threads_remote_data_source.dart'
    as _i931;
import '../../features/chat/data/datasources/typing_remote_data_source.dart'
    as _i428;
import '../../features/chat/data/realtime/realtime_sync_service.dart' as _i468;
import '../../features/chat/data/repositories/drafts_repository_impl.dart'
    as _i152;
import '../../features/chat/data/repositories/post_repository_impl.dart'
    as _i985;
import '../../features/chat/data/repositories/scheduled_posts_repository_impl.dart'
    as _i221;
import '../../features/chat/data/sync/offline_sync_service.dart' as _i223;
import '../../features/chat/domain/repositories/calls_rest_repository.dart'
    as _i217;
import '../../features/chat/domain/repositories/drafts_repository.dart'
    as _i366;
import '../../features/chat/domain/repositories/post_repository.dart' as _i686;
import '../../features/chat/domain/repositories/scheduled_posts_repository.dart'
    as _i300;
import '../../features/chat/presentation/bloc/calls_bloc.dart' as _i396;
import '../../features/chat/presentation/bloc/captions_bloc.dart' as _i774;
import '../../features/chat/presentation/bloc/lhs_bloc.dart' as _i894;
import '../../features/chat/presentation/bloc/post_bloc.dart' as _i486;
import '../../features/chat/presentation/bloc/rhs_bloc.dart' as _i478;
import '../../features/chat/presentation/bloc/search_bloc.dart' as _i860;
import '../../features/chat/presentation/cubit/drafts_cubit.dart' as _i986;
import '../../features/chat/presentation/cubit/threads_summary_cubit.dart'
    as _i1072;
import '../../features/common/data/datasources/playbooks_remote_data_source.dart'
    as _i960;
import '../../features/groups/data/datasources/groups_remote_data_source.dart'
    as _i236;
import '../../features/groups/data/repositories/groups_repository_impl.dart'
    as _i485;
import '../../features/groups/domain/repositories/groups_repository.dart'
    as _i137;
import '../../features/groups/presentation/cubit/team_groups_cubit.dart'
    as _i1045;
import '../../features/integrations/data/datasources/agents_remote_data_source.dart'
    as _i953;
import '../../features/integrations/data/datasources/bots_remote_data_source.dart'
    as _i59;
import '../../features/integrations/data/datasources/commands_remote_data_source.dart'
    as _i192;
import '../../features/integrations/data/datasources/hooks_remote_data_source.dart'
    as _i343;
import '../../features/integrations/data/datasources/interactive_dialogs_remote_data_source.dart'
    as _i34;
import '../../features/integrations/data/datasources/oauth_remote_data_source.dart'
    as _i923;
import '../../features/integrations/data/repositories/bots_repository_impl.dart'
    as _i219;
import '../../features/integrations/data/repositories/commands_repository_impl.dart'
    as _i576;
import '../../features/integrations/data/repositories/oauth_repository_impl.dart'
    as _i39;
import '../../features/integrations/data/repositories/webhooks_repository_impl.dart'
    as _i923;
import '../../features/integrations/domain/repositories/bots_repository.dart'
    as _i564;
import '../../features/integrations/domain/repositories/commands_repository.dart'
    as _i109;
import '../../features/integrations/domain/repositories/oauth_repository.dart'
    as _i240;
import '../../features/integrations/domain/repositories/webhooks_repository.dart'
    as _i822;
import '../../features/integrations/presentation/blocs/bots_bloc.dart' as _i259;
import '../../features/integrations/presentation/blocs/commands_bloc.dart'
    as _i666;
import '../../features/integrations/presentation/blocs/oauth_apps_bloc.dart'
    as _i343;
import '../../features/integrations/presentation/blocs/webhooks_bloc.dart'
    as _i940;
import '../../features/system/data/datasources/emoji_remote_data_source.dart'
    as _i738;
import '../../features/system/data/datasources/notifications_remote_data_source.dart'
    as _i68;
import '../../features/system/data/datasources/scheduled_posts_remote_data_source.dart'
    as _i606;
import '../../features/system/data/datasources/system_config_remote_data_source.dart'
    as _i977;
import '../../features/system/data/repositories/system_repository_impl.dart'
    as _i855;
import '../../features/system/domain/repositories/system_repository.dart'
    as _i323;
import '../../features/system/presentation/bloc/system_info_bloc.dart' as _i363;
import '../../features/teams/data/datasources/team_local_data_source.dart'
    as _i326;
import '../../features/teams/data/datasources/team_members_remote_data_source.dart'
    as _i865;
import '../../features/teams/data/datasources/teams_remote_data_source.dart'
    as _i222;
import '../../features/teams/data/repositories/team_repository_impl.dart'
    as _i437;
import '../../features/teams/domain/repositories/team_repository.dart'
    as _i1065;
import '../../features/teams/domain/team_dashboard_orchestrator.dart' as _i74;
import '../../features/teams/presentation/bloc/team_bloc.dart' as _i550;
import '../../features/users/data/datasources/user_preferences_remote_data_source.dart'
    as _i488;
import '../../features/users/data/datasources/user_sessions_remote_data_source.dart'
    as _i161;
import '../../features/users/data/datasources/user_status_remote_data_source.dart'
    as _i969;
import '../../features/users/data/datasources/user_tokens_remote_data_source.dart'
    as _i488;
import '../../features/users/data/datasources/users_remote_data_source.dart'
    as _i864;
import '../../features/users/data/repositories/user_repository_impl.dart'
    as _i465;
import '../../features/users/domain/repositories/user_repository.dart' as _i658;
import '../../features/users/presentation/bloc/user_preferences_bloc.dart'
    as _i486;
import '../../features/users/presentation/bloc/user_profile_bloc.dart' as _i433;
import '../../features/users/presentation/bloc/user_status_bloc.dart' as _i516;
import '../calls/audio_session_manager.dart' as _i809;
import '../calls/calls_manager.dart' as _i875;
import '../calls/calls_websocket_client.dart' as _i794;
import '../calls/sfu_stream_manager.dart' as _i460;
import '../network/api_client.dart' as _i557;
import '../network/auth_delegate_impl.dart' as _i769;
import '../network/connectivity_monitor.dart' as _i286;
import '../network/server_manager.dart' as _i909;
import '../network/session_controller.dart' as _i787;
import '../network/websocket_client.dart' as _i777;
import '../notifications/local_notification_service.dart' as _i44;
import '../notifications/notification_payload_handler.dart' as _i1070;
import '../permissions/permissions_provider.dart' as _i1011;
import '../security/e2ee_engine.dart' as _i980;
import '../security/key_exchange_service.dart' as _i297;
import '../storage/app_database.dart' as _i690;
import '../storage/secure_storage_service.dart' as _i666;
import '../sync/delta_sync_service.dart' as _i1041;
import '../sync/event_batch_processor.dart' as _i140;
import '../sync/outbox_retry_service.dart' as _i411;
import '../sync/websocket_db_sync_service.dart' as _i791;
import 'storage_module.dart' as _i371;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    gh.singleton<_i787.SessionController>(() => _i787.SessionController());
    gh.lazySingleton<_i809.AudioSessionManager>(
      () => _i809.AudioSessionManager(),
    );
    gh.lazySingleton<_i460.SFUStreamManager>(() => _i460.SFUStreamManager());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    gh.lazySingleton<_i500.QueryExecutor>(() => storageModule.databaseExecutor);
    gh.lazySingleton<_i286.ConnectivityMonitor>(
      () => _i286.ConnectivityMonitor(),
    );
    gh.lazySingleton<_i1070.NotificationPayloadHandler>(
      () => _i1070.NotificationPayloadHandler(),
    );
    gh.lazySingleton<_i980.E2EEEngine>(() => _i980.E2EEEngine());
    gh.lazySingleton<_i297.KeyExchangeService>(
      () => _i297.KeyExchangeService(),
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(),
    );
    gh.lazySingleton<_i140.EventBatchProcessor>(
      () => _i140.EventBatchProcessor(),
    );
    gh.lazySingleton<_i894.LhsBloc>(() => _i894.LhsBloc());
    gh.lazySingleton<_i769.MattermostAuthDelegate>(
      () => _i769.MattermostAuthDelegate(
        gh<_i666.SecureStorageService>(),
        gh<_i960.SessionController>(),
      ),
    );
    gh.lazySingleton<_i557.ApiClient>(
      () => _i557.ApiClient(
        gh<_i666.SecureStorageService>(),
        gh<_i787.SessionController>(),
      ),
    );
    gh.lazySingleton<_i428.TypingRemoteDataSource>(
      () => _i428.TypingRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i410.ChannelJoinRequestsRemoteDataSource>(
      () =>
          _i410.ChannelJoinRequestsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i187.AdminRemoteClusterDataSource>(
      () => _i187.AdminRemoteClusterDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i995.DraftsRemoteDataSource>(
      () => _i995.DraftsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i931.ThreadsRemoteDataSource>(
      () => _i931.ThreadsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i960.PlaybooksRemoteDataSource>(
      () => _i960.PlaybooksRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i851.AdminSharedChannelsDataSource>(
      () => _i851.AdminSharedChannelsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i864.UsersRemoteDataSource>(
      () => _i864.UsersRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i222.TeamsRemoteDataSource>(
      () => _i222.TeamsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i794.CallsWebSocketClient>(
      () => _i794.CallsWebSocketClient(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i777.WebSocketClientManager>(
      () => _i777.WebSocketClientManager(gh<_i666.SecureStorageService>()),
    );
    gh.lazySingleton<_i580.ChannelBookmarksRemoteDataSource>(
      () => _i580.ChannelBookmarksRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i865.TeamMembersRemoteDataSource>(
      () => _i865.TeamMembersRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
      () => _i107.AuthRemoteDataSourceImpl(
        gh<_i557.ApiClient>(),
        gh<_i666.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i34.InteractiveDialogsRemoteDataSource>(
      () => _i34.InteractiveDialogsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i274.AdminCustomPropertiesDataSource>(
      () => _i274.AdminCustomPropertiesDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i434.AdminPluginsDataSource>(
      () => _i434.AdminPluginsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i738.EmojiRemoteDataSource>(
      () => _i738.EmojiRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i1051.AdminContentFlaggingDataSource>(
      () => _i1051.AdminContentFlaggingDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i986.DraftsCubit>(
      () => _i986.DraftsCubit(gh<_i995.DraftsRemoteDataSource>()),
    );
    gh.lazySingleton<_i963.AdminLicenseDataSource>(
      () => _i963.AdminLicenseDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i161.UserSessionsRemoteDataSource>(
      () => _i161.UserSessionsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i488.UserPreferencesRemoteDataSource>(
      () => _i488.UserPreferencesRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i977.SystemConfigRemoteDataSource>(
      () => _i977.SystemConfigRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i690.AppDatabase>(
      () => _i690.AppDatabase(gh<_i500.QueryExecutor>()),
    );
    gh.lazySingleton<_i923.OAuthRemoteDataSource>(
      () => _i923.OAuthRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i995.AdminComplianceDataSource>(
      () => _i995.AdminComplianceDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i68.NotificationsRemoteDataSource>(
      () => _i68.NotificationsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i192.CommandsRemoteDataSource>(
      () => _i192.CommandsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i644.RecapsRemoteDataSource>(
      () => _i644.RecapsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i779.AdminContentFlaggingRepository>(
      () => _i996.AdminContentFlaggingRepositoryImpl(
        gh<_i1051.AdminContentFlaggingDataSource>(),
      ),
    );
    gh.lazySingleton<_i20.PostRemoteDataSource>(
      () => _i20.PostRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i147.RolesRemoteDataSource>(
      () => _i147.RolesRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i776.ScheduledRecapsRemoteDataSource>(
      () => _i776.ScheduledRecapsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i107.AuthRemoteDataSource>(),
        gh<_i864.UsersRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i236.GroupsRemoteDataSource>(
      () => _i236.GroupsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i343.HooksRemoteDataSource>(
      () => _i343.HooksRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i1045.TeamGroupsCubit>(
      () => _i1045.TeamGroupsCubit(gh<_i236.GroupsRemoteDataSource>()),
    );
    gh.lazySingleton<_i1010.ReactionsRemoteDataSource>(
      () => _i1010.ReactionsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i377.PermissionsRemoteDataSource>(
      () => _i377.PermissionsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i804.ChannelCategoriesRemoteDataSource>(
      () => _i804.ChannelCategoriesRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i261.AdminConfigDataSource>(
      () => _i261.AdminConfigDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i571.ChannelRemoteDataSource>(
      () => _i571.ChannelRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i606.ScheduledPostsRemoteDataSource>(
      () => _i606.ScheduledPostsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i197.AdminDataRetentionDataSource>(
      () => _i197.AdminDataRetentionDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i117.AdminAccessControlDataSource>(
      () => _i117.AdminAccessControlDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i715.EmojiRemoteDataSource>(
      () => _i715.EmojiRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i240.OAuthRepository>(
      () => _i39.OAuthRepositoryImpl(gh<_i923.OAuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i548.AdminAgentsDataSource>(
      () => _i548.AdminAgentsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i488.UserTokensRemoteDataSource>(
      () => _i488.UserTokensRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i59.BotsRemoteDataSource>(
      () => _i59.BotsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i822.WebhooksRepository>(
      () => _i923.WebhooksRepositoryImpl(gh<_i343.HooksRemoteDataSource>()),
    );
    gh.lazySingleton<_i1009.SchemesRemoteDataSource>(
      () => _i1009.SchemesRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i940.WebhooksBloc>(
      () => _i940.WebhooksBloc(gh<_i822.WebhooksRepository>()),
    );
    gh.lazySingleton<_i57.AdminRolesSchemesRepository>(
      () => _i29.AdminRolesSchemesRepositoryImpl(
        gh<_i147.RolesRemoteDataSource>(),
        gh<_i1009.SchemesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i915.AdminSharedChannelsRepository>(
      () => _i458.AdminSharedChannelsRepositoryImpl(
        gh<_i851.AdminSharedChannelsDataSource>(),
      ),
    );
    gh.lazySingleton<_i44.LocalNotificationService>(
      () => _i44.LocalNotificationService(
        gh<_i777.WebSocketClientManager>(),
        gh<_i1070.NotificationPayloadHandler>(),
      ),
    );
    gh.lazySingleton<_i366.DraftsRepository>(
      () => _i152.DraftsRepositoryImpl(gh<_i995.DraftsRemoteDataSource>()),
    );
    gh.lazySingleton<_i252.AdminAccessControlRepository>(
      () => _i925.AdminAccessControlRepositoryImpl(
        gh<_i117.AdminAccessControlDataSource>(),
      ),
    );
    gh.lazySingleton<_i1072.ThreadsSummaryCubit>(
      () => _i1072.ThreadsSummaryCubit(gh<_i931.ThreadsRemoteDataSource>()),
    );
    gh.lazySingleton<_i343.OAuthAppsBloc>(
      () => _i343.OAuthAppsBloc(gh<_i240.OAuthRepository>()),
    );
    gh.lazySingleton<_i1065.TeamRepository>(
      () => _i437.TeamRepositoryImpl(
        gh<_i222.TeamsRemoteDataSource>(),
        gh<_i865.TeamMembersRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i929.AdminDataRetentionRepository>(
      () => _i556.AdminDataRetentionRepositoryImpl(
        gh<_i197.AdminDataRetentionDataSource>(),
      ),
    );
    gh.lazySingleton<_i109.CommandsRepository>(
      () => _i576.CommandsRepositoryImpl(gh<_i192.CommandsRemoteDataSource>()),
    );
    gh.lazySingleton<_i894.AdminComplianceRepository>(
      () => _i759.AdminComplianceRepositoryImpl(
        gh<_i995.AdminComplianceDataSource>(),
      ),
    );
    gh.lazySingleton<_i550.TeamBloc>(
      () => _i550.TeamBloc(gh<_i1065.TeamRepository>()),
    );
    gh.lazySingleton<_i217.CallsRestRepository>(
      () => _i217.CallsRestRepository(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i949.AdminJobsDataSource>(
      () => _i949.AdminJobsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i323.SystemRepository>(
      () => _i855.SystemRepositoryImpl(
        gh<_i977.SystemConfigRemoteDataSource>(),
        gh<_i738.EmojiRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i137.GroupsRepository>(
      () => _i485.GroupsRepositoryImpl(gh<_i236.GroupsRemoteDataSource>()),
    );
    gh.lazySingleton<_i722.AdminReportsDataSource>(
      () => _i722.AdminReportsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.factory<_i386.AdminPluginsRepository>(
      () =>
          _i495.AdminPluginsRepositoryImpl(gh<_i434.AdminPluginsDataSource>()),
    );
    gh.lazySingleton<_i937.FilesRemoteDataSource>(
      () => _i937.FilesRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i431.AdminCloudDataSource>(
      () => _i431.AdminCloudDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i648.AdminImportsExportsDataSource>(
      () => _i648.AdminImportsExportsDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i1058.ChannelMembersRemoteDataSource>(
      () => _i1058.ChannelMembersRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.singleton<_i909.ServerManager>(
      () => _i909.ServerManager(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i953.AgentsRemoteDataSource>(
      () => _i953.AgentsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i582.ScheduledPostsRemoteDataSource>(
      () => _i582.ScheduledPostsRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i844.AdminSecurityDataSource>(
      () => _i844.AdminSecurityDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i969.UserStatusRemoteDataSource>(
      () => _i969.UserStatusRemoteDataSourceImpl(gh<_i557.ApiClient>()),
    );
    gh.lazySingleton<_i958.AdminJobsRepository>(
      () => _i469.AdminJobsRepositoryImpl(gh<_i949.AdminJobsDataSource>()),
    );
    gh.lazySingleton<_i1016.AdminLicenseRepository>(
      () =>
          _i463.AdminLicenseRepositoryImpl(gh<_i963.AdminLicenseDataSource>()),
    );
    gh.lazySingleton<_i300.ScheduledPostsRepository>(
      () => _i221.ScheduledPostsRepositoryImpl(
        gh<_i582.ScheduledPostsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i658.UserRepository>(
      () => _i465.UserRepositoryImpl(
        gh<_i864.UsersRemoteDataSource>(),
        gh<_i969.UserStatusRemoteDataSource>(),
        gh<_i488.UserPreferencesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i363.SystemInfoBloc>(
      () => _i363.SystemInfoBloc(gh<_i323.SystemRepository>()),
    );
    gh.lazySingleton<_i666.CommandsBloc>(
      () => _i666.CommandsBloc(gh<_i109.CommandsRepository>()),
    );
    gh.lazySingleton<_i564.BotsRepository>(
      () => _i219.BotsRepositoryImpl(gh<_i59.BotsRemoteDataSource>()),
    );
    gh.lazySingleton<_i260.AdminConfigRepository>(
      () => _i556.AdminConfigRepositoryImpl(gh<_i261.AdminConfigDataSource>()),
    );
    gh.lazySingleton<_i1041.DeltaSyncService>(
      () => _i1041.DeltaSyncService(
        gh<_i690.AppDatabase>(),
        gh<_i909.ServerManager>(),
        gh<_i777.WebSocketClientManager>(),
      ),
    );
    gh.lazySingleton<_i486.UserPreferencesBloc>(
      () => _i486.UserPreferencesBloc(gh<_i658.UserRepository>()),
    );
    gh.lazySingleton<_i433.UserProfileBloc>(
      () => _i433.UserProfileBloc(gh<_i658.UserRepository>()),
    );
    gh.lazySingleton<_i875.CallsManager>(
      () => _i875.CallsManager(
        gh<_i777.WebSocketClientManager>(),
        gh<_i794.CallsWebSocketClient>(),
        gh<_i217.CallsRestRepository>(),
        gh<_i809.AudioSessionManager>(),
        gh<_i460.SFUStreamManager>(),
      ),
    );
    gh.lazySingleton<_i259.BotsBloc>(
      () => _i259.BotsBloc(gh<_i564.BotsRepository>()),
    );
    gh.lazySingleton<_i860.SearchBloc>(
      () => _i860.SearchBloc(
        gh<_i20.PostRemoteDataSource>(),
        gh<_i937.FilesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i516.UserStatusBloc>(
      () => _i516.UserStatusBloc(
        gh<_i658.UserRepository>(),
        gh<_i777.WebSocketClientManager>(),
      ),
    );
    gh.lazySingleton<_i326.TeamLocalDataSource>(
      () => _i326.TeamLocalDataSourceImpl(
        gh<_i690.AppDatabase>(),
        gh<_i909.ServerManager>(),
      ),
    );
    gh.lazySingleton<_i94.ChatLocalDataSource>(
      () => _i94.ChatLocalDataSourceImpl(
        gh<_i690.AppDatabase>(),
        gh<_i909.ServerManager>(),
      ),
    );
    gh.factory<_i859.AdminConfigBloc>(
      () => _i859.AdminConfigBloc(gh<_i260.AdminConfigRepository>()),
    );
    gh.lazySingleton<_i411.OutboxRetryService>(
      () => _i411.OutboxRetryService(
        gh<_i94.ChatLocalDataSource>(),
        gh<_i20.PostRemoteDataSource>(),
        gh<_i286.ConnectivityMonitor>(),
        gh<_i777.WebSocketClientManager>(),
      ),
    );
    gh.lazySingleton<_i942.AdminSecurityRepository>(
      () => _i360.AdminSecurityRepositoryImpl(
        gh<_i844.AdminSecurityDataSource>(),
      ),
    );
    gh.lazySingleton<_i468.RealtimeSyncService>(
      () => _i468.RealtimeSyncService(
        gh<_i777.WebSocketClientManager>(),
        gh<_i94.ChatLocalDataSource>(),
      ),
    );
    gh.factory<_i233.AdminLicenseBloc>(
      () => _i233.AdminLicenseBloc(gh<_i1016.AdminLicenseRepository>()),
    );
    gh.lazySingleton<_i791.WebsocketDbSyncService>(
      () => _i791.WebsocketDbSyncService(
        gh<_i777.WebSocketClientManager>(),
        gh<_i94.ChatLocalDataSource>(),
        gh<_i690.AppDatabase>(),
        gh<_i140.EventBatchProcessor>(),
      ),
    );
    gh.factory<_i174.AdminPluginsBloc>(
      () => _i174.AdminPluginsBloc(gh<_i386.AdminPluginsRepository>()),
    );
    gh.lazySingleton<_i1011.PermissionsProvider>(
      () => _i1011.PermissionsProvider(
        gh<_i147.RolesRemoteDataSource>(),
        gh<_i690.AppDatabase>(),
        gh<_i909.ServerManager>(),
      ),
    );
    gh.lazySingleton<_i236.ChannelRepository>(
      () => _i585.ChannelRepositoryImpl(
        gh<_i571.ChannelRemoteDataSource>(),
        gh<_i1058.ChannelMembersRemoteDataSource>(),
        gh<_i804.ChannelCategoriesRemoteDataSource>(),
        gh<_i580.ChannelBookmarksRemoteDataSource>(),
        gh<_i94.ChatLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i686.PostRepository>(
      () => _i985.PostRepositoryImpl(
        gh<_i20.PostRemoteDataSource>(),
        gh<_i94.ChatLocalDataSource>(),
        gh<_i1010.ReactionsRemoteDataSource>(),
        gh<_i937.FilesRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
      ),
    );
    gh.factory<_i396.CallsBloc>(
      () => _i396.CallsBloc(gh<_i875.CallsManager>()),
    );
    gh.factory<_i774.CaptionsBloc>(
      () => _i774.CaptionsBloc(gh<_i875.CallsManager>()),
    );
    gh.lazySingleton<_i223.OfflineSyncService>(
      () => _i223.OfflineSyncService(
        gh<_i94.ChatLocalDataSource>(),
        gh<_i686.PostRepository>(),
      ),
    );
    gh.lazySingleton<_i74.TeamDashboardOrchestrator>(
      () => _i74.TeamDashboardOrchestrator(
        gh<_i236.ChannelRepository>(),
        gh<_i236.GroupsRemoteDataSource>(),
        gh<_i931.ThreadsRemoteDataSource>(),
        gh<_i995.DraftsRemoteDataSource>(),
        gh<_i582.ScheduledPostsRemoteDataSource>(),
        gh<_i864.UsersRemoteDataSource>(),
        gh<_i969.UserStatusRemoteDataSource>(),
        gh<_i960.PlaybooksRemoteDataSource>(),
        gh<_i580.ChannelBookmarksRemoteDataSource>(),
        gh<_i953.AgentsRemoteDataSource>(),
        gh<_i20.PostRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        gh<_i787.AuthRepository>(),
        gh<_i777.WebSocketClientManager>(),
        gh<_i791.WebsocketDbSyncService>(),
        gh<_i411.OutboxRetryService>(),
        gh<_i44.LocalNotificationService>(),
        gh<_i223.OfflineSyncService>(),
        gh<_i286.ConnectivityMonitor>(),
        gh<_i1041.DeltaSyncService>(),
        gh<_i977.SystemConfigRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i515.ChannelBloc>(
      () => _i515.ChannelBloc(
        gh<_i236.ChannelRepository>(),
        gh<_i777.WebSocketClientManager>(),
        gh<_i550.TeamBloc>(),
        gh<_i74.TeamDashboardOrchestrator>(),
        gh<_i986.DraftsCubit>(),
        gh<_i1072.ThreadsSummaryCubit>(),
        gh<_i1045.TeamGroupsCubit>(),
      ),
    );
    gh.lazySingleton<_i478.RhsBloc>(
      () => _i478.RhsBloc(gh<_i686.PostRepository>(), gh<_i515.ChannelBloc>()),
    );
    gh.lazySingleton<_i486.PostBloc>(
      () => _i486.PostBloc(
        gh<_i686.PostRepository>(),
        gh<_i777.WebSocketClientManager>(),
        gh<_i428.TypingRemoteDataSource>(),
        gh<_i666.SecureStorageService>(),
        gh<_i515.ChannelBloc>(),
        gh<_i478.RhsBloc>(),
      ),
    );
    return this;
  }
}

class _$StorageModule extends _i371.StorageModule {}
