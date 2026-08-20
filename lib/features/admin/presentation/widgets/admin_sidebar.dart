import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/theme/app_fonts.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/resource_keys.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/admin_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_email_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_guest_access_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_ldap_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_mfa_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_openid_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_password_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/auth_saml_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/data_retention_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/compliance_export_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/compliance_monitoring_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/audit_logging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/compliance/custom_terms_of_service_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/experimental/experimental_features_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/experimental/feature_flags_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/integrations/integration_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/integrations/bot_accounts_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/integrations/gif_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/integrations/cors_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/integrations/embedding_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins/plugins_management_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins/agents_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins/calls_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/plugins/playbooks_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/notifications_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/server_logs_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/workspace_optimization_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/system_statistics_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/reporting/team_statistics_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/users_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/groups_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/teams_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/channels_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/permissions_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/authentication/delegated_admin_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/system_attributes/user_attributes_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/system_attributes/attribute_based_access_control_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/customization_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/localization_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/users_and_teams_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/classification_markings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/system_wide_notifications_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/emoji_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/posts_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/recap_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/data_spillage_handling_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/file_sharing_and_downloads_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/public_links_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/site_configuration/notices_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/web_server_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/database_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/elasticsearch_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/file_storage_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/image_proxy_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/smtp_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/push_notification_server_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/high_availability_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/cache_settings_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/rate_limiting_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/logging_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/session_lengths_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/performance_monitoring_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/developer_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/environment/mobile_security_page.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:go_router/go_router.dart';

/// القائمة الجانبية المحدثة للوحة التحكم (Admin Console Sidebar)
/// مصممة وفقاً لهيكل وتصميم Mattermost System Console في webapp.
class AdminConsoleSideBar extends StatefulWidget {
  const AdminConsoleSideBar({
    super.key,
    required this.selected,
    required this.onBodyChange,
  });

  final AdminConsoleSection selected;
  final ValueChanged<Widget> onBodyChange;

  @override
  State<AdminConsoleSideBar> createState() => _AdminConsoleSideBarState();
}

