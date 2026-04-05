import 'package:flutter/material.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({
    super.key,
    required this.petName,
  });

  final String petName;

  static const _medicalIconAsset =
      'icons/e614d5b7-df99-41cc-accc-32e6483525e7.png';

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  late final List<_ReminderItem> _reminders;

  @override
  void initState() {
    super.initState();
    _reminders = List<_ReminderItem>.from(_remindersFor(widget.petName));
  }

  Future<void> _openAddReminderDialog() async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final noteController = TextEditingController();
    String selectedCategory = '💉 Vaccine';

    final createdReminder = await showDialog<_ReminderItem>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Add Reminder'),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DialogField(
                      controller: titleController,
                      label: 'Reminder title',
                      hintText: 'Annual booster shot',
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: dateController,
                      label: 'Date',
                      hintText: 'Apr 25, 2026',
                    ),
                    const SizedBox(height: 12),
                    _DialogField(
                      controller: timeController,
                      label: 'Time',
                      hintText: '11:00 AM',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: _dialogInputDecoration('Category'),
                      items: const [
                        DropdownMenuItem(
                          value: '💉 Vaccine',
                          child: Text('💉 Vaccine'),
                        ),
                        DropdownMenuItem(
                          value: '🏥 Check-up',
                          child: Text('🏥 Check-up'),
                        ),
                        DropdownMenuItem(
                          value: '💊 Medication',
                          child: Text('💊 Medication'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategory = value;
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: noteController,
                      minLines: 3,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a note';
                        }
                        return null;
                      },
                      decoration: _dialogInputDecoration('Note').copyWith(
                        hintText: 'Bring vaccination card',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Navigator.of(context).pop(
                  _ReminderItem(
                    title: titleController.text.trim(),
                    date: dateController.text.trim(),
                    time: timeController.text.trim(),
                    category: selectedCategory,
                    note: noteController.text.trim(),
                    completed: false,
                    iconGradient: _gradientForCategory(selectedCategory),
                    tagTint: _tagTintForCategory(selectedCategory),
                    tagTextColor: _tagTextForCategory(selectedCategory),
                    noteTint: _noteTintForCategory(selectedCategory),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (createdReminder != null && mounted) {
      setState(() {
        _reminders.insert(0, createdReminder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAFC5B8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 390;
            final sidePadding = width >= 700 ? 28.0 : 16.0;
            final titleSize = compact ? 26.0 : 34.0;
            final bodySize = compact ? 16.0 : 18.0;
            final cardSpacing = compact ? 18.0 : 22.0;
            final contentMaxWidth = width >= 900 ? 720.0 : 560.0;
            final subtitleSize = compact ? 14.0 : 15.0;
            final pendingCount = _reminders.where((item) => !item.completed).length;
            final completedCount = _reminders.length - pendingCount;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        12,
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
                                  'Reminder',
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _openAddReminderDialog,
                                  child: _HeaderActionButton(compact: compact),
                                ),
                              ],
                            ),
                            SizedBox(height: compact ? 18 : 24),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(compact ? 16 : 18),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.70),
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.petName,
                                    style: TextStyle(
                                      fontSize: compact ? 24 : 28,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF18212F),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Manage vaccine dates, checkups, and follow-up reminders in one place.',
                                    style: TextStyle(
                                      fontSize: subtitleSize,
                                      color: const Color(0xFF52625C),
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      _SummaryPill(
                                        label: '$pendingCount pending',
                                        color: const Color(0xFFFFF0D9),
                                        textColor: const Color(0xFFB25B00),
                                      ),
                                      _SummaryPill(
                                        label: '$completedCount completed',
                                        color: const Color(0xFFE2F8EA),
                                        textColor: const Color(0xFF0E8E45),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: compact ? 18 : 22),
                            ..._reminders.map(
                              (reminder) => Padding(
                                padding: EdgeInsets.only(bottom: cardSpacing),
                                child: _ReminderCard(
                                  reminder: reminder,
                                  bodySize: bodySize,
                                  compact: compact,
                                ),
                              ),
                            ),
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

InputDecoration _dialogInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFFF8F9FA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE3E7EC)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE3E7EC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF7AA59A), width: 1.4),
    ),
  );
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.controller,
    required this.label,
    required this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      decoration: _dialogInputDecoration(label).copyWith(hintText: hintText),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.bodySize,
    required this.compact,
  });

  final _ReminderItem reminder;
  final double bodySize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleSize = compact ? 20.0 : 24.0;
    final statusText = reminder.completed ? 'Completed' : 'Upcoming';
    final statusColor = reminder.completed
        ? const Color(0xFF14AE5C)
        : const Color(0xFFFF8A00);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: reminder.completed ? 0.92 : 0.98),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: compact ? 58 : 64,
                height: compact ? 58 : 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: reminder.iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: reminder.iconGradient.first.withValues(alpha: 0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    ReminderPage._medicalIconAsset,
                    width: compact ? 24 : 28,
                    height: compact ? 24 : 28,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatusBadge(
                          label: statusText,
                          color: statusColor,
                        ),
                        const Spacer(),
                        Text(
                          reminder.completed ? 'Done' : 'Action needed',
                          style: TextStyle(
                            fontSize: compact ? 13 : 14,
                            color: const Color(0xFF6A7688),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D2637)
                            .withValues(alpha: reminder.completed ? 0.55 : 1),
                        decoration: reminder.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _MetaPill(
                          icon: Icons.calendar_today_outlined,
                          text: reminder.date,
                          bodySize: bodySize,
                        ),
                        _MetaPill(
                          icon: Icons.access_time_rounded,
                          text: reminder.time,
                          bodySize: bodySize,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TagPill(
                      label: reminder.category,
                      tint: reminder.tagTint,
                      textColor: reminder.tagTextColor,
                      bodySize: bodySize,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(compact ? 14 : 16),
            decoration: BoxDecoration(
              color: reminder.noteTint.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: reminder.noteTint.withValues(alpha: 0.8),
              ),
            ),
            child: Text(
              '📝 ${reminder.note}',
              style: TextStyle(
                fontSize: bodySize,
                height: 1.35,
                color: const Color(0xFF3A4657),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: compact ? 50 : 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF03C744),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        reminder.completed ? 'Completed' : 'Mark Complete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 16 : 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _MiniAction(
                icon: Icons.edit_outlined,
                color: const Color(0xFF2563FF),
                semanticLabel: 'Edit reminder',
              ),
              const SizedBox(width: 18),
              _MiniAction(
                icon: Icons.delete_outline_rounded,
                color: const Color(0xFFFF1A1A),
                semanticLabel: 'Delete reminder',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 70 : 80,
      height: compact ? 70 : 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6A13),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33A04D14),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 2),
          Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 12 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.icon,
    required this.color,
    required this.semanticLabel,
  });

  final IconData icon;
  final Color color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.text,
    required this.bodySize,
  });

  final IconData icon;
  final String text;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF667085)),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: bodySize,
              color: const Color(0xFF536173),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.tint,
    required this.textColor,
    required this.bodySize,
  });

  final String label;
  final Color tint;
  final Color textColor;
  final double bodySize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: bodySize - 1,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReminderItem {
  const _ReminderItem({
    required this.title,
    required this.date,
    required this.time,
    required this.category,
    required this.note,
    required this.completed,
    required this.iconGradient,
    required this.tagTint,
    required this.tagTextColor,
    required this.noteTint,
  });

  final String title;
  final String date;
  final String time;
  final String category;
  final String note;
  final bool completed;
  final List<Color> iconGradient;
  final Color tagTint;
  final Color tagTextColor;
  final Color noteTint;
}

