import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_github_explorer/screens/home_screen.dart';
import 'package:git_github_explorer/state/app_state.dart';
import 'package:git_github_explorer/state/app_state_scope.dart';

void main() {
  testWidgets('Home title is displayed', (WidgetTester tester) async {
    final state = AppState();

    await tester.pumpWidget(
      AppStateScope(
        notifier: state,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Git & GitHub Explorer'), findsOneWidget);
    expect(find.text('Modes principaux'), findsOneWidget);
  });
}
