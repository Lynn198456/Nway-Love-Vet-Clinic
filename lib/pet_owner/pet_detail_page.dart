import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PetProfile {
  const PetProfile({
    required this.name,
    required this.breed,
    required this.species,
    required this.sex,
    required this.weight,
    required this.vaccinationHistory,
    required this.upcomingVaccinationSchedule,
    required this.allergies,
    required this.appointmentHistory,
    required this.treatmentRecords,
    this.imageAsset,
  });

  final String name;
  final String breed;
  final String species;
  final String sex;
  final String weight;
  final String vaccinationHistory;
  final String upcomingVaccinationSchedule;
  final String allergies;
  final String appointmentHistory;
  final String treatmentRecords;
  final String? imageAsset;
}

class PetDetailPage extends StatefulWidget {
  const PetDetailPage({super.key, required this.pet});

  final PetProfile pet;

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  static const _nameIconAsset = 'icons/IMG_5276.png';
  static const _breedIconAsset = 'icons/IMG_8550.png';
  static const _speciesIconAsset = 'icons/IMG_7680.png';
  static const _weightIconAsset = 'icons/IMG_2389.png';
  static const _sexIconAsset = 'icons/IMG_2610.png';
  static const _editImageIconAsset = 'icons/IMG_3544.png';
  static const _emergencyIconAsset =
      'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  File? _selectedImageFile;

