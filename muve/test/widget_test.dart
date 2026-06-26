import 'package:flutter_test/flutter_test.dart';

import 'package:muve/main.dart';

void main() {
  testWidgets('Muve app starts on splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MuveApp());

    expect(find.text('MUVE'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo de volta'), findsOneWidget);
  });
}
