@Tags(['visual'])
library;

import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practical_12/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // У flutter test початково підставляється технічний шрифт Ahem.
    // Завантажуємо справжні Flutter-шрифти для читабельного знімка.
    final config = File('.dart_tool/package_config.json').absolute;
    final packages =
        jsonDecode(await config.readAsString())['packages'] as List<dynamic>;
    final entry = packages.firstWhere((dynamic p) => p['name'] == 'flutter');
    final sdk = Directory.fromUri(
      config.uri.resolve(entry['rootUri'] as String),
    ).parent.parent.path;
    final fonts = '$sdk/bin/cache/artifacts/material_fonts';
    final roboto = FontLoader('Roboto');
    for (final name in [
      'roboto-regular.ttf',
      'roboto-medium.ttf',
      'roboto-bold.ttf',
    ]) {
      roboto.addFont(
        File(
          '$fonts/$name',
        ).readAsBytes().then((bytes) => bytes.buffer.asByteData()),
      );
    }
    await roboto.load();
    final icons = FontLoader('MaterialIcons');
    icons.addFont(
      File(
        '$fonts/materialicons-regular.otf',
      ).readAsBytes().then((bytes) => bytes.buffer.asByteData()),
    );
    await icons.load();
  });
  testWidgets('Екран телефону 390×844 без помилок компонування', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const key = Key('capture');
    await tester.pumpWidget(RepaintBoundary(key: key, child: const MyApp()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(key),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      await Directory('screenshots').create(recursive: true);
      await File(
        'screenshots/initial.png',
      ).writeAsBytes(data!.buffer.asUint8List());
      image.dispose();
    });
  });
}
