import 'package:equatable/equatable.dart';

class EnvironmentConfigEntity extends Equatable {
  final Map<String, dynamic>? ServiceSettings;
  final Map<String, dynamic>? TeamSettings;
  final Map<String, dynamic>? SqlSettings;
  final Map<String, dynamic>? LogSettings;
  final Map<String, dynamic>? PasswordSettings;
  final Map<String, dynamic>? FileSettings;
  final Map<String, dynamic>? EmailSettings;
  final Map<String, dynamic>? RateLimitSettings;
  final Map<String, dynamic>? PrivacySettings;
  final Map<String, dynamic>? SupportSettings;
  final Map<String, dynamic>? GitLabSettings;
  final Map<String, dynamic>? GoogleSettings;
  final Map<String, dynamic>? Office365Settings;
  final Map<String, dynamic>? LdapSettings;
  final Map<String, dynamic>? ComplianceSettings;
  final Map<String, dynamic>? LocalizationSettings;
  final Map<String, dynamic>? SamlSettings;
  final Map<String, dynamic>? NativeAppSettings;
  final Map<String, dynamic>? ClusterSettings;
  final Map<String, dynamic>? MetricsSettings;
  final Map<String, dynamic>? AnalyticsSettings;

  const EnvironmentConfigEntity({
    this.ServiceSettings,
    this.TeamSettings,
    this.SqlSettings,
    this.LogSettings,
    this.PasswordSettings,
    this.FileSettings,
    this.EmailSettings,
    this.RateLimitSettings,
    this.PrivacySettings,
    this.SupportSettings,
    this.GitLabSettings,
    this.GoogleSettings,
    this.Office365Settings,
    this.LdapSettings,
    this.ComplianceSettings,
    this.LocalizationSettings,
    this.SamlSettings,
    this.NativeAppSettings,
    this.ClusterSettings,
    this.MetricsSettings,
    this.AnalyticsSettings,
  });

  @override
  List<Object?> get props => [
        ServiceSettings,
        TeamSettings,
        SqlSettings,
        LogSettings,
        PasswordSettings,
        FileSettings,
        EmailSettings,
        RateLimitSettings,
        PrivacySettings,
        SupportSettings,
        GitLabSettings,
        GoogleSettings,
        Office365Settings,
        LdapSettings,
        ComplianceSettings,
        LocalizationSettings,
        SamlSettings,
        NativeAppSettings,
        ClusterSettings,
        MetricsSettings,
        AnalyticsSettings,
      ];

  EnvironmentConfigEntity copyWith({
    Map<String, dynamic>? ServiceSettings,
    Map<String, dynamic>? TeamSettings,
    Map<String, dynamic>? SqlSettings,
    Map<String, dynamic>? LogSettings,
    Map<String, dynamic>? PasswordSettings,
    Map<String, dynamic>? FileSettings,
    Map<String, dynamic>? EmailSettings,
    Map<String, dynamic>? RateLimitSettings,
    Map<String, dynamic>? PrivacySettings,
    Map<String, dynamic>? SupportSettings,
    Map<String, dynamic>? GitLabSettings,
    Map<String, dynamic>? GoogleSettings,
    Map<String, dynamic>? Office365Settings,
    Map<String, dynamic>? LdapSettings,
    Map<String, dynamic>? ComplianceSettings,
    Map<String, dynamic>? LocalizationSettings,
    Map<String, dynamic>? SamlSettings,
    Map<String, dynamic>? NativeAppSettings,
    Map<String, dynamic>? ClusterSettings,
    Map<String, dynamic>? MetricsSettings,
    Map<String, dynamic>? AnalyticsSettings,
  }) {
    return EnvironmentConfigEntity(
      ServiceSettings: ServiceSettings ?? this.ServiceSettings,
      TeamSettings: TeamSettings ?? this.TeamSettings,
      SqlSettings: SqlSettings ?? this.SqlSettings,
      LogSettings: LogSettings ?? this.LogSettings,
      PasswordSettings: PasswordSettings ?? this.PasswordSettings,
      FileSettings: FileSettings ?? this.FileSettings,
      EmailSettings: EmailSettings ?? this.EmailSettings,
      RateLimitSettings: RateLimitSettings ?? this.RateLimitSettings,
      PrivacySettings: PrivacySettings ?? this.PrivacySettings,
      SupportSettings: SupportSettings ?? this.SupportSettings,
      GitLabSettings: GitLabSettings ?? this.GitLabSettings,
      GoogleSettings: GoogleSettings ?? this.GoogleSettings,
      Office365Settings: Office365Settings ?? this.Office365Settings,
      LdapSettings: LdapSettings ?? this.LdapSettings,
      ComplianceSettings: ComplianceSettings ?? this.ComplianceSettings,
      LocalizationSettings: LocalizationSettings ?? this.LocalizationSettings,
      SamlSettings: SamlSettings ?? this.SamlSettings,
      NativeAppSettings: NativeAppSettings ?? this.NativeAppSettings,
      ClusterSettings: ClusterSettings ?? this.ClusterSettings,
      MetricsSettings: MetricsSettings ?? this.MetricsSettings,
      AnalyticsSettings: AnalyticsSettings ?? this.AnalyticsSettings,
    );
  }
}
