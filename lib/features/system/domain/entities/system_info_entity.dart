class SystemInfoEntity {
  final String version;
  final int maxFileSizeBytes;
  final bool isScheduledPostsEnabled;
  final bool isGuestAccountsEnabled;
  final bool isLicensed;
  final bool isTrial;
  final String skuShortName;

  const SystemInfoEntity({
    required this.version,
    required this.maxFileSizeBytes,
    required this.isScheduledPostsEnabled,
    required this.isGuestAccountsEnabled,
    required this.isLicensed,
    required this.isTrial,
    this.skuShortName = '',
  });
}
