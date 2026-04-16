import 'package:flutter_test/flutter_test.dart';
import 'package:git_github_explorer/app.dart';

void main() {
  testWidgets('Home title is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(const GitGithubExplorerApp());

    expect(find.text('Git & GitHub Explorer'), findsOneWidget);
    expect(find.text('Modes principaux'), findsOneWidget);
  });
}
