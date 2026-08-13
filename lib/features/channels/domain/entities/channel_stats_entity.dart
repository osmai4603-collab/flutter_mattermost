/// إحصاءات القناة من GET /channels/{channel_id}/stats — يطابق channelStats في
/// webapp: عدد الأعضاء، عدد الضيوف، وعدد الرسائل المثبتة (في الخوادم الأحدث).
class ChannelStats {
  final String channelId;
  final int memberCount;

  /// عدد أعضاء القناة بصلاحيات ضيف (system_guest) — شارة "has guests".
  final int guestsCount;

  /// عدد الرسائل المثبتة في القناة.
  final int pinnedPostsCount;

  const ChannelStats({
    required this.channelId,
    required this.memberCount,
    this.guestsCount = 0,
    this.pinnedPostsCount = 0,
  });
}