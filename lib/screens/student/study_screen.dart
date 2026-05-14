import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/course.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';

class StudyScreen extends StatelessWidget {
  final Chapter chapter;
  final Subject subject;
  final Course course;
  const StudyScreen({super.key, required this.chapter, required this.subject, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chapter.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.description, color: AppTheme.primaryColor, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chapter.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('${subject.name} - ${course.name}', style: const TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (chapter.description != null && chapter.description!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(chapter.description!, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Study Materials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _MaterialCard(
            icon: Icons.picture_as_pdf,
            title: 'Chapter Notes',
            subtitle: 'Comprehensive study notes',
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 8),
          _MaterialCard(
            icon: Icons.video_library,
            title: 'Video Lectures',
            subtitle: 'Recorded video explanations',
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          _MaterialCard(
            icon: Icons.assignment,
            title: 'Practice Questions',
            subtitle: 'Chapter-wise practice problems',
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.quiz),
              label: const Text('Take Quick Test'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _MaterialCard({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.download_outlined),
        onTap: () {},
      ),
    );
  }
}
