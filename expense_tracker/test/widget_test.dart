import 'package:expense_tracker/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app renders home screen with balance', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseTrackerApp()));
    await tester.pumpAndSettle();

    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
  });

  testWidgets('navigates between tabs', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseTrackerApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Budget'));
    await tester.pumpAndSettle();
    expect(find.text('Category Budgets'), findsOneWidget);

    await tester.tap(find.text('Analytics'));
    await tester.pumpAndSettle();
    expect(find.text('Total Spending'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Dark Mode'), findsOneWidget);
  });

  testWidgets('add transaction form shows validation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseTrackerApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save Transaction'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Transaction'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter an amount'), findsOneWidget);
  });

  testWidgets('adding a transaction reflects on home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ExpenseTrackerApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Test Lunch');
    await tester.enterText(find.byType(TextField).at(1), '25.50');

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Food').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save Transaction'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Transaction'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Test Lunch'), findsOneWidget);
  });
}
