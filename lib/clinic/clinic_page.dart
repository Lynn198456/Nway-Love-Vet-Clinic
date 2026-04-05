import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nway_love_vet_clinic/profile/profile_page.dart';
import 'package:nway_love_vet_clinic/products/available_products_page.dart';
import 'package:nway_love_vet_clinic/shared/feature_info_page.dart';

class ClinicPage extends StatelessWidget {
  const ClinicPage({super.key});

  static const _logoAsset =
      'Image/96834706b12cc7705f84b57428816f66b3983359.png';
  static const _petsAsset = 'Image/image 4.png';
  static const _petsIconAsset = 'icons/IMG_5276.png';
  static const _clinicIconAsset =
      'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';
  static const _basketIconAsset =
      'icons/8f867c18-75ec-4219-91c8-9d4f26c50e51.png';
  static const _profileIconAsset =
      'icons/4104c0eb-80f2-4722-8cfc-1148a0291965.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFC5B8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _ClinicMetrics.fromSize(constraints.biggest);

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF6F6F2),
                          Color(0xFFF1F4EE),
                          Color(0xFFAFC5B8),
                          Color(0xFFAFC5B8),
                        ],
                        stops: [0, 0.18, 0.18, 1],
                      ),
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
                                Image.asset(
                                  _logoAsset,
                                  width: metrics.logoSize,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: metrics.sectionGap),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: metrics.helperHorizontalPadding,
                                    vertical: metrics.helperVerticalPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.74),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: Text(
                                    'Find clinic details, doctor info, and the fastest service option for your visit.',
                                    style: TextStyle(
                                      fontSize: metrics.helperTextSize,
                                      color: const Color(0xFF3F564B),
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _ClinicHero(metrics: metrics, petsAsset: _petsAsset),
                                SizedBox(height: metrics.sectionGap),
                                Text(
                                  'Doctor Profiles',
                                  style: TextStyle(
                                    fontSize: metrics.sectionTitleSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: metrics.cardGap),
                                _DoctorProfiles(metrics: metrics),
                                SizedBox(height: metrics.sectionGap),
                                Text(
                                  'Categories',
                                  style: TextStyle(
                                    fontSize: metrics.sectionTitleSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: metrics.cardGap),
                                _CategoryList(
                                  metrics: metrics,
                                  onSelected: (category) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => FeatureInfoPage(
                                          title: category.label.replaceAll('\n', ' '),
                                          icon: category.icon,
                                          accentColor: const Color(0xFFAFC5B8),
                                          primaryActionLabel: category.actionLabel,
                                          sections: [
                                            FeatureInfoSection(
                                              heading: 'Overview',
                                              items: [
                                                category.description,
                                                category.details,
                                              ],
                                            ),
                                            FeatureInfoSection(
                                              heading: 'How It Helps',
                                              items: category.benefits,
                                            ),
                                          ],
                                        ),
                                      ),
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
                      child: _ClinicBottomNav(
                        metrics: metrics,
                        petsIconAsset: _petsIconAsset,
                        clinicIconAsset: _clinicIconAsset,
                        basketIconAsset: _basketIconAsset,
                        profileIconAsset: _profileIconAsset,
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

class _ClinicHero extends StatelessWidget {
  const _ClinicHero({
    required this.metrics,
    required this.petsAsset,
  });

  final _ClinicMetrics metrics;
  final String petsAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(metrics.heroRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: metrics.heroImageHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF708A79),
                  Color(0xFF9CB5A6),
                  Color(0xFFC8D7CE),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.08),
                          Colors.black.withValues(alpha: 0.22),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.94,
                    child: Image.asset(
                      petsAsset,
                      width: metrics.heroPetsWidth,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  left: metrics.heroContentPadding,
                  right: metrics.heroContentPadding,
                  bottom: metrics.heroContentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nway Myit Tar',
                        style: TextStyle(
                          fontSize: metrics.heroTitleSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: metrics.heroTextGap),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: metrics.heroTextWidth,
                        ),
                        child: Text(
                          'Vet Clinic, Pet Spa & Accessories',
                          style: TextStyle(
                            fontSize: metrics.heroSubtitleSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.08,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(metrics.infoPadding),
            child: Column(
              children: [
                _ClinicInfoRow(
                  metrics: metrics,
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFFD92017),
                  label: 'Address',
                  value:
                      'Chindwin street, Mingalardipa quarter, Pobba Thiri Township, Nay Pyi Taw',
                ),
                SizedBox(height: metrics.infoGap),
                _ClinicInfoRow(
                  metrics: metrics,
                  icon: Icons.phone_rounded,
                  iconColor: const Color(0xFF1A95B8),
                  label: 'Phone',
                  value: '09-5312717, 09-965805940',
                ),
                SizedBox(height: metrics.infoGap),
                _ClinicInfoRow(
                  metrics: metrics,
                  icon: Icons.access_time_filled_rounded,
                  iconColor: const Color(0xFFFF6C0A),
                  label: 'Clinic Hours',
                  value: '9AM - 12PM\n4PM - 7PM',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicInfoRow extends StatelessWidget {
  const _ClinicInfoRow({
    required this.metrics,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final _ClinicMetrics metrics;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: metrics.infoIconSize,
          height: metrics.infoIconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.24),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: metrics.infoGlyphSize,
          ),
        ),
        SizedBox(width: metrics.infoRowGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: metrics.infoLabelSize,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: metrics.heroTextGap),
              Text(
                value,
                style: TextStyle(
                  fontSize: metrics.infoValueSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DoctorProfiles extends StatelessWidget {
  const _DoctorProfiles({required this.metrics});

  final _ClinicMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.doctorCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _doctorProfiles.length,
        separatorBuilder: (context, index) => SizedBox(width: metrics.cardGap),
        itemBuilder: (context, index) {
          final doctor = _doctorProfiles[index];
          return Container(
            width: metrics.doctorCardWidth,
            padding: EdgeInsets.all(metrics.doctorCardPadding),
            decoration: BoxDecoration(
              color: const Color(0xFFD9E5DF),
              borderRadius: BorderRadius.circular(metrics.doctorCardRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.74),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        doctor.initials,
                        style: TextStyle(
                          fontSize: metrics.doctorInitialSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5E7067),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: metrics.doctorTextGap),
                Text(
                  doctor.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: metrics.doctorNameSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: metrics.heroTextGap),
                Text(
                  doctor.qualification,
                  style: TextStyle(
                    fontSize: metrics.doctorMetaSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3E5349),
                  ),
                ),
                SizedBox(height: metrics.heroTextGap),
                Text(
                  doctor.specialty,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: metrics.doctorSpecialtySize,
                    color: const Color(0xFF5E7067),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.metrics,
    required this.onSelected,
  });

  final _ClinicMetrics metrics;
  final ValueChanged<_ClinicCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.categorySectionHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => SizedBox(width: metrics.categoryGap),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return SizedBox(
            width: metrics.categoryItemWidth,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => onSelected(category),
              child: Column(
                children: [
                  Container(
                    width: metrics.categoryCircleSize,
                    height: metrics.categoryCircleSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6FF),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      category.icon,
                      size: metrics.categoryIconSize,
                      color: const Color(0xFF111111),
                    ),
                  ),
                  SizedBox(height: metrics.categoryLabelGap),
                  Text(
                    category.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: metrics.categoryLabelSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF26332D),
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: metrics.heroTextGap),
                  Text(
                    category.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: metrics.categoryDescriptionSize,
                      color: const Color(0xFF50625A),
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ClinicBottomNav extends StatelessWidget {
  const _ClinicBottomNav({
    required this.metrics,
    required this.petsIconAsset,
    required this.clinicIconAsset,
    required this.basketIconAsset,
    required this.profileIconAsset,
  });

  final _ClinicMetrics metrics;
  final String petsIconAsset;
  final String clinicIconAsset;
  final String basketIconAsset;
  final String profileIconAsset;

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
            key: const Key('clinic_nav_my_pets'),
            borderRadius: BorderRadius.circular(22),
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                petsIconAsset,
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
                    clinicIconAsset,
                    width: metrics.navSelectedIconSize,
                    height: metrics.navSelectedIconSize,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Clinic',
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
            key: const Key('clinic_nav_products'),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AvailableProductsPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                basketIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('clinic_nav_profile'),
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
                profileIconAsset,
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

class _ClinicMetrics {
  const _ClinicMetrics({
    required this.maxContentWidth,
    required this.sidePadding,
    required this.topPadding,
    required this.sectionGap,
    required this.cardGap,
    required this.logoSize,
    required this.heroRadius,
    required this.heroImageHeight,
    required this.heroPetsWidth,
    required this.heroContentPadding,
    required this.heroTitleSize,
    required this.heroSubtitleSize,
    required this.heroTextGap,
    required this.heroTextWidth,
    required this.infoPadding,
    required this.infoGap,
    required this.infoIconSize,
    required this.infoGlyphSize,
    required this.infoRowGap,
    required this.infoLabelSize,
    required this.infoValueSize,
    required this.sectionTitleSize,
    required this.doctorCardWidth,
    required this.doctorCardHeight,
    required this.doctorCardPadding,
    required this.doctorCardRadius,
    required this.doctorPhotoHeight,
    required this.doctorInitialSize,
    required this.doctorTextGap,
    required this.doctorNameSize,
    required this.doctorMetaSize,
    required this.categorySectionHeight,
    required this.categoryItemWidth,
    required this.categoryCircleSize,
    required this.categoryIconSize,
    required this.categoryGap,
    required this.categoryLabelGap,
    required this.categoryLabelSize,
    required this.bottomNavHeight,
    required this.bottomNavSelectedHeight,
    required this.bottomNavSelectedTextSize,
    required this.bottomNavBottomPadding,
    required this.bottomDockSpacing,
    required this.navIconGap,
    required this.navIconSize,
    required this.navSelectedIconSize,
    required this.helperHorizontalPadding,
    required this.helperVerticalPadding,
    required this.helperTextSize,
    required this.doctorSpecialtySize,
    required this.categoryDescriptionSize,
  });

  final double maxContentWidth;
  final double sidePadding;
  final double topPadding;
  final double sectionGap;
  final double cardGap;
  final double logoSize;
  final double heroRadius;
  final double heroImageHeight;
  final double heroPetsWidth;
  final double heroContentPadding;
  final double heroTitleSize;
  final double heroSubtitleSize;
  final double heroTextGap;
  final double heroTextWidth;
  final double infoPadding;
  final double infoGap;
  final double infoIconSize;
  final double infoGlyphSize;
  final double infoRowGap;
  final double infoLabelSize;
  final double infoValueSize;
  final double sectionTitleSize;
  final double doctorCardWidth;
  final double doctorCardHeight;
  final double doctorCardPadding;
  final double doctorCardRadius;
  final double doctorPhotoHeight;
  final double doctorInitialSize;
  final double doctorTextGap;
  final double doctorNameSize;
  final double doctorMetaSize;
  final double categorySectionHeight;
  final double categoryItemWidth;
  final double categoryCircleSize;
  final double categoryIconSize;
  final double categoryGap;
  final double categoryLabelGap;
  final double categoryLabelSize;
  final double bottomNavHeight;
  final double bottomNavSelectedHeight;
  final double bottomNavSelectedTextSize;
  final double bottomNavBottomPadding;
  final double bottomDockSpacing;
  final double navIconGap;
  final double navIconSize;
  final double navSelectedIconSize;
  final double helperHorizontalPadding;
  final double helperVerticalPadding;
  final double helperTextSize;
  final double doctorSpecialtySize;
  final double categoryDescriptionSize;

  static _ClinicMetrics fromSize(Size size) {
    final width = size.width;
    final height = size.height;
    final shortest = math.min(width, height);
    final isTablet = width >= 700;
    final isDesktop = width >= 1000;

    return _ClinicMetrics(
      maxContentWidth: isDesktop ? 760 : 620,
      sidePadding: isDesktop ? 28 : (isTablet ? 24 : 18),
      topPadding: height < 700 ? 10 : 18,
      sectionGap: shortest < 390 ? 22 : 30,
      cardGap: shortest < 390 ? 14 : 18,
      logoSize: isDesktop ? 108 : (isTablet ? 96 : 84),
      heroRadius: 34,
      heroImageHeight: isDesktop ? 360 : (isTablet ? 320 : 280),
      heroPetsWidth: isDesktop ? 320 : (isTablet ? 280 : 220),
      heroContentPadding: shortest < 390 ? 18 : 24,
      heroTitleSize: isDesktop ? 30 : (shortest < 390 ? 22 : 26),
      heroSubtitleSize: isDesktop ? 24 : (shortest < 390 ? 16 : 20),
      heroTextGap: shortest < 390 ? 4 : 6,
      heroTextWidth: isDesktop ? 440 : (isTablet ? 380 : 240),
      infoPadding: shortest < 390 ? 18 : 22,
      infoGap: shortest < 390 ? 18 : 20,
      infoIconSize: shortest < 390 ? 38 : 44,
      infoGlyphSize: shortest < 390 ? 24 : 28,
      infoRowGap: shortest < 390 ? 12 : 14,
      infoLabelSize: shortest < 390 ? 14 : 16,
      infoValueSize: isDesktop ? 24 : (shortest < 390 ? 16 : 18),
      sectionTitleSize: isDesktop ? 32 : (shortest < 390 ? 24 : 28),
      doctorCardWidth: isDesktop ? 260 : (isTablet ? 230 : 180),
      doctorCardHeight: isDesktop ? 340 : (isTablet ? 308 : 250),
      doctorCardPadding: shortest < 390 ? 14 : 16,
      doctorCardRadius: 24,
      doctorPhotoHeight: isDesktop ? 210 : (isTablet ? 190 : 150),
      doctorInitialSize: isDesktop ? 54 : (shortest < 390 ? 36 : 44),
      doctorTextGap: shortest < 390 ? 12 : 16,
      doctorNameSize: isDesktop ? 24 : (shortest < 390 ? 18 : 20),
      doctorMetaSize: shortest < 390 ? 14 : 15,
      categorySectionHeight: shortest < 390 ? 196 : 226,
      categoryItemWidth: shortest < 390 ? 102 : 114,
      categoryCircleSize: shortest < 390 ? 82 : 96,
      categoryIconSize: shortest < 390 ? 32 : 38,
      categoryGap: shortest < 390 ? 14 : 18,
      categoryLabelGap: shortest < 390 ? 10 : 12,
      categoryLabelSize: shortest < 390 ? 14 : 16,
      bottomNavHeight: shortest < 390 ? 76 : 84,
      bottomNavSelectedHeight: shortest < 390 ? 50 : 56,
      bottomNavSelectedTextSize: shortest < 390 ? 16 : 18,
      bottomNavBottomPadding: shortest < 390 ? 10 : 14,
      bottomDockSpacing: shortest < 390 ? 18 : 24,
      navIconGap: shortest < 390 ? 12 : 16,
      navIconSize: shortest < 390 ? 32 : 36,
      navSelectedIconSize: shortest < 390 ? 28 : 32,
      helperHorizontalPadding: shortest < 390 ? 14 : 18,
      helperVerticalPadding: shortest < 390 ? 12 : 14,
      helperTextSize: shortest < 390 ? 14 : 15,
      doctorSpecialtySize: shortest < 390 ? 13 : 14,
      categoryDescriptionSize: shortest < 390 ? 12 : 13,
    );
  }
}

class _DoctorProfile {
  const _DoctorProfile({
    required this.name,
    required this.qualification,
    required this.initials,
    required this.specialty,
  });

  final String name;
  final String qualification;
  final String initials;
  final String specialty;
}

class _ClinicCategory {
  const _ClinicCategory({
    required this.label,
    required this.icon,
    required this.description,
    required this.details,
    required this.actionLabel,
    required this.benefits,
  });

  final String label;
  final IconData icon;
  final String description;
  final String details;
  final String actionLabel;
  final List<String> benefits;
}

const _doctorProfiles = [
  _DoctorProfile(
    name: 'Dr. Hnin Thiri Aung',
    qualification: 'B.V.Sc',
    initials: 'HA',
    specialty: 'Routine checkups, vaccinations, and family pet care.',
  ),
  _DoctorProfile(
    name: 'Dr. Mu Mu',
    qualification: 'Senior Veterinarian',
    initials: 'MM',
    specialty: 'Wellness visits, consultation, and treatment follow-up.',
  ),
];

const _categories = [
  _ClinicCategory(
    label: 'Booking',
    icon: Icons.calendar_month_outlined,
    description: 'Book your next clinic visit.',
    details: 'Choose a convenient day for checkups, follow-up care, or vaccinations.',
    actionLabel: 'Start Booking',
    benefits: [
      'Pick a suitable visit type for your pet.',
      'Plan ahead with enough time for records and reminders.',
    ],
  ),
  _ClinicCategory(
    label: 'Queue',
    icon: Icons.people_outline_rounded,
    description: 'Check waiting flow before arrival.',
    details: 'See the current queue flow and plan the best time to come to the clinic.',
    actionLabel: 'View Queue Tips',
    benefits: [
      'Avoid busier hours when possible.',
      'Make arrivals smoother for both owner and pet.',
    ],
  ),
  _ClinicCategory(
    label: 'Home Visit',
    icon: Icons.home_work_outlined,
    description: 'Arrange care at home when needed.',
    details: 'Request support for pets that are recovering, elderly, or difficult to transport.',
    actionLabel: 'Request Home Visit',
    benefits: [
      'Helpful for pets with limited mobility.',
      'Lets owners arrange care without stressful travel.',
    ],
  ),
  _ClinicCategory(
    label: 'Medical\nServices',
    icon: Icons.medical_services_outlined,
    description: 'Treatments, exams, and consultation.',
    details: 'Review the main clinic services available for wellness visits and urgent concerns.',
    actionLabel: 'Browse Services',
    benefits: [
      'Makes it easier to choose the right type of visit.',
      'Gives owners a clearer idea of clinic support options.',
    ],
  ),
  _ClinicCategory(
    label: 'Pet\nSupplies',
    icon: Icons.pets_outlined,
    description: 'Food, accessories, and essentials.',
    details: 'Shop for food, grooming basics, and everyday pet accessories in the products area.',
    actionLabel: 'Open Products',
    benefits: [
      'Quick access to pet essentials after appointments.',
      'Convenient refills for food and common supplies.',
    ],
  ),
];
