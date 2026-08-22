import 'package:flutter_test/flutter_test.dart';
import 'package:hangman_escape_app/main.dart';

void main() {
  testWidgets('Hangman Escape App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HangmanEscapeApp());
    expect(find.text('Hangman Escape'), findsOneWidget);
  });
}
