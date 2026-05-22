import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('app title renders', (
    tester,
  ) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('SpendArc'),
        ),
      ),
    );

    expect(
      find.text('SpendArc'),
      findsOneWidget,
    );
  });

  testWidgets(
      'add transaction button text renders',
      (tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Add Transaction'),
        ),
      ),
    );

    expect(
      find.text('Add Transaction'),
      findsOneWidget,
    );
  });

  testWidgets(
      'shows floating action button',
      (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton:
              FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );

    expect(
      find.byType(FloatingActionButton),
      findsOneWidget,
    );
  });

  testWidgets(
      'renders transaction tile',
      (tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ListTile(
            title: Text('Food'),
            subtitle: Text('Expense'),
          ),
        ),
      ),
    );

    expect(
      find.text('Food'),
      findsOneWidget,
    );

    expect(
      find.text('Expense'),
      findsOneWidget,
    );
  });
}