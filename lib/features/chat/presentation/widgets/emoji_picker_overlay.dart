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

  /// يُظهر منتقي الإيموجي كـ [OverlayEntry] بالقرب من زر معين.
  static void show(
    BuildContext context, {
    required BuildContext anchorContext,
    required Function(String) onEmojiSelected,
  }) {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final anchorBox = anchorContext.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return;

    final screenSize = MediaQuery.sizeOf(context);
    final cardWidth = (screenSize.width - 32).clamp(280.0, 360.0);
    final cardHeight = (screenSize.height - 140).clamp(300.0, 430.0);

    final anchorPos = anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    // حساب الموقع (يفضل فوق الزر إذا وجد مساحة)
    var dx = anchorPos.dx + anchorBox.size.width - cardWidth;
    if (dx < 8) dx = 8;
    if (dx + cardWidth > overlayBox.size.width - 8) {
      dx = overlayBox.size.width - cardWidth - 8;
    }

    var dy = anchorPos.dy - cardHeight - 12;
    // إذا لم تكن هناك مساحة فوق، نعرضه تحت
    if (dy < 8) dy = anchorPos.dy + anchorBox.size.height + 12;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // خلفية شفافة للإغلاق عند النقر خارجاً
          GestureDetector(
            onTap: () => entry.remove(),
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
          Positioned(
            left: dx,
            top: dy,
            child: EmojiPickerOverlay(
              width: cardWidth,
              height: cardHeight,
              onEmojiSelected: (emoji) {
                onEmojiSelected(emoji);
                entry.remove();
              },
              onClose: () => entry.remove(),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

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

    return Card(
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
            // Header: Search field and category tabs
            _buildHeader(theme, l10n),
            // Body: Emojis
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildEmojiGrid(theme)
                  : _buildSearchResults(theme),
            ),
            // Footer: Hovered emoji name
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(MattermostColors theme, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopActions(theme, l10n),
          _buildSearchBar(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildTopActions(MattermostColors theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MenuBar(
        style: MenuStyle(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        ),
        children: [
          MenuItemButton(
            onPressed: null,
            child: Text(
              l10n.emoji_pickerHeader,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          ..._categories.map((cat) {
            final index = _categories.indexOf(cat);
            final isSelected = _tabController.index == index;
            return MenuItemButton(
              onPressed: () {
                setState(() {
                  _tabController.animateTo(index);
                });
              },
              style: MenuItemButton.styleFrom(
                backgroundColor: isSelected ? theme.linkColor.withValues(alpha: 0.1) : null,
                foregroundColor: isSelected ? theme.linkColor : theme.centerChannelColor.withValues(alpha: 0.55),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(40, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Icon(_getCategoryIcon(cat), size: 18),
            );
          }),
          const SizedBox(width: 4),
          MenuItemButton(
            onPressed: widget.onClose,
            style: MenuItemButton.styleFrom(
              foregroundColor: theme.centerChannelColor.withValues(alpha: 0.5),
              minimumSize: const Size(40, 40),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Icon(Icons.close, size: 18),
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

  Widget _buildFooter(MattermostColors theme) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
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