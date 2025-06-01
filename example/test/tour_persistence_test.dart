import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_feature_tour_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Tour Persistence Tests', () {
    setUp(() async {
      // Ensure SharedPreferences is initialized for each test
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({}); // Clear all preferences before each test
    });

    testWidgets('Tour does not start if already completed', (WidgetTester tester) async {
      // 1. Run the tour and complete it
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            // Ensure the TourOverlayController has a context from MaterialApp
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle(); // Allow tour to start

      // Complete the tour (assuming 3 steps, so 2 nexts and 1 finish)
      expect(find.text('Welcome!'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Second Step'), findsOneWidget);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Final Step'), findsOneWidget);
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify tour is no longer active
      expect(find.text('Welcome!'), findsNothing);
      expect(find.text('Second Step'), findsNothing);
      expect(find.text('Final Step'), findsNothing);

      // 2. Simulate app restart
      await tester.pumpWidget(Container()); // Unmount the app
      SharedPreferences.setMockInitialValues({
        'tour_completed_my_first_tour': true, // Simulate completed tour
      });
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      // 3. Verify tour does not start again
      expect(find.text('Welcome!'), findsNothing);
      expect(find.text('Second Step'), findsNothing);
      expect(find.text('Final Step'), findsNothing);
    });

    testWidgets('Tour starts if shared_preferences data is cleared', (WidgetTester tester) async {
      // 1. Run the tour and complete it (to ensure it's marked as completed)
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify tour is no longer active
      expect(find.text('Welcome!'), findsNothing);

      // 2. Simulate app restart and clear preferences
      await tester.pumpWidget(Container()); // Unmount the app
      SharedPreferences.setMockInitialValues({}); // Simulate cleared preferences
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      // 3. Verify tour starts again
      expect(find.text('Welcome!'), findsOneWidget);
    });

    testWidgets('Tour does not start if skipped', (WidgetTester tester) async {
      // 1. Run the tour and skip it
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome!'), findsOneWidget);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify tour is no longer active
      expect(find.text('Welcome!'), findsNothing);

      // 2. Simulate app restart
      await tester.pumpWidget(Container()); // Unmount the app
      SharedPreferences.setMockInitialValues({
        'tour_completed_my_first_tour': true, // Simulate skipped tour (marked as completed)
      });
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      // 3. Verify tour does not start again
      expect(find.text('Welcome!'), findsNothing);
    });

    testWidgets('Tour does not start if completed', (WidgetTester tester) async {
      // This test is essentially covered by the first test case, but explicitly for completion.
      // 1. Run the tour and complete it
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish'));
      await tester.pumpAndSettle();

      // Verify tour is no longer active
      expect(find.text('Welcome!'), findsNothing);

      // 2. Simulate app restart
      await tester.pumpWidget(Container()); // Unmount the app
      SharedPreferences.setMockInitialValues({
        'tour_completed_my_first_tour': true, // Simulate completed tour
      });
      await tester.pumpWidget(
        MaterialApp(
          home: const MyApp(),
          builder: (context, child) {
            return child!;
          },
        ),
      );
      await tester.pumpAndSettle();

      // 3. Verify tour does not start again
      expect(find.text('Welcome!'), findsNothing);
    });
  });
}