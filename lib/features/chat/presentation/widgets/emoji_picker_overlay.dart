import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';

/// منتقي الإيموجي — يُعرض داخل [OverlayEntry] في [Card] بحجم ثابت:
/// حقل بحث أعلى البطاقة + تبويبات حسب نوع الإيموجي + شبكة إيموجي.
/// النقر على إيموجي يُدرجه في المحرر، وعند التمرير فوقه يظهر اسمه أسفل البطاقة.
class EmojiPickerOverlay extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;

  /// الحجم الثابت للبطاقة (يحدده المتصل عبر [OverlayEntry]).
  final double width;
  final double height;

  const EmojiPickerOverlay({
    super.key,
    required this.onEmojiSelected,
    required this.onClose,
    this.width = 360,
    this.height = 430,
  });

  @override
  State<EmojiPickerOverlay> createState() => _EmojiPickerOverlayState();
}

class _EmojiPickerOverlayState extends State<EmojiPickerOverlay>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _hoveredEmojiName = '';

  // Standard categories from emoji_picker_flutter
  final List<Category> _categories = [
    Category.SMILEYS,
    Category.ANIMALS,
    Category.FOODS,
    Category.ACTIVITIES,
    Category.TRAVEL,
    Category.OBJECTS,
    Category.SYMBOLS,
    Category.FLAGS,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          elevation: 8,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: widget.width,
            height: widget.height,
            color: theme.centerChannelBg,
            child: Column(
              children: [
                _buildHeader(theme, l10n),
                _buildSearchBar(theme, l10n),
                _buildTabs(theme),
                Expanded(
                  child: _searchQuery.isEmpty
                      ? _buildEmojiGrid(theme)
                      : _buildSearchResults(theme),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        _buildEmojiNameBar(theme),
      ],
    );
  }

  Widget _buildHeader(MattermostColors theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.emoji_pickerHeader,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: widget.onClose,
            color: theme.centerChannelColor.withValues(alpha: 0.5),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(MattermostColors theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => setState(() => _searchQuery = val),
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: l10n.emoji_pickerSearch,
          hintStyle: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 18,
            color: theme.centerChannelColor.withValues(alpha: 0.5),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          filled: true,
          fillColor: theme.centerChannelColor.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(MattermostColors theme) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: .start,
      indicatorColor: theme.linkColor,
      labelColor: theme.linkColor,
      unselectedLabelColor: theme.centerChannelColor.withValues(alpha: 0.5),
      tabs: _categories.map((cat) {
        return Tab(icon: Icon(_getCategoryIcon(cat), size: 20));
      }).toList(),
    );
  }

  Widget _buildEmojiGrid(MattermostColors theme) {
    return TabBarView(
      controller: _tabController,
      children: _categories.map((cat) {
        final emojis = defaultEmojiSet
            .firstWhere((e) => e.category == cat)
            .emoji;
        return _EmojiCategoryGrid(
          emojis: emojis,
          onEmojiSelected: widget.onEmojiSelected,
          onHover: (name) => setState(() => _hoveredEmojiName = name),
        );
      }).toList(),
    );
  }

  Widget _buildSearchResults(MattermostColors theme) {
    final results = <Emoji>[];
    final query = _searchQuery.toLowerCase();
    for (final set in defaultEmojiSet) {
      for (final emoji in set.emoji) {
        if (emoji.name.toLowerCase().contains(query)) {
          results.add(emoji);
        }
      }
    }

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No emojis found',
          style: TextStyle(
            color: theme.centerChannelColor.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return _EmojiCategoryGrid(
      emojis: results,
      onEmojiSelected: widget.onEmojiSelected,
      onHover: (name) => setState(() => _hoveredEmojiName = name),
    );
  }

  /// شريط أسفل البطاقة يعرض اسم الإيموجي الذي يمرر عليه المؤشر.
  Widget _buildEmojiNameBar(MattermostColors theme) {
    return Container(
      width: widget.width,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _hoveredEmojiName,
        style: TextStyle(
          color: theme.centerChannelColor.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.SMILEYS:
        return Icons.emoji_emotions_outlined;
      case Category.ANIMALS:
        return Icons.pets_outlined;
      case Category.FOODS:
        return Icons.restaurant_outlined;
      case Category.ACTIVITIES:
        return Icons.sports_basketball_outlined;
      case Category.TRAVEL:
        return Icons.directions_car_outlined;
      case Category.OBJECTS:
        return Icons.lightbulb_outline;
      case Category.SYMBOLS:
        return Icons.emoji_symbols_outlined;
      case Category.FLAGS:
        return Icons.flag_outlined;
      default:
        return Icons.emoji_emotions_outlined;
    }
  }
}

class _EmojiCategoryGrid extends StatelessWidget {
  final List<Emoji> emojis;
  final Function(String) onEmojiSelected;
  final Function(String) onHover;

  const _EmojiCategoryGrid({
    required this.emojis,
    required this.onEmojiSelected,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 45,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        return MouseRegion(
          onEnter: (_) => onHover(emoji.name),
          onExit: (_) => onHover(''),
          child: InkWell(
            onTap: () => onEmojiSelected(emoji.emoji),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              alignment: Alignment.center,
              child: emojiWidget(emoji.emoji, size: 24),
            ),
          ),
        );
      },
    );
  }
}