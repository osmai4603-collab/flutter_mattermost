import 'package:equatable/equatable.dart';

class LdapSettingsEntity extends Equatable {
  final bool? Enable;
  final bool? EnableSync;
  final String? LdapServer;
  final int? LdapPort;
  final String? ConnectionSecurity;
  final String? BaseDN;
  final String? BindUsername;
  final String? BindPassword;
  final int? MaximumLoginAttempts;
  final String? UserFilter;
  final String? GroupFilter;
  final String? GuestFilter;
  final bool? EnableAdminFilter;
  final String? AdminFilter;
  final String? GroupDisplayNameAttribute;
  final String? GroupIdAttribute;
  final String? FirstNameAttribute;
  final String? LastNameAttribute;
  final String? EmailAttribute;
  final String? UsernameAttribute;
  final String? NicknameAttribute;
  final String? IdAttribute;
  final String? PositionAttribute;
  final String? LoginIdAttribute;
  final String? PictureAttribute;
  final int? SyncIntervalMinutes;
  final bool? SkipCertificateVerification;
  final String? PublicCertificateFile;
  final String? PrivateKeyFile;
  final int? QueryTimeout;
  final int? MaxPageSize;
  final String? LoginFieldName;

  const LdapSettingsEntity({
    this.Enable,
    this.EnableSync,
    this.LdapServer,
    this.LdapPort,
    this.ConnectionSecurity,
    this.BaseDN,
    this.BindUsername,
    this.BindPassword,
    this.MaximumLoginAttempts,
    this.UserFilter,
    this.GroupFilter,
    this.GuestFilter,
    this.EnableAdminFilter,
    this.AdminFilter,
    this.GroupDisplayNameAttribute,
    this.GroupIdAttribute,
    this.FirstNameAttribute,
    this.LastNameAttribute,
    this.EmailAttribute,
    this.UsernameAttribute,
    this.NicknameAttribute,
    this.IdAttribute,
    this.PositionAttribute,
    this.LoginIdAttribute,
    this.PictureAttribute,
    this.SyncIntervalMinutes,
    this.SkipCertificateVerification,
    this.PublicCertificateFile,
    this.PrivateKeyFile,
    this.QueryTimeout,
    this.MaxPageSize,
    this.LoginFieldName,
  });

  @override
  List<Object?> get props => [
        Enable,
        EnableSync,
        LdapServer,
        LdapPort,
        ConnectionSecurity,
        BaseDN,
        BindUsername,
        BindPassword,
        MaximumLoginAttempts,
        UserFilter,
        GroupFilter,
        GuestFilter,
        EnableAdminFilter,
        AdminFilter,
        GroupDisplayNameAttribute,
        GroupIdAttribute,
        FirstNameAttribute,
        LastNameAttribute,
        EmailAttribute,
        UsernameAttribute,
        NicknameAttribute,
        IdAttribute,
        PositionAttribute,
        LoginIdAttribute,
        PictureAttribute,
        SyncIntervalMinutes,
        SkipCertificateVerification,
        PublicCertificateFile,
        PrivateKeyFile,
        QueryTimeout,
        MaxPageSize,
        LoginFieldName,
      ];

  LdapSettingsEntity copyWith({
    bool? Enable,
    bool? EnableSync,
    String? LdapServer,
    int? LdapPort,
    String? ConnectionSecurity,
    String? BaseDN,
    String? BindUsername,
    String? BindPassword,
    int? MaximumLoginAttempts,
    String? UserFilter,
    String? GroupFilter,
    String? GuestFilter,
    bool? EnableAdminFilter,
    String? AdminFilter,
    String? GroupDisplayNameAttribute,
    String? GroupIdAttribute,
    String? FirstNameAttribute,
    String? LastNameAttribute,
    String? EmailAttribute,
    String? UsernameAttribute,
    String? NicknameAttribute,
    String? IdAttribute,
    String? PositionAttribute,
    String? LoginIdAttribute,
    String? PictureAttribute,
    int? SyncIntervalMinutes,
    bool? SkipCertificateVerification,
    String? PublicCertificateFile,
    String? PrivateKeyFile,
    int? QueryTimeout,
    int? MaxPageSize,
    String? LoginFieldName,
  }) {
    return LdapSettingsEntity(
      Enable: Enable ?? this.Enable,
      EnableSync: EnableSync ?? this.EnableSync,
      LdapServer: LdapServer ?? this.LdapServer,
      LdapPort: LdapPort ?? this.LdapPort,
      ConnectionSecurity: ConnectionSecurity ?? this.ConnectionSecurity,
      BaseDN: BaseDN ?? this.BaseDN,
      BindUsername: BindUsername ?? this.BindUsername,
      BindPassword: BindPassword ?? this.BindPassword,
      MaximumLoginAttempts: MaximumLoginAttempts ?? this.MaximumLoginAttempts,
      UserFilter: UserFilter ?? this.UserFilter,
      GroupFilter: GroupFilter ?? this.GroupFilter,
      GuestFilter: GuestFilter ?? this.GuestFilter,
      EnableAdminFilter: EnableAdminFilter ?? this.EnableAdminFilter,
      AdminFilter: AdminFilter ?? this.AdminFilter,
      GroupDisplayNameAttribute: GroupDisplayNameAttribute ?? this.GroupDisplayNameAttribute,
      GroupIdAttribute: GroupIdAttribute ?? this.GroupIdAttribute,
      FirstNameAttribute: FirstNameAttribute ?? this.FirstNameAttribute,
      LastNameAttribute: LastNameAttribute ?? this.LastNameAttribute,
      EmailAttribute: EmailAttribute ?? this.EmailAttribute,
      UsernameAttribute: UsernameAttribute ?? this.UsernameAttribute,
      NicknameAttribute: NicknameAttribute ?? this.NicknameAttribute,
      IdAttribute: IdAttribute ?? this.IdAttribute,
      PositionAttribute: PositionAttribute ?? this.PositionAttribute,
      LoginIdAttribute: LoginIdAttribute ?? this.LoginIdAttribute,
      PictureAttribute: PictureAttribute ?? this.PictureAttribute,
      SyncIntervalMinutes: SyncIntervalMinutes ?? this.SyncIntervalMinutes,
      SkipCertificateVerification: SkipCertificateVerification ?? this.SkipCertificateVerification,
      PublicCertificateFile: PublicCertificateFile ?? this.PublicCertificateFile,
      PrivateKeyFile: PrivateKeyFile ?? this.PrivateKeyFile,
      QueryTimeout: QueryTimeout ?? this.QueryTimeout,
      MaxPageSize: MaxPageSize ?? this.MaxPageSize,
      LoginFieldName: LoginFieldName ?? this.LoginFieldName,
    );
  }
}
