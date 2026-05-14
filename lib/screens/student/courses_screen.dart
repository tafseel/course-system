import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/school_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../models/course.dart';
import 'subjects_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
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
    final provider = context.watch<SchoolProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.courses.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text('No courses available', style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    return _CourseCard(course: provider.courses[index]);
                  },
                ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.successColor,
      AppTheme.warningColor,
    ];
    final color = colors[course.name.hashCode % colors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubjectsScreen(course: course),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.book, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    if (course.grade.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('Grade: ${course.grade}',
                        style: const TextStyle(color: AppTheme.textSecondary)),
                    ],
                    if (course.subjectCount > 0) ...[
                      const SizedBox(height: 2),
                      Text('${course.subjectCount} subjects',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
