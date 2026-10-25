import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:practical_12/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Три реальні запити для звіту', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    const endpoint =
        'https://mobile25-demo-9c3a0c9f10.requestcatcher.com';

    Future<void> fill(String key, String value) async {
      await tester.ensureVisible(find.byKey(Key(key)));
      await tester.enterText(find.byKey(Key(key)), value);
      await tester.pump();
    }

    Future<void> submit(String action) async {
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('submit')));
      await tester.tap(find.byKey(const Key('submit')));
      for (var i = 0; i < 90; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find.textContaining('Запит /$action надіслано. HTTP ').evaluate().isNotEmpty) {
          return;
        }
        if (find.textContaining('Не вдалося виконати запит.').evaluate().isNotEmpty) {
          fail('Запит /$action не надіслано');
        }
      }
      fail('Немає підтвердження запиту /$action');
    }

    await fill('endpoint', endpoint);
    await fill('email', 'student25@example.com');
    await fill('password', 'DemoPass25');
    await submit('login');

    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    await fill('name', 'Oleksandr');
    await fill('email', 'new25@example.com');
    await fill('password', 'DemoPass25');
    await fill('endpoint', endpoint);
    await submit('signup');

    await tester.ensureVisible(find.text('Back to login'));
    await tester.tap(find.text('Back to login'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await tester.pumpAndSettle();
    await fill('email', 'student25@example.com');
    await fill('endpoint', endpoint);
    await submit('reset');
  });
}
