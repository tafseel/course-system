import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/school_provider.dart';
import '../../config/theme.dart';

import '../auth/login_screen.dart';
import 'courses_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _currentIndex = 0;

  final _screens = const [
    _DashboardTab(),
    _CoursesTab(),
    _TestsTab(),
    _ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user?.schoolId != null) {
      context.read<SchoolProvider>().loadCourses(user!.schoolId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), label: 'Tests'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final schoolProvider = context.watch<SchoolProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (user?.schoolId != null) {
            await schoolProvider.loadCourses(user!.schoolId!);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _WelcomeCard(userName: user?.name ?? 'Student'),
            const SizedBox(height: 16),
            _QuickStatsCard(
              courseCount: schoolProvider.courses.length,
            ),
            const SizedBox(height: 16),
            _QuickActions(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final String userName;
  const _WelcomeCard({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $userName!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Continue your learning journey',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsCard extends StatelessWidget {
  final int courseCount;
  const _QuickStatsCard({required this.courseCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(icon: Icons.menu_book, label: 'Courses', value: '$courseCount'),
            _StatItem(icon: Icons.quiz, label: 'Tests', value: '--'),
            _StatItem(icon: Icons.trending_up, label: 'Accuracy', value: '--%'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _StatItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionCard(
          icon: Icons.download,
          title: 'Study Materials',
          subtitle: 'Browse PDFs and notes',
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoursesScreen())),
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.quiz,
          title: 'Quick Test',
          subtitle: 'Take AI-generated quizzes',
          color: AppTheme.secondaryColor,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _ActionCard(
          icon: Icons.analytics,
          title: 'My Progress',
          subtitle: 'Track your performance',
          color: AppTheme.successColor,
          onTap: () {},
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (color ?? AppTheme.primaryColor).withValues(alpha: 0.1),
          child: Icon(icon, color: color ?? AppTheme.primaryColor),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _CoursesTab extends StatelessWidget {
  const _CoursesTab();

  @override
  Widget build(BuildContext context) {
    return const CoursesScreen();
  }
}

class _TestsTab extends StatelessWidget {
  const _TestsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tests')),
      body: const Center(child: Text('Test history and available tests')),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(user?.name ?? 'Student', textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(user?.email ?? '', textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Chip(
            label: Text(user?.role.replaceAll('_', ' ').toUpperCase() ?? 'STUDENT'),
            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('School Code'),
            subtitle: Text(user?.schoolCode ?? 'N/A'),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Status'),
            subtitle: Text(user?.isApproved == true ? 'Approved' : 'Pending Approval'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
          ),
        ],
      ),
    );
  }
}
