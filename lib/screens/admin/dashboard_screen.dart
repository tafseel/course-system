import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.isSuperAdmin == true ? 'Super Admin' : 'School Admin'),
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
      body: _buildBody(user),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Schools'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Users'),
          NavigationDestination(icon: Icon(Icons.upload_file), label: 'Upload'),
        ],
      ),
    );
  }

  Widget _buildBody(user) {
    switch (_currentIndex) {
      case 0:
        return _AdminDashboard();
      case 1:
        return _ManageSchools();
      case 2:
        return _ManageUsers();
      case 3:
        return _UploadContent();
      default:
        return _AdminDashboard();
    }
  }
}

class _AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
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
                Text('Welcome, ${user?.name ?? 'Admin'}!',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Role: ${user?.role.replaceAll('_', ' ').toUpperCase() ?? 'ADMIN'}',
                  style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(title: 'Schools', value: '0', icon: Icons.school, color: AppTheme.primaryColor)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(title: 'Students', value: '0', icon: Icons.people, color: AppTheme.successColor)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _StatCard(title: 'Teachers', value: '0', icon: Icons.person, color: AppTheme.warningColor)),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(title: 'Courses', value: '0', icon: Icons.menu_book, color: AppTheme.secondaryColor)),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ManageSchools extends StatefulWidget {
  @override
  State<_ManageSchools> createState() => _ManageSchoolsState();
}

class _ManageSchoolsState extends State<_ManageSchools> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _createSchool() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create School'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'School Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: 'School Code'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _nameController.clear();
              _codeController.clear();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('All Schools', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: _createSchool,
              icon: const Icon(Icons.add),
              label: const Text('Add School'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: const Icon(Icons.school, color: AppTheme.primaryColor),
            ),
            title: const Text('Demo School'),
            subtitle: const Text('Code: DEMO001'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ManageUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Users', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Pending Approvals'),
            subtitle: const Text('Students awaiting approval'),
            trailing: const Chip(label: Text('0'), backgroundColor: AppTheme.warningColor),
          ),
        ),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Teachers'),
            subtitle: const Text('Manage teachers'),
            trailing: const Chip(label: Text('0')),
          ),
        ),
      ],
    );
  }
}

class _UploadContent extends StatefulWidget {
  @override
  State<_UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<_UploadContent> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Upload Content', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _UploadCard(
          icon: Icons.picture_as_pdf,
          title: 'Upload PDF',
          subtitle: 'Sample papers, notes, question banks',
          color: AppTheme.errorColor,
        ),
        const SizedBox(height: 12),
        _UploadCard(
          icon: Icons.quiz,
          title: 'Create Test',
          subtitle: 'Chapter-wise or full subject tests',
          color: AppTheme.secondaryColor,
        ),
        const SizedBox(height: 12),
        _UploadCard(
          icon: Icons.menu_book,
          title: 'Add Course',
          subtitle: 'New course, subject, or chapter',
          color: AppTheme.primaryColor,
        ),
      ],
    );
  }
}

class _UploadCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _UploadCard({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.upload_outlined),
        onTap: () {},
      ),
    );
  }
}
