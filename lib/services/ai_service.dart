import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

const String _apiKey = 'YOUR_GEMINI_API_KEY';

class AIService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String _model = 'gemini-2.0-flash';

  Future<String> _generateContent(String prompt) async {
    final url = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{'parts': [{'text': prompt}]}],
        'generationConfig': {
          'temperature': 0.2,
          'maxOutputTokens': 4096,
        },
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
    }
    throw Exception('AI API error: ${response.statusCode}');
  }

  Future<List<Question>> generateQuestionsFromText({
    required String text,
    required String chapterId,
    required String subjectId,
    required String courseId,
    required String schoolId,
    int questionCount = 10,
  }) async {
    final prompt = '''
You are an educational AI. Based on the following study content, generate $questionCount multiple-choice questions (MCQs).

For each question, provide:
- The question text
- 4 answer options (A, B, C, D)
- The correct answer
- A brief explanation
- A difficulty level (1-5)
- A topic tag

Format as JSON array:
[{
  "text": "question",
  "options": ["A", "B", "C", "D"],
  "correctAnswer": "A",
  "explanation": "why this is correct",
  "difficulty": 3,
  "topicTag": "topic name"
}]

Content:
$text
''';

    final response = await _generateContent(prompt);
    final cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();

    List<dynamic> questionsJson;
    try {
      questionsJson = jsonDecode(cleaned) as List<dynamic>;
    } catch (_) {
      final start = cleaned.indexOf('[');
      final end = cleaned.lastIndexOf(']') + 1;
      questionsJson = jsonDecode(cleaned.substring(start, end)) as List<dynamic>;
    }

    return questionsJson.asMap().entries.map((entry) {
      final q = entry.value as Map<String, dynamic>;
      return Question(
        id: '${chapterId}_q${entry.key}_${DateTime.now().millisecondsSinceEpoch}',
        schoolId: schoolId,
        courseId: courseId,
        subjectId: subjectId,
        chapterId: chapterId,
        text: q['text'] ?? '',
        options: List<String>.from(q['options'] ?? []),
        correctAnswer: q['correctAnswer'] ?? '',
        explanation: q['explanation'],
        topicTag: q['topicTag'],
        difficulty: q['difficulty'] ?? 1,
        isAiGenerated: true,
      );
    }).toList();
  }

  Future<String> explainDoubt(String question, String context) async {
    final prompt = '''
You are an educational tutor. Explain the following doubt in simple, clear terms.

Context: $context
Question: $question

Provide a helpful explanation with examples if applicable.
''';
    return await _generateContent(prompt);
  }

  Future<List<String>> suggestWeakTopics(List<String> mistakes) async {
    final prompt = '''
Based on the following list of topics where a student made mistakes, suggest 3-5 topics they should focus on improving.
Return as a JSON array of strings.

Mistakes: ${mistakes.join(', ')}
''';
    final response = await _generateContent(prompt);
    final cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();
    try {
      return List<String>.from(jsonDecode(cleaned));
    } catch (_) {
      return mistakes;
    }
  }

  Future<String> summarizePdf(String pdfText) async {
    final prompt = '''
Summarize the following educational content. Extract:
1. Main topics covered
2. Key concepts
3. Important definitions/formulas
4. Practice questions (if any)

Content:
$pdfText
''';
    return await _generateContent(prompt);
  }
}
