import 'package:flutter_test/flutter_test.dart';
import 'package:practical_12/main.dart' as app;

void main() {
  testWidgets('Практична 12: відкривається потрібний екран', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsWidgets);
  });
}
