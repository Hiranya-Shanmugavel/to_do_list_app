import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';

void main() {
  testWidgets('To-Do List App smoke and functionality test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TodoListApp());

    // Verify app title is displayed
    expect(find.text('My Tasks'), findsOneWidget);

    // Verify initial sample tasks are present
    expect(find.text('Welcome to your To-Do App! 👋'), findsOneWidget);
    expect(find.text('Tap the checkbox to mark as complete'), findsOneWidget);

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

    await tester.enterText(textFieldFinder, 'Complete Flutter Project');
    await tester.tap(addButtonFinder);
    await tester.pumpAndSettle();

    // Verify the new task is added to the list
    expect(find.text('Complete Flutter Project'), findsOneWidget);

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
