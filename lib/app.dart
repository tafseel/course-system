import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'screens/student/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const StudentHomeScreen(),
    );
  }
}
