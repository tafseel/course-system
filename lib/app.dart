import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'screens/student/home_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!auth.isLoggedIn) {
          return const LoginScreen();
        }
        final user = auth.user;
        if (user == null) {
          return const LoginScreen();
        }
        if (user.isAdmin) {
          return const AdminDashboardScreen();
        }
        return const StudentHomeScreen();
      },
    );
  }
}
