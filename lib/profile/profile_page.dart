import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nway_love_vet_clinic/clinic/clinic_page.dart';
import 'package:nway_love_vet_clinic/pet_owner/my_pets_page.dart';
import 'package:nway_love_vet_clinic/products/available_products_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const _logoAsset =
      'Image/96834706b12cc7705f84b57428816f66b3983359.png';
  static const _petsIconAsset = 'icons/IMG_5276.png';
  static const _clinicIconAsset =
      'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';
  static const _basketIconAsset =
      'icons/8f867c18-75ec-4219-91c8-9d4f26c50e51.png';
  static const _profileIconAsset =
      'icons/4104c0eb-80f2-4722-8cfc-1148a0291965.png';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  File? _selectedImageFile;

  Future<void> _pickProfilePhoto() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile == null || !mounted) {
      return;
    }

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageFile = null;
      });
      return;
    }

    setState(() {
      _selectedImageFile = File(pickedFile.path);
      _selectedImageBytes = null;
    });
  }

  ImageProvider? _profileImageProvider() {
    if (_selectedImageBytes != null) {
      return MemoryImage(_selectedImageBytes!);
    }
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    }
    return null;
  }

  void _showMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label feature is ready for the next step.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFC5B8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _ProfileMetrics.fromSize(constraints.biggest);

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xFFAFC5B8)),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Container(
                    height: metrics.headerHeight,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(320, 88),
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
                                  ProfilePage._logoAsset,
                                  width: metrics.logoSize,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _ProfileInfoCard(
                                  metrics: metrics,
                                  imageProvider: _profileImageProvider(),
                                  onPickImage: _pickProfilePhoto,
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SectionCard(
                                  metrics: metrics,
                                  title: 'Quick Actions',
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _QuickActionCard(
                                          metrics: metrics,
                                          icon: Icons.call_outlined,
                                          iconColor: const Color(0xFFF70012),
                                          label: 'Emergency',
                                          onTap: () => _showMessage('Emergency'),
                                        ),
                                      ),
                                      SizedBox(width: metrics.cardGap),
                                      Expanded(
                                        child: _QuickActionCard(
                                          metrics: metrics,
                                          icon: Icons.location_on_outlined,
                                          iconColor: const Color(0xFF4963D5),
                                          label: 'Location',
                                          onTap: () => _showMessage('Location'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SectionCard(
                                  metrics: metrics,
                                  title: 'My Pet',
                                  trailing: 'View All',
                                  child: Column(
                                    children: _profilePets
                                        .map(
                                          (pet) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: pet == _profilePets.last
                                                  ? 0
                                                  : metrics.cardGap,
                                            ),
                                            child: _PetSummaryCard(
                                              metrics: metrics,
                                              pet: pet,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SectionCard(
                                  metrics: metrics,
                                  title: 'Appointment History',
                                  trailing: 'View All',
                                  child: Column(
                                    children: _appointments
                                        .map(
                                          (appointment) => Padding(
                                            padding: EdgeInsets.only(
                                              bottom: appointment ==
                                                      _appointments.last
                                                  ? 0
                                                  : metrics.cardGap,
                                            ),
                                            child: _AppointmentCard(
                                              metrics: metrics,
                                              appointment: appointment,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                SizedBox(height: metrics.sectionGap),
                                _SectionCard(
                                  metrics: metrics,
                                  title: 'Account Setting',
                                  child: Column(
                                    children: [
                                      ..._accountOptions.map(
                                        (option) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: option == _accountOptions.last
                                                ? metrics.cardGap
                                                : metrics.cardGap,
                                          ),
                                          child: _SettingTile(
                                            metrics: metrics,
                                            icon: option.icon,
                                            label: option.label,
                                            onTap: () =>
                                                _showMessage(option.label),
                                          ),
                                        ),
                                      ),
                                      _LogoutButton(metrics: metrics),
                                    ],
                                  ),
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
                      child: _ProfileBottomNav(metrics: metrics),
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

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({
    required this.metrics,
    required this.imageProvider,
    required this.onPickImage,
  });

  final _ProfileMetrics metrics;
  final ImageProvider? imageProvider;
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(metrics.sectionPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(metrics.sectionRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Stack(
              children: [
                Container(
                  width: metrics.profilePhotoSize,
                  height: metrics.profilePhotoSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7600),
                    borderRadius: BorderRadius.circular(20),
                    image: imageProvider != null
                        ? DecorationImage(
                            image: imageProvider!,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageProvider == null
                      ? Icon(
                          Icons.person_outline_rounded,
                          size: metrics.profilePhotoIconSize,
                          color: Colors.white.withValues(alpha: 0.88),
                        )
                      : null,
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    width: metrics.cameraChipSize,
                    height: metrics.cameraChipSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7600),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_camera_outlined,
                      size: metrics.cameraIconSize,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: metrics.infoGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _profileFields
                  .map(
                    (field) => Padding(
                      padding: EdgeInsets.only(
                        bottom: field == _profileFields.last
                            ? 0
                            : metrics.fieldGap,
                      ),
                      child: _ProfileField(
                        metrics: metrics,
                        field: field,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.metrics,
    required this.field,
  });

  final _ProfileMetrics metrics;
  final _ProfileFieldData field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (field.icon case final IconData icon) ...[
              Icon(
                icon,
                size: metrics.fieldIconSize,
                color: Colors.black,
              ),
              SizedBox(width: metrics.fieldIconGap),
            ],
            Text(
              field.label,
              style: TextStyle(
                fontSize: metrics.fieldLabelSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(height: metrics.fieldValueGap),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: metrics.fieldHorizontalPadding,
            vertical: metrics.fieldVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF848A99),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            field.value,
            style: TextStyle(
              fontSize: metrics.fieldValueSize,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.metrics,
    required this.title,
    required this.child,
    this.trailing,
  });

  final _ProfileMetrics metrics;
  final String title;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(metrics.sectionPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(metrics.sectionRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: metrics.sectionTitleSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              if (trailing case final String trailingText)
                Text(
                  trailingText,
                  style: TextStyle(
                    fontSize: metrics.trailingSize,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          SizedBox(height: metrics.cardGap),
          child,
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.metrics,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final _ProfileMetrics metrics;
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: metrics.quickActionPadding,
          horizontal: metrics.quickActionHorizontalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              width: metrics.quickActionIconBoxSize,
              height: metrics.quickActionIconBoxSize,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: metrics.quickActionIconSize,
                color: Colors.white,
              ),
            ),
            SizedBox(height: metrics.quickActionTextGap),
            Text(
              label,
              style: TextStyle(
                fontSize: metrics.quickActionLabelSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetSummaryCard extends StatelessWidget {
  const _PetSummaryCard({
    required this.metrics,
    required this.pet,
  });

  final _ProfileMetrics metrics;
  final _ProfilePet pet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(metrics.petCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            width: metrics.petThumbnailSize,
            height: metrics.petThumbnailSize,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              pet.icon,
              size: metrics.petThumbnailIconSize,
              color: const Color(0xFF7A8088),
            ),
          ),
          SizedBox(width: metrics.infoGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: TextStyle(
                    fontSize: metrics.petNameSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: metrics.heroTextGap),
                Text(
                  pet.summary,
                  style: TextStyle(
                    fontSize: metrics.petMetaSize,
                    color: Colors.black,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.metrics,
    required this.appointment,
  });

  final _ProfileMetrics metrics;
  final _Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(metrics.appointmentPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.title,
                  style: TextStyle(
                    fontSize: metrics.appointmentTitleSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: metrics.heroTextGap),
                Text(
                  appointment.meta,
                  style: TextStyle(
                    fontSize: metrics.appointmentMetaSize,
                    color: const Color(0xFF707389),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: metrics.infoGap),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.statusHorizontalPadding,
              vertical: metrics.statusVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: appointment.statusBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              appointment.status,
              style: TextStyle(
                fontSize: metrics.statusTextSize,
                fontWeight: FontWeight.w500,
                color: appointment.statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.metrics,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final _ProfileMetrics metrics;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: metrics.settingHorizontalPadding,
          vertical: metrics.settingVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: metrics.settingIconSize,
              color: Colors.black,
            ),
            SizedBox(width: metrics.infoGap),
            Text(
              label,
              style: TextStyle(
                fontSize: metrics.settingLabelSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.metrics});

  final _ProfileMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: metrics.logoutHorizontalPadding,
        vertical: metrics.logoutVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEE2734),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(
            Icons.logout_rounded,
            size: metrics.logoutIconSize,
            color: Colors.white,
          ),
          SizedBox(width: metrics.infoGap),
          Text(
            'Logout',
            style: TextStyle(
              fontSize: metrics.logoutTextSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBottomNav extends StatelessWidget {
  const _ProfileBottomNav({required this.metrics});

  final _ProfileMetrics metrics;

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
            key: const Key('profile_nav_pets'),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const MyPetsPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                ProfilePage._petsIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('profile_nav_clinic'),
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ClinicPage(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                ProfilePage._clinicIconAsset,
                width: metrics.navIconSize,
                height: metrics.navIconSize,
              ),
            ),
          ),
          SizedBox(width: metrics.navIconGap),
          InkWell(
            key: const Key('profile_nav_products'),
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
                ProfilePage._basketIconAsset,
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
                    ProfilePage._profileIconAsset,
                    width: metrics.navSelectedIconSize,
                    height: metrics.navSelectedIconSize,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Profile',
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
        ],
      ),
    );
  }
}

class _ProfileMetrics {
  const _ProfileMetrics({
    required this.maxContentWidth,
    required this.sidePadding,
    required this.topPadding,
    required this.logoSize,
    required this.headerHeight,
    required this.sectionGap,
    required this.cardGap,
    required this.sectionPadding,
    required this.sectionRadius,
    required this.profilePhotoSize,
    required this.profilePhotoIconSize,
    required this.cameraChipSize,
    required this.cameraIconSize,
    required this.infoGap,
    required this.fieldGap,
    required this.fieldIconSize,
    required this.fieldIconGap,
    required this.fieldLabelSize,
    required this.fieldValueGap,
    required this.fieldHorizontalPadding,
    required this.fieldVerticalPadding,
    required this.fieldValueSize,
    required this.sectionTitleSize,
    required this.trailingSize,
    required this.quickActionPadding,
    required this.quickActionHorizontalPadding,
    required this.quickActionIconBoxSize,
    required this.quickActionIconSize,
    required this.quickActionTextGap,
    required this.quickActionLabelSize,
    required this.petCardPadding,
    required this.petThumbnailSize,
    required this.petThumbnailIconSize,
    required this.petNameSize,
    required this.petMetaSize,
    required this.heroTextGap,
    required this.appointmentPadding,
    required this.appointmentTitleSize,
    required this.appointmentMetaSize,
    required this.statusHorizontalPadding,
    required this.statusVerticalPadding,
    required this.statusTextSize,
    required this.settingHorizontalPadding,
    required this.settingVerticalPadding,
    required this.settingIconSize,
    required this.settingLabelSize,
    required this.logoutHorizontalPadding,
    required this.logoutVerticalPadding,
    required this.logoutIconSize,
    required this.logoutTextSize,
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
  final double logoSize;
  final double headerHeight;
  final double sectionGap;
  final double cardGap;
  final double sectionPadding;
  final double sectionRadius;
  final double profilePhotoSize;
  final double profilePhotoIconSize;
  final double cameraChipSize;
  final double cameraIconSize;
  final double infoGap;
  final double fieldGap;
  final double fieldIconSize;
  final double fieldIconGap;
  final double fieldLabelSize;
  final double fieldValueGap;
  final double fieldHorizontalPadding;
  final double fieldVerticalPadding;
  final double fieldValueSize;
  final double sectionTitleSize;
  final double trailingSize;
  final double quickActionPadding;
  final double quickActionHorizontalPadding;
  final double quickActionIconBoxSize;
  final double quickActionIconSize;
  final double quickActionTextGap;
  final double quickActionLabelSize;
  final double petCardPadding;
  final double petThumbnailSize;
  final double petThumbnailIconSize;
  final double petNameSize;
  final double petMetaSize;
  final double heroTextGap;
  final double appointmentPadding;
  final double appointmentTitleSize;
  final double appointmentMetaSize;
  final double statusHorizontalPadding;
  final double statusVerticalPadding;
  final double statusTextSize;
  final double settingHorizontalPadding;
  final double settingVerticalPadding;
  final double settingIconSize;
  final double settingLabelSize;
  final double logoutHorizontalPadding;
  final double logoutVerticalPadding;
  final double logoutIconSize;
  final double logoutTextSize;
  final double bottomNavHeight;
  final double bottomNavSelectedHeight;
  final double bottomNavSelectedTextSize;
  final double bottomNavBottomPadding;
  final double bottomDockSpacing;
  final double navIconGap;
  final double navIconSize;
  final double navSelectedIconSize;

  static _ProfileMetrics fromSize(Size size) {
    final width = size.width;
    final height = size.height;
    final shortest = math.min(width, height);
    final isTablet = width >= 700;
    final isDesktop = width >= 1000;

    return _ProfileMetrics(
      maxContentWidth: isDesktop ? 760 : 620,
      sidePadding: isDesktop ? 30 : (isTablet ? 24 : 18),
      topPadding: height < 700 ? 8 : 18,
      logoSize: isDesktop ? 108 : (isTablet ? 96 : 84),
      headerHeight: isDesktop ? 220 : (isTablet ? 210 : 190),
      sectionGap: shortest < 390 ? 18 : 26,
      cardGap: shortest < 390 ? 12 : 16,
      sectionPadding: shortest < 390 ? 16 : 20,
      sectionRadius: 30,
      profilePhotoSize: isDesktop ? 190 : (isTablet ? 170 : 140),
      profilePhotoIconSize: shortest < 390 ? 42 : 58,
      cameraChipSize: shortest < 390 ? 36 : 42,
      cameraIconSize: shortest < 390 ? 18 : 22,
      infoGap: shortest < 390 ? 12 : 16,
      fieldGap: shortest < 390 ? 12 : 14,
      fieldIconSize: shortest < 390 ? 22 : 26,
      fieldIconGap: 10,
      fieldLabelSize: shortest < 390 ? 18 : 21,
      fieldValueGap: 8,
      fieldHorizontalPadding: shortest < 390 ? 14 : 16,
      fieldVerticalPadding: shortest < 390 ? 10 : 12,
      fieldValueSize: shortest < 390 ? 14 : 16,
      sectionTitleSize: isDesktop ? 28 : (shortest < 390 ? 22 : 24),
      trailingSize: shortest < 390 ? 18 : 20,
      quickActionPadding: shortest < 390 ? 14 : 18,
      quickActionHorizontalPadding: shortest < 390 ? 10 : 14,
      quickActionIconBoxSize: shortest < 390 ? 86 : 108,
      quickActionIconSize: shortest < 390 ? 44 : 58,
      quickActionTextGap: shortest < 390 ? 10 : 12,
      quickActionLabelSize: shortest < 390 ? 18 : 20,
      petCardPadding: shortest < 390 ? 14 : 16,
      petThumbnailSize: shortest < 390 ? 84 : 96,
      petThumbnailIconSize: shortest < 390 ? 36 : 44,
      petNameSize: shortest < 390 ? 18 : 20,
      petMetaSize: shortest < 390 ? 15 : 17,
      heroTextGap: 6,
      appointmentPadding: shortest < 390 ? 14 : 18,
      appointmentTitleSize: shortest < 390 ? 18 : 20,
      appointmentMetaSize: shortest < 390 ? 14 : 16,
      statusHorizontalPadding: shortest < 390 ? 10 : 14,
      statusVerticalPadding: shortest < 390 ? 6 : 8,
      statusTextSize: shortest < 390 ? 14 : 16,
      settingHorizontalPadding: shortest < 390 ? 14 : 16,
      settingVerticalPadding: shortest < 390 ? 12 : 14,
      settingIconSize: shortest < 390 ? 26 : 30,
      settingLabelSize: shortest < 390 ? 18 : 20,
      logoutHorizontalPadding: shortest < 390 ? 18 : 22,
      logoutVerticalPadding: shortest < 390 ? 14 : 16,
      logoutIconSize: shortest < 390 ? 28 : 32,
      logoutTextSize: shortest < 390 ? 18 : 20,
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

class _ProfileFieldData {
  const _ProfileFieldData({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;
}

class _ProfilePet {
  const _ProfilePet({
    required this.name,
    required this.summary,
    required this.icon,
  });

  final String name;
  final String summary;
  final IconData icon;
}

class _Appointment {
  const _Appointment({
    required this.title,
    required this.meta,
    required this.status,
    required this.statusBackground,
    required this.statusColor,
  });

  final String title;
  final String meta;
  final String status;
  final Color statusBackground;
  final Color statusColor;
}

class _AccountOption {
  const _AccountOption({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

const _profileFields = [
  _ProfileFieldData(
    label: 'Name',
    value: 'May Thu Aung',
  ),
  _ProfileFieldData(
    label: 'Phone No',
    value: '09-765432109',
    icon: Icons.phone_outlined,
  ),
  _ProfileFieldData(
    label: 'Email',
    value: 'maythu@example.com',
    icon: Icons.mail_outline_rounded,
  ),
  _ProfileFieldData(
    label: 'Address',
    value: 'Mingalardipa quarter, Pobba Thiri Township, Nay Pyi Taw',
    icon: Icons.home_outlined,
  ),
];

const _profilePets = [
  _ProfilePet(
    name: 'DEE',
    summary: 'Local, Dog, 23Kg',
    icon: Icons.pets_rounded,
  ),
  _ProfilePet(
    name: 'DEE',
    summary: 'Local, Cat, 13Kg',
    icon: Icons.pets_outlined,
  ),
];

const _appointments = [
  _Appointment(
    title: 'General Health Checkup',
    meta: 'Max • 2026-04-15 at 2:30 PM',
    status: 'Scheduled',
    statusBackground: Color(0xFFDDE8FF),
    statusColor: Color(0xFF2050F2),
  ),
  _Appointment(
    title: 'Annual Checkup',
    meta: 'Luna • 2026-02-15 at 2:00 PM',
    status: 'Completed',
    statusBackground: Color(0xFFD9F8E0),
    statusColor: Color(0xFF0B8C37),
  ),
];

const _accountOptions = [
  _AccountOption(
    label: 'Account',
    icon: Icons.person_outline_rounded,
  ),
  _AccountOption(
    label: 'Notifications',
    icon: Icons.notifications_none_rounded,
  ),
  _AccountOption(
    label: 'Preferences',
    icon: Icons.tune_rounded,
  ),
  _AccountOption(
    label: 'About',
    icon: Icons.info_outline_rounded,
  ),
];
