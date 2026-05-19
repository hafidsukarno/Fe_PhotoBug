import 'package:flutter/material.dart';
import 'package:fe_photobug/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // No scrollbar
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhotoBug',
      debugShowCheckedModeBanner: false,
      scrollBehavior: _NoScrollbarBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scrollbarTheme: const ScrollbarThemeData(
          thumbVisibility: WidgetStatePropertyAll(false),
          trackVisibility: WidgetStatePropertyAll(false),
          thickness: WidgetStatePropertyAll(0),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
