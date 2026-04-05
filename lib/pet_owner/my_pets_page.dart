import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nway_love_vet_clinic/clinic/clinic_page.dart';
import 'package:nway_love_vet_clinic/pet_owner/pet_detail_page.dart';
import 'package:nway_love_vet_clinic/profile/profile_page.dart';
import 'package:nway_love_vet_clinic/products/available_products_page.dart';

class MyPetsPage extends StatelessWidget {
  const MyPetsPage({super.key});

  static const _logoAsset =
      'Image/96834706b12cc7705f84b57428816f66b3983359.png';
  static const _dogAsset =
      'Image/12396e8a05092734d78448217d85a89baea8b970.png';
  static const _petsAsset = 'Image/image 4.png';
  static const _petsIconAsset = 'icons/IMG_5276.png';
  static const _addIconAsset = 'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';
  static const _basketIconAsset =
      'icons/8f867c18-75ec-4219-91c8-9d4f26c50e51.png';
  static const _profileIconAsset =
      'icons/4104c0eb-80f2-4722-8cfc-1148a0291965.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _OwnerMetrics.fromSize(constraints.biggest);

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          const Color(0xFFF7F5EF),
                        ],
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
                                _Header(metrics: metrics, logoAsset: _logoAsset),
                                SizedBox(height: metrics.sectionGap),
                                Text(
                                  'My Pets',
                                  style: TextStyle(
                                    fontSize: metrics.headingSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: metrics.cardGap),
                                _PetCarousel(
                                  metrics: metrics,
                                  dogAsset: _dogAsset,
                                  petsAsset: _petsAsset,
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SectionTitle(
                                  title: 'Reminders',
                                  fontSize: metrics.headingSize,
                                ),
                                SizedBox(height: metrics.cardGap),
                                ..._reminders.map(
                                  (reminder) => Padding(
                                    padding: EdgeInsets.only(bottom: metrics.listGap),
                                    child: _InfoCard(
                                      text: reminder,
                                      metrics: metrics,
                                    ),
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap * 0.7),
                                _SectionTitle(
                                  title: 'Appointments',
                                  fontSize: metrics.headingSize,
                                ),
                                SizedBox(height: metrics.cardGap),
                                _InfoCard(
                                  text:
                                      'Max has a vet appointment tomorrow at 10:00 AM. Please arrive 10 minutes early for check-in.',
                                  metrics: metrics,
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
                      child: _BottomNav(
                        metrics: metrics,
                        petsIconAsset: _petsIconAsset,
                        addIconAsset: _addIconAsset,
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

class _Header extends StatelessWidget {
  const _Header({required this.metrics, required this.logoAsset});

  final _OwnerMetrics metrics;
  final String logoAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          logoAsset,
          width: metrics.logoSize,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        Container(
          width: metrics.profileSize,
          height: metrics.profileSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF243AC7), width: 1.5),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF3F1EA), Color(0xFFDAD4CB)],
            ),
          ),
          child: ClipOval(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Color(0xFFF4F1EC)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: -8,
                    child: Container(
                      width: metrics.profileSize * 0.58,
                      height: metrics.profileSize * 0.48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7DDD1),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.person_rounded,
                    size: metrics.profileSize * 0.62,
                    color: const Color(0xFF7C6C63),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PetCarousel extends StatelessWidget {
  const _PetCarousel({
    required this.metrics,
    required this.dogAsset,
    required this.petsAsset,
  });

  final _OwnerMetrics metrics;
  final String dogAsset;
  final String petsAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: metrics.petCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _pets.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: metrics.cardGap),
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return _PetCard(
            pet: pet,
            metrics: metrics,
          );
        },
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.pet,
    required this.metrics,
  });

  final PetProfile pet;
  final _OwnerMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(metrics.petCardRadius),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => PetDetailPage(pet: pet),
          ),
        );
      },
      child: Container(
      width: metrics.petCardWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(metrics.petCardRadius),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: pet.imageAsset != null
                ? Image.asset(pet.imageAsset!, fit: BoxFit.cover)
                : DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFDCC4A8),
                          Color(0xFFF3EFE8),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.pets_rounded,
                        size: 68,
                        color: Color(0xFF8E785D),
                      ),
                    ),
                  ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                pet.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: metrics.petNameSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.fontSize});

  final String title;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text, required this.metrics});

  final String text;
  final _OwnerMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.infoCardPadding,
        vertical: metrics.infoCardVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F1),
        borderRadius: BorderRadius.circular(metrics.infoCardRadius),
      ),
      child: Text(
        '"$text"',
        style: TextStyle(
          fontSize: metrics.bodyTextSize,
          height: 1.28,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.metrics,
    required this.petsIconAsset,
    required this.addIconAsset,
    required this.basketIconAsset,
    required this.profileIconAsset,
  });

  final _OwnerMetrics metrics;
  final String petsIconAsset;
  final String addIconAsset;
  final String basketIconAsset;
  final String profileIconAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: metrics.bottomNavHeight,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: metrics.bottomNavSelectedHeight,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    petsIconAsset,
                    width: metrics.navSelectedIconSize,
                    height: metrics.navSelectedIconSize,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'My Pets',
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
            key: const Key('pets_nav_clinic'),
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ClinicPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                addIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('pets_nav_products'),
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AvailableProductsPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                basketIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('pets_nav_profile'),
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfilePage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(2),
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

