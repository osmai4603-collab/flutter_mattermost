import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/hover_widget.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';

/// منتقي الإيموجي — يُعرض داخل [OverlayEntry] في [Card] بحجم ثابت:
/// حقل بحث أعلى البطاقة + تبويبات حسب نوع الإيموجي + شبكة إيموجي.
/// النقر على إيموجي يُدرجه في المحرر، وعند التمرير فوقه يظهر اسمه أسفل البطاقة.
class EmojiPickerOverlay extends StatefulWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback onClose;
  final bool multiSelected;

  /// الحجم الثابت للبطاقة (يحدده المتصل عبر [OverlayEntry]).
  final double width;
  final double height;

  /// يُظهر منتقي الإيموجي كـ [OverlayEntry] بالقرب من زر معين.
  static void show(
    BuildContext context, {
    required BuildContext anchorContext,
    required Function(String) onEmojiSelected,
    VoidCallback? onDismissed,
    bool multiSelected = true,
  }) {
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final anchorBox = anchorContext.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return;

    final screenSize = MediaQuery.sizeOf(context);
    final cardWidth = (screenSize.width - 32).clamp(280.0, 360.0);
    final cardHeight = (screenSize.height - 140).clamp(300.0, 430.0);

    final anchorPos = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );

    // محاذاة البطاقة مع الحافة اليمنى للشاشة
    var dx = overlayBox.size.width - cardWidth - 8;
    if (dx < 8) dx = 8;

    var dy = anchorPos.dy - cardHeight - 12;
    // إذا لم تكن هناك مساحة فوق، نعرضه تحت
    if (dy < 8) dy = anchorPos.dy + anchorBox.size.height + 12;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // خلفية شفافة للإغلاق عند النقر خارجاً
          GestureDetector(
            onTap: () {
              entry.remove();
              onDismissed?.call();
            },
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
          Positioned(
            left: dx,
            top: dy,
            child: EmojiPickerOverlay(
              width: cardWidth,
              multiSelected: multiSelected,
              height: cardHeight,
              onEmojiSelected: (emoji) {
                onEmojiSelected(emoji);
                entry.remove();
              },
              onClose: () {
                entry.remove();
                onDismissed?.call();
              },
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
    this.multiSelected = true,
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
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _hoveredEmojiName = '';
  int _activeTabIndex = 0;
  bool _isScrollingFromTabTap = false;

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

  // كل مجموعة: العناصر = 1 عنوان + عدد الإيموجي
  // الصورة تبدأ عند index 1+emojisCount لكل فئة
  late final List<_CategorySection> _sections;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _sections = _categories.map((cat) {
      final emojis = defaultEmojiSet.firstWhere((e) => e.category == cat).emoji;
      return _CategorySection(category: cat, emojis: emojis);
    }).toList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isScrollingFromTabTap) return;
    if (!_scrollController.hasClients) return;

    // حساب منتصف المنطقة المرئية
    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final middle = scrollOffset + viewportHeight / 3;

    // تحديد أي فئة مرئية حالياً
    int closestIndex = 0;
    double closestDistance = double.infinity;

    double cumulativeHeight = 0;
    for (int i = 0; i < _sections.length; i++) {
      // ارتفاع العنوان + عدد صفوف الإيموجي * حجم كل صورة
      final sectionHeight =
          36.0 + // category header
          ((_sections[i].emojis.length / 8).ceil() * 49.0); // grid rows
      final sectionMiddle = cumulativeHeight + sectionHeight / 2;
      final distance = (middle - sectionMiddle).abs();
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
      cumulativeHeight += sectionHeight;
    }

    if (closestIndex != _activeTabIndex) {
      setState(() => _activeTabIndex = closestIndex);
      _tabController.index = closestIndex;
    }
  }

  void _scrollToCategory(int index) {
    _isScrollingFromTabTap = true;
    double targetOffset = 0;
    for (int i = 0; i < index; i++) {
      targetOffset += 36.0 + ((_sections[i].emojis.length / 8).ceil() * 49.0);
    }
    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        )
        .then((_) {
          _isScrollingFromTabTap = false;
        });
    setState(() => _activeTabIndex = index);
    _tabController.index = index;
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
          _buildTopBar(theme, l10n),
          _buildSearchBar(theme, l10n),
          _buildTopActions(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildTopBar(MattermostColors theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Text(
            l10n.emoji_pickerHeader,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(Icons.close, size: 18),
            color: theme.centerChannelColor.withValues(alpha: 0.5),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
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
          const Spacer(),
          ..._categories.map((cat) {
            final index = _categories.indexOf(cat);
            final isSelected = _tabController.index == index;
            return MenuItemButton(
              onPressed: () => _scrollToCategory(index),
              style: MenuItemButton.styleFrom(
                backgroundColor: isSelected
                    ? theme.linkColor.withValues(alpha: 0.1)
                    : null,
                foregroundColor: isSelected
                    ? theme.linkColor
                    : theme.centerChannelColor.withValues(alpha: 0.55),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Icon(_getCategoryIcon(cat), size: 18),
            );
          }),
          const SizedBox(width: 4),
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
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: _sections.length,
      itemBuilder: (context, index) {
        final section = _sections[index];
        return _EmojiCategorySection(
          category: section.category,
          emojis: section.emojis,
          onEmojiSelected: (emojiName) {
            widget.onEmojiSelected(emojiName);
            if (!widget.multiSelected) Navigator.pop(context);
          },
          onHover: (name) => setState(() => _hoveredEmojiName = name),
        );
      },
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

class _CategorySection {
  final Category category;
  final List<Emoji> emojis;

  const _CategorySection({required this.category, required this.emojis});
}

class _EmojiCategorySection extends StatelessWidget {
  final Category category;
  final List<Emoji> emojis;
  final Function(String) onEmojiSelected;
  final Function(String) onHover;

  const _EmojiCategorySection({
    required this.category,
    required this.emojis,
    required this.onEmojiSelected,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 8, bottom: 4),
          child: Text(
            category.name,
            style: TextStyle(
              color: theme.centerChannelColor.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Emoji grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            return HoverWidget(
              builder: (context, isHovered) {
                return EmojiGridItem(
                  onHover: onHover,
                  onEmojiSelected: onEmojiSelected,
                  emoji: emojis[index],
                  isHovered: isHovered,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class EmojiGridItem extends StatelessWidget {
  const EmojiGridItem({
    super.key,
    required this.onHover,
    required this.onEmojiSelected,
    required this.emoji,
    required this.isHovered,
  });

  final Function(String) onHover;
  final Function(String) onEmojiSelected;
  final Emoji emoji;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(emoji.name),
      onExit: (_) => onHover(''),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onEmojiSelected(emoji.emoji),
          borderRadius: BorderRadius.circular(6),
          child: AnimatedScale(
            scale: isHovered ? 1.25 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              alignment: Alignment.center,
              child: emojiWidget(emoji.emoji, size: 24),
            ),
          ),
        ),
      ),
    );
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
