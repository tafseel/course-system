import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';
import '../../config/theme.dart';
import '../../models/course.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';
import '../../models/question.dart';

class TestScreen extends StatefulWidget {
  final Chapter chapter;
  final Subject subject;
  final Course course;
  const TestScreen({super.key, required this.chapter, required this.subject, required this.course});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<String?> _answers = [];
  List<Question> _questions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTest();
  }

  Future<void> _loadTest() async {
    setState(() => _isLoading = true);
    final testProvider = context.read<TestProvider>();
    await testProvider.loadTests(widget.course.schoolId, chapterId: widget.chapter.id);
    if (testProvider.tests.isNotEmpty) {
      await testProvider.loadQuestions(testProvider.tests.first.id);
      _questions = testProvider.currentQuestions;
    }
    if (_questions.isEmpty) {
      _questions = List.generate(5, (i) => Question(
        id: 'demo_$i',
        text: 'Sample question ${i + 1} about ${widget.chapter.name}?',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctAnswer: 'Option A',
        chapterId: widget.chapter.id,
        subjectId: widget.subject.id,
        courseId: widget.course.id,
        schoolId: widget.course.schoolId,
      ));
    }
    _answers.addAll(List.filled(_questions.length, null));
    setState(() => _isLoading = false);
  }

  void _submitTest() {
    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctAnswer) correct++;
    }
    final score = (correct / _questions.length * 100).round();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Test Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Score: $score%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: score >= 40 ? AppTheme.successColor : AppTheme.errorColor)),
            const SizedBox(height: 8),
            Text('$correct / ${_questions.length} correct'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quick Test')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quick Test')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length + 1,
        itemBuilder: (context, index) {
          if (index == _questions.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _answers.contains(null) ? null : _submitTest,
                  child: const Text('Submit Test'),
                ),
              ),
            );
          }
          final question = _questions[index];
          return _QuestionCard(
            question: question,
            index: index,
            selectedAnswer: _answers[index],
            onAnswerSelected: (answer) {
              setState(() => _answers[index] = answer);
            },
          );
        },
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int index;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;
  const _QuestionCard({required this.question, required this.index, this.selectedAnswer, required this.onAnswerSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                const SizedBox(width: 8),
                if (question.topicTag != null)
                  Chip(
                    label: Text(question.topicTag!, style: const TextStyle(fontSize: 11)),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(question.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            ...question.options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onAnswerSelected(option),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selectedAnswer == option ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedAnswer == option ? AppTheme.primaryColor : AppTheme.borderColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (v) => onAnswerSelected(option),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(option)),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