class _OwnerMetrics {
  const _OwnerMetrics({
    required this.maxContentWidth,
    required this.sidePadding,
    required this.topPadding,
    required this.sectionGap,
    required this.cardGap,
    required this.listGap,
    required this.logoSize,
    required this.profileSize,
    required this.headingSize,
    required this.petCardWidth,
    required this.petCardHeight,
    required this.petCardRadius,
    required this.petNameSize,
    required this.bodyTextSize,
    required this.infoCardPadding,
    required this.infoCardVerticalPadding,
    required this.infoCardRadius,
    required this.bottomNavHeight,
    required this.bottomNavSelectedHeight,
    required this.bottomNavSelectedTextSize,
    required this.bottomNavBottomPadding,
    required this.bottomDockSpacing,
    required this.navIconGap,
    required this.navIconSize,
    required this.navSelectedIconSize,
  });

  final double maxContentWidth;
  final double sidePadding;
  final double topPadding;
  final double sectionGap;
  final double cardGap;
  final double listGap;
  final double logoSize;
  final double profileSize;
  final double headingSize;
  final double petCardWidth;
  final double petCardHeight;
  final double petCardRadius;
  final double petNameSize;
  final double bodyTextSize;
  final double infoCardPadding;
  final double infoCardVerticalPadding;
  final double infoCardRadius;
  final double bottomNavHeight;
  final double bottomNavSelectedHeight;
  final double bottomNavSelectedTextSize;
  final double bottomNavBottomPadding;
  final double bottomDockSpacing;
  final double navIconGap;
  final double navIconSize;
  final double navSelectedIconSize;

  static _OwnerMetrics fromSize(Size size) {
    final width = size.width;
    final height = size.height;
    final shortest = math.min(width, height);
    final isTablet = width >= 700;
    final isDesktop = width >= 1000;

    return _OwnerMetrics(
      maxContentWidth: isDesktop ? 700 : 560,
      sidePadding: isDesktop ? 28 : (isTablet ? 24 : 18),
      topPadding: height < 700 ? 10 : 18,
      sectionGap: shortest < 390 ? 22 : 30,
      cardGap: shortest < 390 ? 12 : 16,
      listGap: shortest < 390 ? 12 : 14,
      logoSize: isDesktop ? 110 : (isTablet ? 96 : 86),
      profileSize: isDesktop ? 96 : (isTablet ? 88 : 80),
      headingSize: isDesktop ? 36 : (shortest < 390 ? 28 : 32),
      petCardWidth: isDesktop ? 210 : (isTablet ? 190 : 170),
      petCardHeight: isDesktop ? 260 : (isTablet ? 235 : 210),
      petCardRadius: 30,
      petNameSize: shortest < 390 ? 18 : 21,
      bodyTextSize: isDesktop ? 22 : (shortest < 390 ? 16 : 19),
      infoCardPadding: shortest < 390 ? 16 : 22,
      infoCardVerticalPadding: shortest < 390 ? 16 : 20,
      infoCardRadius: 24,
      bottomNavHeight: shortest < 390 ? 76 : 84,
      bottomNavSelectedHeight: shortest < 390 ? 50 : 56,
      bottomNavSelectedTextSize: shortest < 390 ? 16 : 18,
      bottomNavBottomPadding: shortest < 390 ? 10 : 14,
      bottomDockSpacing: shortest < 390 ? 18 : 24,
      navIconGap: shortest < 390 ? 12 : 16,
      navIconSize: shortest < 390 ? 32 : 36,
      navSelectedIconSize: shortest < 390 ? 28 : 32,
    );
  }
}