List<Color> _gradientForCategory(String category) {
  if (category.contains('Check-up')) {
    return const [Color(0xFFB53BFF), Color(0xFF8F12E7)];
  }
  if (category.contains('Medication')) {
    return const [Color(0xFFFF9A3D), Color(0xFFFF6A13)];
  }
  return const [Color(0xFF3E8BFF), Color(0xFF1F57E7)];
}

Color _tagTintForCategory(String category) {
  if (category.contains('Check-up')) {
    return const Color(0xFFF0DFFF);
  }
  if (category.contains('Medication')) {
    return const Color(0xFFFFE5D1);
  }
  return const Color(0xFFD9E8FF);
}

Color _tagTextForCategory(String category) {
  if (category.contains('Check-up')) {
    return const Color(0xFF861FE8);
  }
  if (category.contains('Medication')) {
    return const Color(0xFFCC5A00);
  }
  return const Color(0xFF1B56E5);
}

Color _noteTintForCategory(String category) {
  if (category.contains('Check-up')) {
    return const Color(0xFFEED7FF);
  }
  if (category.contains('Medication')) {
    return const Color(0xFFFFD7B8);
  }
  return const Color(0xFFBCD8FF);
}

List<_ReminderItem> _remindersFor(String petName) {
  return [
    _ReminderItem(
      title: 'Annual Rabies Vaccination',
      date: 'Apr 04, 2026',
      time: '10:00 AM',
      category: '💉 Vaccine',
      note: 'Bring previous vaccination records for $petName.',
      completed: false,
      iconGradient: const [Color(0xFF3E8BFF), Color(0xFF1F57E7)],
      tagTint: const Color(0xFFD9E8FF),
      tagTextColor: const Color(0xFF1B56E5),
      noteTint: const Color(0xFFBCD8FF),
    ),
    _ReminderItem(
      title: 'General Health Checkup',
      date: 'Apr 15, 2026',
      time: '2:30 PM',
      category: '🏥 Check-up',
      note: 'Follow-up for grain-free diet assessment and activity review.',
      completed: false,
      iconGradient: const [Color(0xFFB53BFF), Color(0xFF8F12E7)],
      tagTint: const Color(0xFFF0DFFF),
      tagTextColor: const Color(0xFF861FE8),
      noteTint: const Color(0xFFEED7FF),
    ),
    _ReminderItem(
      title: 'Bordetella Vaccine',
      date: 'Mar 02, 2026',
      time: '9:00 AM',
      category: '💉 Vaccine',
      note: 'Completed successfully.',
      completed: true,
      iconGradient: const [Color(0xFF9FC2FF), Color(0xFF77A4F2)],
      tagTint: const Color(0xFFD9E8FF),
      tagTextColor: const Color(0xFF1B56E5),
      noteTint: const Color(0xFFBCD8FF),
    ),
  ];
}
