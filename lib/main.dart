import 'package:flutter/material.dart';

import 'auth_screen.dart';
import 'ui.dart';
import 'app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => CourseApp(
    title: 'Практична 12',
    theme: buildAppTheme(),
    home: const AuthScreen(),
  );
}
