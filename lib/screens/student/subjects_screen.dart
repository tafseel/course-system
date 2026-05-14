import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/school_provider.dart';
import '../../config/theme.dart';
import '../../models/course.dart';
import '../../models/subject.dart';
import 'chapters_screen.dart';

class SubjectsScreen extends StatefulWidget {
  final Course course;
  const SubjectsScreen({super.key, required this.course});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolProvider>().loadSubjects(
      widget.course.schoolId,
      widget.course.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.course.name)),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.subjects.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.subject, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text('No subjects yet', style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.subjects.length,
                  itemBuilder: (context, index) {
                    return _SubjectCard(
                      subject: provider.subjects[index],
                      course: widget.course,
                    );
                  },
                ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final Course course;
  const _SubjectCard({required this.subject, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChaptersScreen(subject: subject, course: course),
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
                  color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories, color: AppTheme.secondaryColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subject.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    if (subject.chapterCount > 0) ...[
                      const SizedBox(height: 4),
                      Text('${subject.chapterCount} chapters',
                        style: const TextStyle(color: AppTheme.textSecondary)),
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