class _AdminConsoleSideBarState extends State<AdminConsoleSideBar> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _collapsedCategories = {};
  AdminConsoleSection sectionSelected = AdminConsoleSection.editionAndLicense;

  @override
  void initState() {
    super.initState();
    sectionSelected = widget.selected;
    _ensureSelectedCategoryExpanded();
  }

  @override
  void didUpdateWidget(covariant AdminConsoleSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      sectionSelected = widget.selected;
      _ensureSelectedCategoryExpanded();
    }
  }

  void _ensureSelectedCategoryExpanded() {
    for (final group in AdminConsoleSection.sectionsGroup) {
      final categoryTitle = group.$1;
      final sections = group.$3;
      if (sections.contains(widget.selected)) {
        _collapsedCategories.remove(categoryTitle);
        break;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      final teamState = context.read<TeamBloc>().state;
      final teamName = teamState is TeamsLoadedState
          ? teamState.selectedTeam?.name
          : null;
      if (teamName != null) {
        context.go('/$teamName');
      } else {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final groups = AdminConsoleSection.sectionsGroup;
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    // final access = ConsoleAccessEntity.fromUserAndRoles(currentUser, []);
    final colors = AppTheme.of(context);

    final sidebarBg = colors.centerChannelColor;
    final headerBg = colors.centerChannelColor.withValues(alpha: 0.50);
    final cardBg = colors.centerChannelColor.withValues(alpha: 70);

    return Container(
      width: 221,
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(right: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (User profile & System Console Title)
          _buildHeader(context, currentUser, headerBg),

          // 2. Search Field
          _buildSearchBar(cardBg),

          // 3. Main Sections List with Collapsible Categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 6),
              children: [
                containerGroup(
                  title: ResourceKeys.about,
                  icon: Icons.info_outline_rounded,
                ),
                ...aboutGroupList(colors),

                containerGroup(
                  title: ResourceKeys.reporting,
                  icon: Icons.info_outline_rounded,
                ),
                ...reportingGroupList(colors),

                containerGroup(
                  title: ResourceKeys.userManagement,
                  icon: Icons.group_outlined,
                ),
                ...userManagementGroupList(colors),

                containerGroup(
                  title: 'SYSTEM ATTRIBUTES',
                  icon: Icons.computer,
                ),
                ...systemAttributesGroupList(colors),

                containerGroup(title: 'ENVIRONMENT', icon: Icons.anchor),
                ...environmentGroupList(colors),

                containerGroup(
                  title: 'SITE CONFIGURATION',
                  icon: Icons.settings_outlined,
                ),
                ...siteConfigurationGroupList(colors),

                containerGroup(title: 'PLUGINS', icon: Icons.female),
                ...pluginsGroupList(colors),

                containerGroup(
                  title: 'AUTHENTICATION',
                  icon: Icons.safety_check,
                ),
                ...authenticationGroupList(colors),

                containerGroup(title: 'INTEGRATIONS', icon: Icons.menu),
                ...integrationsGroupList(colors),

                containerGroup(title: 'COMPLIANCE', icon: Icons.menu),
                ...complianceGroupList(colors),

                containerGroup(title: 'INTEGRATIONS', icon: Icons.menu),
                ...experimentalGroupList(colors),
              ],
            ),
          ),

          _buildFooter(context),
        ],
      ),
    );
  }

  List<Widget> experimentalGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Features',
        section: .features,
        colors: colors,
        onTap: () => ExperimentalFeaturesPage(),
      ),
      groupChild(
        title: 'Feature Flags',
        section: .featureFlags,
        colors: colors,
        onTap: () => FeatureFlagsPage(),
      ),
    ];
  }

  List<Widget> complianceGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Data Retention Policies',
        section: .dataRetention,
        colors: colors,
        onTap: () => AdminConsoleDataRetentionPage(),
      ),
      groupChild(
        title: 'Compliance Export',
        section: .complianceExport,
        colors: colors,
        onTap: () => AdminConsoleComplianceExportPage(),
      ),
      groupChild(
        title: 'Compliance Monitoring',
        section: .complicanceMonitoring,
        colors: colors,
        onTap: () => AdminConsoleComplianceMonitoringPage(),
      ),
      groupChild(
        title: 'Audit Logging',
        section: .auditLogging,
        colors: colors,
        onTap: () => AdminConsoleAuditLoggingPage(),
      ),
      groupChild(
        title: 'Custom Terms of Service',
        section: .customTermsOfService,
        colors: colors,
        onTap: () => AdminConsoleCustomTermsOfServicePage(),
      ),
    ];
  }

  List<Widget> integrationsGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Integration Management',
        section: .integrationManagement,
        colors: colors,
        onTap: () => IntegrationManagementPage(),
      ),
      groupChild(
        title: 'Bot Accounts',
        section: .botAccounts,
        colors: colors,
        onTap: () => BotAccountsPage(),
      ),
      groupChild(
        title: 'GIF',
        section: .gif,
        colors: colors,
        onTap: () => GifSettingsPage(),
      ),
      groupChild(
        title: 'CORS',
        section: .cors,
        colors: colors,
        onTap: () => CorsSettingsPage(),
      ),
      groupChild(
        title: 'Embedding',
        section: .embedding,
        colors: colors,
        onTap: () => EmbeddingSettingsPage(),
      ),
    ];
  }

  List<Widget> pluginsGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Plugin Management',
        section: .pluginsManagement,
        colors: colors,
        onTap: () => AdminConsolePluginsManagementPage(),
      ),
      groupChild(
        title: 'Agents',
        section: .agents,
        colors: colors,
        onTap: () => AgentsSettingsPage(),
      ),
      groupChild(
        title: 'Calls',
        section: .calls,
        colors: colors,
        onTap: () => CallsSettingsPage(),
      ),
      groupChild(
        title: 'Playbooks',
        section: .playbooks,
        colors: colors,
        onTap: () => PlaybooksSettingsPage(),
      ),
    ];
  }

  List<Widget> authenticationGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Signup',
        section: .signup,
        colors: colors,
        onTap: () => SignupPage(),
      ),
      groupChild(
        title: 'Email',
        section: .email,
        colors: colors,
        onTap: () => EmailPage(),
      ),
      groupChild(
        title: 'Password',
        section: .password,
        colors: colors,
        onTap: () => AdminConsoleAuthPasswordPage(),
      ),
      groupChild(
        title: 'MFA',
        section: .mfa,
        colors: colors,
        onTap: () => AdminConsoleAuthMfaPage(),
      ),
      groupChild(
        title: 'AD/LDAP',
        section: .adALDAP,
        colors: colors,
        onTap: () => AdminConsoleAuthLdapPage(),
      ),
      groupChild(
        title: 'SAML 2.0',
        section: .saml,
        colors: colors,
        onTap: () => AdminConsoleAuthSamlPage(),
      ),
      groupChild(
        title: 'OpenID Connect',
        section: .openIDConnect,
        colors: colors,
        onTap: () => AdminConsoleAuthOpenIdPage(),
      ),
      groupChild(
        title: 'Gest Access',
        section: .guestAccess,
        colors: colors,
        onTap: () => AdminConsoleAuthGuestAccessPage(),
      ),
    ];
  }

  List<Widget> siteConfigurationGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Customization',
        section: .customization,
        colors: colors,
        onTap: () => CustomizationPage(),
      ),
      groupChild(
        title: 'Localization',
        section: .localization,
        colors: colors,
        onTap: () => LocalizationPage(),
      ),
      groupChild(
        title: 'Users and Teams',
        section: .usersAndTeams,
        colors: colors,
        onTap: () => UsersAndTeamsPage(),
      ),
      groupChild(
        title: 'Notifications',
        section: .notifications,
        colors: colors,
        onTap: () => AdminConsoleNotificationsSettingsPage(),
      ),
      groupChild(
        title: 'Classification Markings',
        section: .classificationMarkings,
        colors: colors,
        onTap: () => ClassificationMarkingsPage(),
      ),
      groupChild(
        title: 'System-wide Notifications',
        section: .systemWideNotifications,
        colors: colors,
        onTap: () => SystemWideNotificationsPage(),
      ),
      groupChild(
        title: 'Emoji',
        section: .emoji,
        colors: colors,
        onTap: () => EmojiPage(),
      ),
      groupChild(
        title: 'Posts',
        section: .posts,
        colors: colors,
        onTap: () => PostsPage(),
      ),
      groupChild(
        title: 'Recap',
        section: .recap,
        colors: colors,
        onTap: () => RecapPage(),
      ),
      groupChild(
        title: 'Data Spillage Handling',
        section: .dataSpillageHandling,
        colors: colors,
        onTap: () => DataSpillageHandlingPage(),
      ),
      groupChild(
        title: 'File Sharing and Downloads',
        section: .fileSharingAndDownloads,
        colors: colors,
        onTap: () => FileSharingAndDownloadsPage(),
      ),
      groupChild(
        title: 'Public Links',
        section: .publicLinks,
        colors: colors,
        onTap: () => PublicLinksPage(),
      ),
      groupChild(
        title: 'Notices',
        section: .notices,
        colors: colors,
        onTap: () => NoticesPage(),
      ),
    ];
  }

  List<Widget> environmentGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Web Server',
        section: .webServer,
        colors: colors,
        onTap: () => WebServerPage(),
      ),
      groupChild(
        title: 'Database',
        section: .database,
        colors: colors,
        onTap: () => DatabasePage(),
      ),
      groupChild(
        title: 'Elasticsearch',
        section: .elasticsearch,
        colors: colors,
        onTap: () => ElasticsearchPage(),
      ),
      groupChild(
        title: 'File Storage',
        section: .fileStorage,
        colors: colors,
        onTap: () => FileStoragePage(),
      ),
      groupChild(
        title: 'Image Proxy',
        section: .imageProxy,
        colors: colors,
        onTap: () => ImageProxyPage(),
      ),
      groupChild(
        title: 'SMTP',
        section: .smtp,
        colors: colors,
        onTap: () => SmtpPage(),
      ),
      groupChild(
        title: 'Push Notification Server',
        section: .pushNotificationsServer,
        colors: colors,
        onTap: () => PushNotificationServerPage(),
      ),
      groupChild(
        title: 'High Availability',
        section: .highAvailability,
        colors: colors,
        onTap: () => HighAvailabilityPage(),
      ),
      groupChild(
        title: 'Cache Settings',
        section: .cacheSettings,
        colors: colors,
        onTap: () => CacheSettingsPage(),
      ),
      groupChild(
        title: 'Rate Limiting',
        section: .rateLimiting,
        colors: colors,
        onTap: () => RateLimitingPage(),
      ),
      groupChild(
        title: 'Logging',
        section: .logging,
        colors: colors,
        onTap: () => LoggingPage(),
      ),
      groupChild(
        title: 'Session Lengths',
        section: .sessionLengths,
        colors: colors,
        onTap: () => SessionLengthsPage(),
      ),
      groupChild(
        title: 'Performance Monitoring',
        section: .performanceMonitoring,
        colors: colors,
        onTap: () => PerformanceMonitoringPage(),
      ),
      groupChild(
        title: 'Developer',
        section: .developer,
        colors: colors,
        onTap: () => DeveloperPage(),
      ),
      groupChild(
        title: 'Mobile Security',
        section: .mobileSecurity,
        colors: colors,
        onTap: () => MobileSecurityPage(),
      ),
    ];
  }

  List<Widget> systemAttributesGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'User Attributes',
        section: .userAttributes,
        colors: colors,
        onTap: () => UserAttributesPage(),
      ),
      groupChild(
        title: 'Attribute-Based Access',
        section: .attributeBasedAccessControl,
        colors: colors,
        onTap: () => AttributeBasedAccessControlPage(),
      ),
      groupChild(
        title: 'Membership Policies',
        section: .membershipPolicies,
        colors: colors,
        onTap: () => Container(),
      ),
      groupChild(
        title: 'Permission Policies',
        section: .permissionPolicies,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> aboutGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Edition and License',
        section: .editionAndLicense,
        colors: colors,
        onTap: () => Container(),
      ),
    ];
  }

  List<Widget> reportingGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'WorkSpace Optimization',
        section: .workSpaceOptimization,
        colors: colors,
        onTap: () => WorkspaceOptimizationPage(),
      ),
      groupChild(
        title: 'System Statistics',
        section: .systemStatistics,
        colors: colors,
        onTap: () => SystemStatisticsPage(),
      ),
      groupChild(
        title: 'Team Statistics',
        section: .teamStatistics,
        colors: colors,
        onTap: () => TeamStatisticsPage(),
      ),
      groupChild(
        title: 'Server Logs',
        section: .serverLogs,
        colors: colors,
        onTap: () => AdminConsoleServerLogsPage(),
      ),
    ];
  }

  List<Widget> userManagementGroupList(MattermostColors colors) {
    return [
      groupChild(
        title: 'Users',
        section: .users,
        colors: colors,
        onTap: () => UsersPage(),
      ),
      groupChild(
        title: 'Groups',
        section: .groups,
        colors: colors,
        onTap: () => AdminConsoleGroupsPage(),
      ),
      groupChild(
        title: 'Teams',
        section: .teams,
        colors: colors,
        onTap: () => TeamsPage(),
      ),
      groupChild(
        title: 'Channels',
        section: .channels,
        colors: colors,
        onTap: () => AdminConsoleChannelsManagementPage(),
      ),
      groupChild(
        title: 'Permissions',
        section: .permissions,
        colors: colors,
        onTap: () => AdminConsolePermissionsPage(),
      ),
      groupChild(
        title: 'Delegated Granular Administration',
        section: .delegatedGranularAdministration,
        colors: colors,
        onTap: () => AdminConsoleDelegatedAdminPage(),
      ),
    ];
  }

  Widget containerGroup({required String title, required IconData icon}) {
    final colors = AppTheme.of(context);
    return Container(
      height: 40,
      margin: .symmetric(vertical: 4),
      padding: .symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors
            .white12, // colors.centerChannelColor.withValues(alpha: 0.65),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(icon, size: 18, color: colors.centerChannelBg),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: .w500,
              fontFamily: AppFonts.monaco,
              color: colors.centerChannelBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget groupChild({
    required String title,
    required AdminConsoleSection section,
    required MattermostColors colors,
    required Widget Function() onTap,
  }) {
    final isSelected = sectionSelected == section;
    return InkWell(
      onTap: () {
        widget.onBodyChange(onTap());
        setState(() => sectionSelected = section);
      },
      child: Container(
        color: isSelected
            ? Colors
                  .white12 // colors.centerChannelColor.withValues(alpha: 0.50)
            : null,
        height: 32,
        child: HoverWidget(
          builder: (context, isHovered) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: .centerStart,
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: .w400,
                    fontSize: 13,
                    fontFamily: AppFonts.menlo,
                    color: isHovered && !isSelected
                        ? colors.linkColor.withValues(alpha: 0.70)
                        : isSelected
                        ? colors.centerChannelBg
                        : colors.centerChannelBg.withValues(alpha: 0.70),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// رأس القائمة الجانبية بمظهر كروت المستخدم والتحكم
  Widget _buildHeader(
    BuildContext context,
    dynamic currentUser,
    Color headerBg,
  ) {
    final username = currentUser?.username ?? 'admin';
    final initial = username.isNotEmpty ? username[0].toUpperCase() : 'A';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: BoxDecoration(
        color: headerBg,
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: Colors.blueAccent.withValues(alpha: 0.25),
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'System Console',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '@$username',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white54,
              size: 20,
            ),
            tooltip: 'Exit System Console',
            onPressed: () => _onBack(context),
          ),
        ],
      ),
    );
  }

  /// شريط البحث "Find settings..."
  Widget _buildSearchBar(Color cardBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: SizedBox(
        height: 32,
        child: TextField(
          controller: _searchController,
          onChanged: (val) =>
              setState(() => _searchQuery = val.trim().toLowerCase()),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Find settings...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Colors.white38,
              size: 16,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white38,
                        size: 14,
                      ),
                    ),
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white24,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  /// زر الفوتر السفلي للعودة للورشة / الفريق
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: InkWell(
        onTap: () => _onBack(context),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            children: const [
              Icon(
                Icons.arrow_back_rounded,
                color: Colors.blueAccent,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Back to Workspace',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ويدجت تغليف الهامش والحاوية
class MarginPaddingContainer extends StatelessWidget {
  final Widget child;

  const MarginPaddingContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: child);
  }
}
