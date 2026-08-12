sealed class JobsEndPoint {
  JobsEndPoint._();

  static const String base = '/jobs';
  static const String root = base;
  static const String types = '$base/types';
  static String type(String jobType) => '$base/type/$jobType';
  static String byJobId(String jobId) => '$base/$jobId';
  static String cancel(String jobId) => '$base/$jobId/cancel';
  static String download(String jobId) => '$base/$jobId/download';
  static String status(String jobId) => '$base/$jobId/status';
}