const _pets = [
  PetProfile(
    name: 'Max',
    breed: 'Mixed Breed',
    species: 'Dog',
    sex: 'Male',
    weight: '8.4 kg',
    vaccinationHistory:
        'Completed core puppy vaccines, anti-rabies shot, and annual booster in October 2025.',
    upcomingVaccinationSchedule:
        'Next booster due on April 12, 2026. Deworming follow-up is scheduled for May 2026.',
    allergies: 'Sensitive to chicken-based food and dusty environments.',
    appointmentHistory:
        'Past visits\nDoctor name: Dr. May\nDate & time: March 15, 2026 at 9:30 AM\nReason: Skin irritation follow-up\nStatus: Completed',
    treatmentRecords:
        'Diagnosis\nMild seasonal dermatitis\n\nTreatment details\nMedicated shampoo twice weekly\n\nPrescribed medicines\nOmega-3 supplement and antihistamine syrup\n\nDosage instructions\n5 ml after dinner for 7 days.',
  ),
  PetProfile(
    name: 'Bella',
    breed: 'Golden Retriever',
    species: 'Dog',
    sex: 'Female',
    weight: '26 kg',
    imageAsset: MyPetsPage._dogAsset,
    vaccinationHistory:
        'Fully vaccinated, including kennel cough vaccine and yearly anti-rabies dose in January 2026.',
    upcomingVaccinationSchedule:
        'Annual wellness exam and booster scheduled for January 18, 2027.',
    allergies: 'No known drug allergies.',
    appointmentHistory:
        'Past visits\nDoctor name: Dr. Hnin\nDate & time: February 2, 2026 at 11:00 AM\nReason: Routine checkup\nStatus: Completed',
    treatmentRecords:
        'Diagnosis\nHealthy adult dog\n\nTreatment details\nPreventive dental cleaning was recommended\n\nPrescribed medicines\nMonthly tick and flea preventive\n\nDosage instructions\nOne chewable tablet every 30 days.',
  ),
  PetProfile(
    name: 'Luna',
    breed: 'Persian Mix',
    species: 'Cat',
    sex: 'Female',
    weight: '4.1 kg',
    imageAsset: MyPetsPage._petsAsset,
    vaccinationHistory:
        'Received FVRCP series and anti-rabies vaccine. Last booster completed in December 2025.',
    upcomingVaccinationSchedule:
        'Next wellness check is due in June 2026 with vaccination review.',
    allergies: 'Mild flea-bite allergy reported during rainy season.',
    appointmentHistory:
        'Past visits\nDoctor name: Dr. Su\nDate & time: March 8, 2026 at 2:00 PM\nReason: Grooming-related stress and appetite check\nStatus: Completed',
    treatmentRecords:
        'Diagnosis\nTemporary appetite drop after grooming stress\n\nTreatment details\nObservation and hydration support\n\nPrescribed medicines\nAppetite support gel\n\nDosage instructions\nApply 2 cm of gel twice daily for 3 days.',
  ),
];

const _reminders = [
  'Time to give Max his medication at 8:00 AM. Don\'t forget his morning dose to keep him healthy and active.',
  'Max\'s vaccination is due this week. Schedule a visit to keep him protected.',
  'Feeding time for Max! Give him his meal at 6:00 PM.',
];
