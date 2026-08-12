sealed class EmojiEndPoint {
  EmojiEndPoint._();

  static const String base = '/emoji';
  static const String root = base;
  static const String autocomplete = '$base/autocomplete';
  static String name(String emojiName) => '$base/name/$emojiName';
  static const String names = '$base/names';
  static const String search = '$base/search';
  static String byEmojiId(String emojiId) => '$base/$emojiId';
  static String image(String emojiId) => '$base/$emojiId/image';
}
