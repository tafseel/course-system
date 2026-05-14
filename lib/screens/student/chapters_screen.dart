import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/school_provider.dart';
import '../../config/theme.dart';
import '../../models/course.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';
import 'study_screen.dart';
import 'test_screen.dart';

class ChaptersScreen extends StatefulWidget {
  final Subject subject;
  final Course course;
  const ChaptersScreen({super.key, required this.subject, required this.course});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolProvider>().loadChapters(
      widget.course.schoolId,
      widget.course.id,
      widget.subject.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SchoolProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.chapters.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chrome_reader_mode, size: 64, color: AppTheme.textSecondary),
                      SizedBox(height: 16),
                      Text('No chapters yet', style: TextStyle(color: AppTheme.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.chapters.length,
                  itemBuilder: (context, index) {
                    return _ChapterCard(
                      chapter: provider.chapters[index],
                      subject: widget.subject,
                      course: widget.course,
                    );
                  },
                ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final Subject subject;
  final Course course;
  const _ChapterCard({required this.chapter, required this.subject, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('${chapter.order + 1}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.successColor)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(chapter.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      if (chapter.questionCount > 0)
                        Text('${chapter.questionCount} questions',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.menu_book, size: 18),
                  label: const Text('Study'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyScreen(chapter: chapter, subject: subject, course: course),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.quiz, size: 18),
                  label: const Text('Quick Test'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestScreen(chapter: chapter, subject: subject, course: course),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
