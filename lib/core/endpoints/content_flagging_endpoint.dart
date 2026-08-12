sealed class ContentFlaggingEndPoint {
  ContentFlaggingEndPoint._();

  static const String base = '/content_flagging';
  static const String config = '$base/config';
  static const String fields = '$base/fields';
  static const String flagConfig = '$base/flag/config';
  static String post(String postId) => '$base/post/$postId';
  static String postAssign(String postId, String contentReviewerId) =>
      '$base/post/$postId/assign/$contentReviewerId';
  static String postFieldValues(String postId) =>
      '$base/post/$postId/field_values';
  static String postFlag(String postId) => '$base/post/$postId/flag';
  static String postKeep(String postId) => '$base/post/$postId/keep';
  static String postRemove(String postId) => '$base/post/$postId/remove';
  static String postReport(String postId) => '$base/post/$postId/report';
  static String teamReviewersSearch(String teamId) =>
      '$base/team/$teamId/reviewers/search';
  static String teamStatus(String teamId) => '$base/team/$teamId/status';
}
