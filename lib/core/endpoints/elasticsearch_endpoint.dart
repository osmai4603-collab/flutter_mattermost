sealed class ElasticsearchEndPoint {
  ElasticsearchEndPoint._();

  static const String base = '/elasticsearch';
  static const String purgeIndexes = '$base/purge_indexes';
  static const String test = '$base/test';
}
