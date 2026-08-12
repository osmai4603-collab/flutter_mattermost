import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';

class EmojiPickerOverlay extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;

  const EmojiPickerOverlay({
    super.key,
    required this.onEmojiSelected,
    required this.onClose,
  });

  @override
  State<EmojiPickerOverlay> createState() => _EmojiPickerOverlayState();
}

class _EmojiPickerOverlayState extends State<EmojiPickerOverlay>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

    return Container(
      width: 400,
      height: 450,
      decoration: BoxDecoration(
        color: theme.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.centerChannelColor.withValues(alpha: 0.1),
        ),
      ),
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
    );
  }

  Widget _buildHeader(MattermostColors theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
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
        );
      }).toList(),
    );
  }

  Widget _buildSearchResults(MattermostColors theme) {
    // Basic search across all categories
    final results = <Emoji>[];
    for (final set in defaultEmojiSet) {
      for (final emoji in set.emoji) {
        if (emoji.name.contains(_searchQuery.toLowerCase())) {
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

  const _EmojiCategoryGrid({
    required this.emojis,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        return InkWell(
          onTap: () => onEmojiSelected(emoji.emoji),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            alignment: Alignment.center,
            child: emojiWidget(emoji.emoji, size: 24),
          ),
        );
      },
    );
  }
}
