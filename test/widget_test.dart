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
  });
}
