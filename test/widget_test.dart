import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nway_love_vet_clinic/main.dart';

void main() {
  testWidgets('login page opens sign in form', (WidgetTester tester) async {
    await tester.pumpWidget(const LoveVetClinicApp());

    expect(find.text('Log in'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('My Pets'), findsWidgets);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Appointments'), findsOneWidget);

    await tester.tap(find.text('Max'));
    await tester.pumpAndSettle();

    expect(find.text('Pet Detail'), findsOneWidget);
    expect(find.text('Max'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Edit Reminder'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Edit Reminder'));
    await tester.pumpAndSettle();

    expect(find.text('Reminder'), findsOneWidget);
    expect(find.text('Annual Rabies Vaccination'), findsOneWidget);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Add Reminder'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reminder title'),
      'Dental Cleaning',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Date'),
      'May 10, 2026',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Time'),
      '1:00 PM',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Note'),
      'Bring previous dental records.',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Dental Cleaning'), findsOneWidget);
  });

  testWidgets('clinic page opens products page', (WidgetTester tester) async {
    await tester.pumpWidget(const LoveVetClinicApp());

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pets_nav_clinic')));
    await tester.pumpAndSettle();

    expect(find.text('Doctor Profiles'), findsOneWidget);

    await tester.tap(find.byKey(const Key('clinic_nav_products')));
    await tester.pumpAndSettle();

    expect(find.text('Available Products'), findsOneWidget);
    expect(find.text('Dog Food 01'), findsOneWidget);
    expect(find.text('Cat Food 01'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'rabbit');
    await tester.pumpAndSettle();

    expect(find.text('Rabbit Food 01'), findsOneWidget);
  });

  testWidgets('my pets page opens profile page', (WidgetTester tester) async {
    await tester.pumpWidget(const LoveVetClinicApp());

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pets_nav_profile')));
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('My Pet'), findsOneWidget);
    expect(find.text('Appointment History'), findsOneWidget);
    expect(find.text('Account Setting'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
