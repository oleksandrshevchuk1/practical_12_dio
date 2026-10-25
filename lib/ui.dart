import 'package:flutter/material.dart';

/// Кожна практична має власну копію цього невеликого оформлення.
class CourseApp extends StatelessWidget {
  const CourseApp({
    super.key,
    required this.title,
    required this.home,
    this.theme,
  });
  final String title;
  final Widget home;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme:
        theme ??
        ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff335e88)),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
    home: home,
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children, this.width = 640});
  final List<Widget> children;
  final double width;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in children) ...[
                child,
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
