import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_github_explorer/screens/learn_screen.dart';
import 'package:git_github_explorer/state/app_state.dart';
import 'package:git_github_explorer/state/app_state_scope.dart';

void main() {
  testWidgets(
    'Learn screen shows grouped levels and supports search filtering',
    (WidgetTester tester) async {
      final state = AppState();

      await tester.pumpWidget(
        AppStateScope(
          notifier: state,
          child: const MaterialApp(home: LearnScreen()),
        ),
      );

      expect(find.text('Apprendre'), findsOneWidget);
      expect(find.text('Debutant'), findsWidgets);
      expect(find.text('Intermediaire'), findsWidgets);
      expect(find.text('Avance'), findsWidgets);

      await tester.enterText(find.byType(TextField).first, 'blame');
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.text('Retrouver l origine d une ligne avec git blame'),
        find.byType(ListView).first,
        const Offset(0, -300),
      );
      expect(
        find.text('Retrouver l origine d une ligne avec git blame'),
        findsOneWidget,
      );
    },
  );
}