  Future<void> _pickPetPhoto() async {
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

  ImageProvider? _petImageProvider() {
    if (_selectedImageBytes != null) {
      return MemoryImage(_selectedImageBytes!);
    }
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    }
    if (widget.pet.imageAsset != null) {
      return AssetImage(widget.pet.imageAsset!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      backgroundColor: const Color(0xFFE7EFEA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 390;
            final contentMaxWidth = width >= 900 ? 720.0 : 560.0;
            final sidePadding = width >= 700 ? 26.0 : 18.0;
            final sectionRadius = compact ? 28.0 : 34.0;
            final headingSize = compact ? 24.0 : 30.0;
            final bodySize = compact ? 17.0 : 19.0;
            final infoItemWidth =
                width >= 700 ? 220.0 : (compact ? 142.0 : 170.0);
            final petImage = _petImageProvider();

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        10,
                        sidePadding,
                        24,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                  ),
                                ),
                                Text(
                                  'Pet Detail',
                                  style: TextStyle(
                                    fontSize: compact ? 26 : 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: compact ? 12 : 18),
                            GestureDetector(
                              onTap: _pickPetPhoto,
                              child: Container(
                                height: compact ? 210 : 260,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFADB3AE),
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: petImage != null
                                          ? DecoratedBox(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: petImage,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Image.asset(
                                                _nameIconAsset,
                                                width: 94,
                                                height: 94,
                                                color: Colors.white70,
                                              ),
                                            ),
                                    ),
                                    Positioned.fill(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(alpha: 0.10),
                                              Colors.black.withValues(alpha: 0.28),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 18,
                                      right: 18,
                                      child: _ActionChip(
                                        iconAsset: _editImageIconAsset,
                                        label: 'Upload',
                                        compact: compact,
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      right: 20,
                                      bottom: 18,
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white
                                                  .withValues(alpha: 0.18),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withValues(alpha: 0.36),
                                              ),
                                            ),
                                            child: Text(
                                              pet.weight,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: compact ? 14 : 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 28),
                            _DetailSection(
                              title: 'Basic Info',
                              subtitle: 'Quick facts for everyday reference',
                              headingSize: headingSize,
                              borderRadius: sectionRadius,
                              child: Wrap(
                                runSpacing: 18,
                                spacing: 18,
                                children: [
                                  _InfoItem(
                                    iconAsset: _nameIconAsset,
                                    label: 'Name',
                                    value: pet.name,
                                    bodySize: bodySize,
                                    width: infoItemWidth,
                                  ),
                                  _InfoItem(
                                    iconAsset: _breedIconAsset,
                                    label: 'Breed',
                                    value: pet.breed,
                                    bodySize: bodySize,
                                    width: infoItemWidth,
                                  ),
                                  _InfoItem(
                                    iconAsset: _speciesIconAsset,
                                    label: 'Species',
                                    value: pet.species,
                                    bodySize: bodySize,
                                    width: infoItemWidth,
                                  ),
                                  _InfoItem(
                                    iconAsset: _weightIconAsset,
                                    label: 'Weight',
                                    value: pet.weight,
                                    bodySize: bodySize,
                                    width: infoItemWidth,
                                  ),
                                  _InfoItem(
                                    iconAsset: _sexIconAsset,
                                    label: 'Sex',
                                    value: pet.sex,
                                    bodySize: bodySize,
                                    width: infoItemWidth,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 28),
                            _DetailSection(
                              title: 'Medical Info',
                              subtitle: 'Vaccines, reminders, and care alerts',
                              headingSize: headingSize,
                              borderRadius: sectionRadius,
                              trailing: _SoftActionButton(
                                label: 'Edit Reminder',
                                compact: compact,
                              ),
                              child: Column(
                                children: [
                                  _TextCard(
                                    title: 'Vaccination history',
                                    body: pet.vaccinationHistory,
                                    bodySize: bodySize,
                                  ),
                                  const SizedBox(height: 14),
                                  _TextCard(
                                    title: 'Upcoming vaccination schedule',
                                    body: pet.upcomingVaccinationSchedule,
                                    bodySize: bodySize,
                                  ),
                                  const SizedBox(height: 14),
                                  _TextCard(
                                    title: 'Allergies',
                                    body: pet.allergies,
                                    bodySize: bodySize,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 28),
                            _DetailSection(
                              title: 'Appointment History',
                              subtitle: 'Past care visits and upcoming notes',
                              headingSize: headingSize,
                              borderRadius: sectionRadius,
                              child: Column(
                                children: [
                                  _TextCard(
                                    title: 'Past visits',
                                    body: pet.appointmentHistory,
                                    bodySize: bodySize,
                                  ),
                                  const SizedBox(height: 14),
                                  _TextCard(
                                    title: 'Next appointment reminder',
                                    body:
                                        'Check-in 10 minutes early and bring vaccination records for faster service.',
                                    bodySize: bodySize,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 28),
                            _DetailSection(
                              title: 'Treatment & Prescription Records',
                              subtitle: 'Diagnosis, medicines, and home care',
                              headingSize: headingSize,
                              borderRadius: sectionRadius,
                              child: Column(
                                children: [
                                  _TextCard(
                                    title: 'Current record',
                                    body: pet.treatmentRecords,
                                    bodySize: bodySize,
                                  ),
                                  const SizedBox(height: 14),
                                  _TextCard(
                                    title: 'Care notes',
                                    body:
                                        'Observe eating habits, keep fresh water available, and contact the clinic if symptoms continue for more than 48 hours.',
                                    bodySize: bodySize,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 24 : 32),
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF2314),
                                  borderRadius: BorderRadius.circular(26),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33FF2314),
                                      blurRadius: 16,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      _emergencyIconAsset,
                                      width: compact ? 28 : 32,
                                      height: compact ? 28 : 32,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Emergency',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: compact ? 22 : 26,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.subtitle,
    required this.headingSize,
    required this.borderRadius,
    required this.child,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final double headingSize;
  final double borderRadius;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFAFC5B8),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: headingSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF55665E),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing case final Widget trailingWidget) ...[
                const SizedBox(width: 12),
                trailingWidget,
              ],
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.iconAsset,
    required this.label,
    required this.compact,
  });

  final String iconAsset;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 8 : 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconAsset,
            width: compact ? 20 : 22,
            height: compact ? 20 : 22,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftActionButton extends StatelessWidget {
  const _SoftActionButton({
    required this.label,
    required this.compact,
  });

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 14 : 18,
        vertical: compact ? 9 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: compact ? 15 : 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.bodySize,
    required this.width,
  });

  final String iconAsset;
  final String label;
  final String value;
  final double bodySize;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Image.asset(
                iconAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: bodySize - 1,
                    color: Colors.black.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: bodySize,
                    fontWeight: FontWeight.w600,
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

class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.title,
    required this.body,
    required this.bodySize,
  });

  final String title;
  final String body;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: bodySize,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(body, style: TextStyle(fontSize: bodySize - 1, height: 1.3)),
        ],
      ),
    );
  }
}
