import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical_12/main.dart';

void main() {
  testWidgets('Порожні поля та невалідний endpoint не надсилаються', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.byKey(const Key('submit')));
    await tester.tap(find.byKey(const Key('submit')));
    await tester.pumpAndSettle();
    expect(find.text('Обов’язкове поле'), findsNWidgets(2));
    expect(
      find.text('Введіть https://ваш-піддомен.requestcatcher.com'),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
