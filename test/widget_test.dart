import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/screens/auth_screen.dart';
import 'package:todo_list_app/screens/todo_home_screen.dart';

void main() {
  testWidgets('AuthScreen render smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AuthScreen()));
    expect(find.text('Personal Daily Planner'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Sign In'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Continue as Guest'), findsOneWidget);
  });

  testWidgets('TodoHomeScreen planner smoke & functionality test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TodoHomeScreen()));
    await tester.pumpAndSettle();

    // Verify header and initial sample tasks are present
    expect(find.text('Today\'s Tasks (3)'), findsOneWidget);
    expect(find.text('Plan today\'s priority goals 🎯'), findsOneWidget);

    // Test adding an empty task (Validation check)
    final addButtonFinder = find.widgetWithText(FilledButton, 'Add');
    expect(addButtonFinder, findsOneWidget);

    await tester.tap(addButtonFinder);
    await tester.pumpAndSettle();

    // Verify validation SnackBar appears
    expect(find.text('Please enter a task before adding!'), findsOneWidget);

    // Dismiss SnackBar
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Test entering and adding a new task
    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    await tester.enterText(textFieldFinder, 'Complete Flutter Web Deployment');
    await tester.tap(addButtonFinder);
    await tester.pumpAndSettle();

    // Verify the new task is added to the list
    expect(find.text('Complete Flutter Web Deployment'), findsOneWidget);

    // Test toggling completion via Checkbox
    final firstCheckboxFinder = find.byType(Checkbox).first;
    await tester.tap(firstCheckboxFinder);
    await tester.pumpAndSettle();

    // Test swiping to delete a task
    final dismissibleFinder = find.byType(Dismissible).first;
    await tester.drag(dismissibleFinder, const Offset(-500.0, 0.0));
    await tester.pumpAndSettle();

    // Verify Undo snackbar appears
    expect(find.text('UNDO'), findsOneWidget);
  });
}
