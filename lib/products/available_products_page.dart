import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nway_love_vet_clinic/profile/profile_page.dart';
import 'package:nway_love_vet_clinic/shared/feature_info_page.dart';

class AvailableProductsPage extends StatefulWidget {
  const AvailableProductsPage({super.key});

  static const _petsIconAsset = 'icons/IMG_5276.png';
  static const _clinicIconAsset =
      'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';
  static const _basketIconAsset =
      'icons/8f867c18-75ec-4219-91c8-9d4f26c50e51.png';
  static const _profileIconAsset =
      'icons/4104c0eb-80f2-4722-8cfc-1148a0291965.png';

  @override
  State<AvailableProductsPage> createState() => _AvailableProductsPageState();
}

class _AvailableProductsPageState extends State<AvailableProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Product';
  bool _showQuickMenu = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ProductItem> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();

    return _products.where((product) {
      final matchesCategory = _selectedCategory == 'All Product' ||
          product.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showQuickMenuPage({
    required String title,
    required IconData icon,
    required List<String> items,
  }) {
    setState(() {
      _showQuickMenu = false;
    });

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FeatureInfoPage(
          title: title,
          icon: icon,
          accentColor: const Color(0xFFAFC5B8),
          sections: [
            FeatureInfoSection(
              heading: 'Details',
              items: items,
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(_ProductItem product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FeatureInfoPage(
          title: product.name,
          icon: product.icon,
          accentColor: product.iconColor,
          primaryActionLabel: 'Add to Cart',
          sections: [
            FeatureInfoSection(
              heading: 'Price',
              items: ['${product.price} MMK'],
            ),
            FeatureInfoSection(
              heading: 'About This Product',
              items: [
                product.description,
                'Category: ${product.category}',
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFC5B8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _ProductsMetrics.fromSize(constraints.biggest);
            final products = _filteredProducts;

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFFAFC5B8),
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: metrics.maxContentWidth,
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              metrics.sidePadding,
                              metrics.topPadding,
                              metrics.sidePadding,
                              metrics.bottomDockSpacing + metrics.bottomNavHeight,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Back',
                                      onPressed: () => Navigator.of(context).pop(),
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: metrics.backIconSize,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Available Products',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: metrics.titleSize,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: metrics.backIconSlotWidth),
                                  ],
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SearchBar(
                                  metrics: metrics,
                                  controller: _searchController,
                                  onChanged: (_) => setState(() {}),
                                ),
                                SizedBox(height: metrics.sectionGap),
                                Text(
                                  '${products.length} products available',
                                  style: TextStyle(
                                    fontSize: metrics.helperTextSize,
                                    color: const Color(0xFF41544C),
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap * 0.6),
                                _CategoryTabs(
                                  metrics: metrics,
                                  selectedCategory: _selectedCategory,
                                  onSelected: (category) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                ),
                                SizedBox(height: metrics.sectionGap),
                                if (products.isEmpty)
                                  _EmptyProductsState(metrics: metrics)
                                else
                                  GridView.builder(
                                    itemCount: products.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: metrics.gridCrossAxisCount,
                                      mainAxisSpacing: metrics.gridSpacing,
                                      crossAxisSpacing: metrics.gridSpacing,
                                      mainAxisExtent: metrics.productCardHeight,
                                    ),
                                    itemBuilder: (context, index) {
                                      return _ProductCard(
                                      product: products[index],
                                      metrics: metrics,
                                      onTap: () => _showProductDetails(products[index]),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showQuickMenu)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showQuickMenu = false;
                        });
                      },
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.20),
                      ),
                    ),
                  ),
                if (_showQuickMenu)
                  Positioned(
                    right: metrics.quickMenuRight,
                    bottom: metrics.quickMenuBottom,
                    child: _QuickMenu(
                      metrics: metrics,
                      onOrdersTap: () => _showQuickMenuPage(
                        title: 'Orders',
                        icon: Icons.fact_check_outlined,
                        items: const [
                          'Order #2301 is being prepared for pickup.',
                          'Order #2288 was delivered successfully last week.',
                        ],
                      ),
                      onCartTap: () => _showQuickMenuPage(
                        title: 'Cart',
                        icon: Icons.shopping_cart_outlined,
                        items: const [
                          'Dog Food 02 x1',
                          'Cat Food 01 x2',
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  right: metrics.quickButtonRight,
                  bottom: metrics.quickButtonBottom,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          metrics.quickButtonSize / 2,
                        ),
                      onTap: () {
                        setState(() {
                          _showQuickMenu = !_showQuickMenu;
                        });
                      },
                      child: Container(
                        width: metrics.quickButtonSize,
                        height: metrics.quickButtonSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF9A9A9A),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          _showQuickMenu
                              ? Icons.close_rounded
                              : Icons.menu_rounded,
                          size: metrics.quickIconSize,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: metrics.sidePadding,
                      right: metrics.sidePadding,
                      bottom: metrics.bottomNavBottomPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: math.min(metrics.maxContentWidth, 520),
                      ),
                      child: _ProductsBottomNav(
                        metrics: metrics,
                        onOpenPets: () => Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        ),
                        onOpenClinic: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.metrics,
    required this.controller,
    required this.onChanged,
  });

  final _ProductsMetrics metrics;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(metrics.searchOuterPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(metrics.searchRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.black,
            size: metrics.searchIconSize,
          ),
          SizedBox(width: metrics.searchGap),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Type to search',
                hintStyle: TextStyle(
                  fontSize: metrics.searchTextSize,
                  color: const Color(0xFF5E5E5E),
                ),
              ),
              style: TextStyle(
                fontSize: metrics.searchTextSize,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: metrics.searchGap),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.searchButtonHorizontalPadding,
              vertical: metrics.searchButtonVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD4D4D4),
              borderRadius: BorderRadius.circular(metrics.searchButtonRadius),
            ),
            child: Text(
              'Search',
              style: TextStyle(
                fontSize: metrics.searchButtonTextSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.metrics,
    required this.selectedCategory,
    required this.onSelected,
  });

  final _ProductsMetrics metrics;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _productCategories.map((category) {
        final isSelected = category == selectedCategory;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: category == _productCategories.last ? 0 : metrics.tabGap,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(metrics.tabRadius),
              onTap: () => onSelected(category),
              child: Container(
                height: metrics.tabHeight,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFFF6B73)
                      : Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(metrics.tabRadius),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: metrics.tabTextSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.metrics,
    required this.onTap,
  });

  final _ProductItem product;
  final _ProductsMetrics metrics;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(metrics.productCardRadius),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(metrics.productCardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(metrics.productCardRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(metrics.productImageRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: product.imageColors,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: metrics.packLeftInset,
                    right: metrics.packRightInset,
                    top: metrics.packTopInset,
                    bottom: metrics.packBottomInset,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(
                          metrics.packRadius,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x18000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Icon(
                        product.icon,
                        size: metrics.productGlyphSize,
                        color: product.iconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: metrics.productTextGap),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: metrics.productNameSize,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: metrics.priceGap),
          Text(
            '${product.price} MMK',
            style: TextStyle(
              fontSize: metrics.productPriceSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFF0000),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProductsState extends StatelessWidget {
  const _EmptyProductsState({required this.metrics});

  final _ProductsMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.emptyStateHorizontalPadding,
        vertical: metrics.emptyStateVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: metrics.emptyStateIconSize,
            color: const Color(0xFF688178),
          ),
          SizedBox(height: metrics.searchGap),
          Text(
            'No products matched your search.',
            style: TextStyle(
              fontSize: metrics.emptyStateTitleSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: metrics.priceGap),
          Text(
            'Try a different keyword or switch back to all products.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: metrics.helperTextSize,
              color: const Color(0xFF5E7067),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickMenu extends StatelessWidget {
  const _QuickMenu({
    required this.metrics,
    required this.onOrdersTap,
    required this.onCartTap,
  });

  final _ProductsMetrics metrics;
  final VoidCallback onOrdersTap;
  final VoidCallback onCartTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: metrics.quickMenuWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(metrics.quickMenuRadius),
        border: Border.all(color: const Color(0xFFBBBBBB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuickMenuItem(
            icon: Icons.fact_check_outlined,
            label: 'Orders',
            onTap: onOrdersTap,
          ),
          Divider(height: 1, color: Color(0xFFB9B9B9)),
          _QuickMenuItem(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            onTap: onCartTap,
          ),
        ],
      ),
    );
  }
}

class _QuickMenuItem extends StatelessWidget {
  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color: const Color(0xFF7A9890),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6C8C84),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsBottomNav extends StatelessWidget {
  const _ProductsBottomNav({
    required this.metrics,
    required this.onOpenPets,
    required this.onOpenClinic,
  });

  final _ProductsMetrics metrics;
  final VoidCallback onOpenPets;
  final VoidCallback onOpenClinic;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: metrics.bottomNavHeight,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onOpenPets,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                AvailableProductsPage._petsIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onOpenClinic,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                AvailableProductsPage._clinicIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          Expanded(
            child: Container(
              height: metrics.bottomNavSelectedHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AvailableProductsPage._basketIconAsset,
                    width: metrics.navSelectedIconSize,
                    height: metrics.navSelectedIconSize,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Products',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: metrics.bottomNavSelectedTextSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('products_nav_profile'),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                AvailableProductsPage._profileIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsMetrics {
  const _ProductsMetrics({
    required this.maxContentWidth,
    required this.sidePadding,
    required this.topPadding,
    required this.sectionGap,
    required this.titleSize,
    required this.backIconSize,
    required this.backIconSlotWidth,
    required this.searchOuterPadding,
    required this.searchRadius,
    required this.searchIconSize,
    required this.searchGap,
    required this.searchTextSize,
    required this.searchButtonHorizontalPadding,
    required this.searchButtonVerticalPadding,
    required this.searchButtonRadius,
    required this.searchButtonTextSize,
    required this.tabGap,
    required this.tabHeight,
    required this.tabRadius,
    required this.tabTextSize,
    required this.gridCrossAxisCount,
    required this.gridSpacing,
    required this.productCardHeight,
    required this.productCardPadding,
    required this.productCardRadius,
    required this.productImageRadius,
    required this.packLeftInset,
    required this.packRightInset,
    required this.packTopInset,
    required this.packBottomInset,
    required this.packRadius,
    required this.productGlyphSize,
    required this.productTextGap,
    required this.productNameSize,
    required this.priceGap,
    required this.productPriceSize,
    required this.quickButtonSize,
    required this.quickIconSize,
    required this.quickButtonRight,
    required this.quickButtonBottom,
    required this.quickMenuWidth,
    required this.quickMenuRadius,
    required this.quickMenuRight,
    required this.quickMenuBottom,
    required this.bottomNavHeight,
    required this.bottomNavSelectedHeight,
    required this.bottomNavSelectedTextSize,
    required this.bottomNavBottomPadding,
    required this.bottomDockSpacing,
    required this.navIconGap,
    required this.navIconSize,
    required this.navSelectedIconSize,
    required this.helperTextSize,
    required this.emptyStateHorizontalPadding,
    required this.emptyStateVerticalPadding,
    required this.emptyStateIconSize,
    required this.emptyStateTitleSize,
  });

  final double maxContentWidth;
  final double sidePadding;
  final double topPadding;
  final double sectionGap;
  final double titleSize;
  final double backIconSize;
  final double backIconSlotWidth;
  final double searchOuterPadding;
  final double searchRadius;
  final double searchIconSize;
  final double searchGap;
  final double searchTextSize;
  final double searchButtonHorizontalPadding;
  final double searchButtonVerticalPadding;
  final double searchButtonRadius;
  final double searchButtonTextSize;
  final double tabGap;
  final double tabHeight;
  final double tabRadius;
  final double tabTextSize;
  final int gridCrossAxisCount;
  final double gridSpacing;
  final double productCardHeight;
  final double productCardPadding;
  final double productCardRadius;
  final double productImageRadius;
  final double packLeftInset;
  final double packRightInset;
  final double packTopInset;
  final double packBottomInset;
  final double packRadius;
  final double productGlyphSize;
  final double productTextGap;
  final double productNameSize;
  final double priceGap;
  final double productPriceSize;
  final double quickButtonSize;
  final double quickIconSize;
  final double quickButtonRight;
  final double quickButtonBottom;
  final double quickMenuWidth;
  final double quickMenuRadius;
  final double quickMenuRight;
  final double quickMenuBottom;
  final double bottomNavHeight;
  final double bottomNavSelectedHeight;
  final double bottomNavSelectedTextSize;
  final double bottomNavBottomPadding;
  final double bottomDockSpacing;
  final double navIconGap;
  final double navIconSize;
  final double navSelectedIconSize;
  final double helperTextSize;
  final double emptyStateHorizontalPadding;
  final double emptyStateVerticalPadding;
  final double emptyStateIconSize;
  final double emptyStateTitleSize;

  static _ProductsMetrics fromSize(Size size) {
    final width = size.width;
    final height = size.height;
    final shortest = math.min(width, height);
    final isTablet = width >= 700;
    final isDesktop = width >= 1000;

    return _ProductsMetrics(
      maxContentWidth: isDesktop ? 760 : 620,
      sidePadding: isDesktop ? 30 : (isTablet ? 24 : 18),
      topPadding: height < 700 ? 8 : 18,
      sectionGap: shortest < 390 ? 16 : 24,
      titleSize: isDesktop ? 34 : (shortest < 390 ? 24 : 30),
      backIconSize: shortest < 390 ? 24 : 28,
      backIconSlotWidth: shortest < 390 ? 32 : 48,
      searchOuterPadding: shortest < 390 ? 6 : 8,
      searchRadius: 24,
      searchIconSize: shortest < 390 ? 22 : 26,
      searchGap: shortest < 390 ? 10 : 12,
      searchTextSize: shortest < 390 ? 16 : 18,
      searchButtonHorizontalPadding: shortest < 390 ? 16 : 28,
      searchButtonVerticalPadding: shortest < 390 ? 8 : 10,
      searchButtonRadius: 18,
      searchButtonTextSize: shortest < 390 ? 16 : 18,
      tabGap: shortest < 390 ? 10 : 14,
      tabHeight: shortest < 390 ? 60 : 72,
      tabRadius: 24,
      tabTextSize: shortest < 390 ? 18 : 22,
      gridCrossAxisCount: width >= 880 ? 3 : 2,
      gridSpacing: shortest < 390 ? 14 : 18,
      productCardHeight: shortest < 390 ? 260 : 310,
      productCardPadding: shortest < 390 ? 12 : 14,
      productCardRadius: 16,
      productImageRadius: 20,
      packLeftInset: shortest < 390 ? 18 : 24,
      packRightInset: shortest < 390 ? 18 : 24,
      packTopInset: shortest < 390 ? 16 : 20,
      packBottomInset: shortest < 390 ? 26 : 30,
      packRadius: 26,
      productGlyphSize: shortest < 390 ? 58 : 74,
      productTextGap: shortest < 390 ? 10 : 14,
      productNameSize: shortest < 390 ? 16 : 18,
      priceGap: shortest < 390 ? 4 : 6,
      productPriceSize: shortest < 390 ? 14 : 16,
      quickButtonSize: shortest < 390 ? 92 : 124,
      quickIconSize: shortest < 390 ? 52 : 64,
      quickButtonRight: shortest < 390 ? 10 : 16,
      quickButtonBottom: shortest < 390 ? 102 : 120,
      quickMenuWidth: shortest < 390 ? 170 : 220,
      quickMenuRadius: 100,
      quickMenuRight: shortest < 390 ? -22 : -30,
      quickMenuBottom: shortest < 390 ? 136 : 160,
      bottomNavHeight: shortest < 390 ? 76 : 84,
      bottomNavSelectedHeight: shortest < 390 ? 50 : 56,
      bottomNavSelectedTextSize: shortest < 390 ? 16 : 18,
      bottomNavBottomPadding: shortest < 390 ? 10 : 14,
      bottomDockSpacing: shortest < 390 ? 18 : 24,
      navIconGap: shortest < 390 ? 12 : 16,
      navIconSize: shortest < 390 ? 32 : 36,
      navSelectedIconSize: shortest < 390 ? 28 : 32,
      helperTextSize: shortest < 390 ? 14 : 15,
      emptyStateHorizontalPadding: shortest < 390 ? 18 : 26,
      emptyStateVerticalPadding: shortest < 390 ? 24 : 30,
      emptyStateIconSize: shortest < 390 ? 42 : 52,
      emptyStateTitleSize: shortest < 390 ? 18 : 20,
    );
  }
}

class _ProductItem {
  const _ProductItem({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.imageColors,
  });

  final String name;
  final int price;
  final String category;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<Color> imageColors;
}

const _productCategories = [
  'All Product',
  'Food',
];

const _products = [
  _ProductItem(
    name: 'Dog Food 01',
    price: 4000,
    category: 'Food',
    description: 'Balanced daily food for adult dogs with a familiar flavor and easy portion size.',
    icon: Icons.pets_rounded,
    iconColor: Color(0xFFD7A100),
    imageColors: [Color(0xFFF8D74A), Color(0xFFF2B61E)],
  ),
  _ProductItem(
    name: 'Cat Food 01',
    price: 4000,
    category: 'Food',
    description: 'Crunchy cat food option for indoor and active cats with everyday nutrition support.',
    icon: Icons.pets_outlined,
    iconColor: Color(0xFF8C5AC8),
    imageColors: [Color(0xFFF6D34D), Color(0xFFC99AF8)],
  ),
  _ProductItem(
    name: 'Rabbit Food 01',
    price: 4000,
    category: 'Food',
    description: 'Pellet-style rabbit food with plant-based ingredients for routine feeding.',
    icon: Icons.eco_outlined,
    iconColor: Color(0xFF649846),
    imageColors: [Color(0xFFC6F0B5), Color(0xFF8AB971)],
  ),
  _ProductItem(
    name: 'Dog Food 02',
    price: 6000,
    category: 'Food',
    description: 'Larger pack size for multi-pet homes or longer feeding cycles.',
    icon: Icons.shopping_bag_outlined,
    iconColor: Color(0xFFD69A2E),
    imageColors: [Color(0xFFF5D788), Color(0xFFE8AA59)],
  ),
  _ProductItem(
    name: 'Dog Food 03',
    price: 4500,
    category: 'Food',
    description: 'Affordable everyday dog food for owners who need a quick clinic pickup.',
    icon: Icons.inventory_2_outlined,
    iconColor: Color(0xFFD9B61B),
    imageColors: [Color(0xFFF9E440), Color(0xFFCBE26A)],
  ),
  _ProductItem(
    name: 'Cat Food 02',
    price: 4200,
    category: 'Food',
    description: 'Wet-style meal option for cats that prefer softer textures and smaller portions.',
    icon: Icons.lunch_dining_outlined,
    iconColor: Color(0xFF8C755A),
    imageColors: [Color(0xFFE9E3D8), Color(0xFFC3B5A1)],
  ),
];
