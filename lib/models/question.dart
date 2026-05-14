enum QuestionType { mcq, trueFalse, shortAnswer, longAnswer, fillInBlank }

class Question {
  final String id;
  final String? testId;
  final String? schoolId;
  final String? courseId;
  final String? subjectId;
  final String? chapterId;
  final String text;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final String? topicTag;
  final int difficulty;
  final int order;
  final bool isAiGenerated;
  final DateTime createdAt;

  Question({
    required this.id,
    this.testId,
    this.schoolId,
    this.courseId,
    this.subjectId,
    this.chapterId,
    required this.text,
    this.type = QuestionType.mcq,
    this.options = const [],
    required this.correctAnswer,
    this.explanation,
    this.topicTag,
    this.difficulty = 1,
    this.order = 0,
    this.isAiGenerated = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    if (testId != null) 'testId': testId,
    if (schoolId != null) 'schoolId': schoolId,
    if (courseId != null) 'courseId': courseId,
    if (subjectId != null) 'subjectId': subjectId,
    if (chapterId != null) 'chapterId': chapterId,
    'text': text,
    'type': type.name,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'topicTag': topicTag,
    'difficulty': difficulty,
    'order': order,
    'isAiGenerated': isAiGenerated,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Question.fromMap(Map<String, dynamic> map, String id) => Question(
    id: id,
    testId: map['testId'],
    schoolId: map['schoolId'],
    courseId: map['courseId'],
    subjectId: map['subjectId'],
    chapterId: map['chapterId'],
    text: map['text'] ?? '',
    type: QuestionType.values.firstWhere(
      (e) => e.name == map['type'], orElse: () => QuestionType.mcq,
    ),
    options: List<String>.from(map['options'] ?? []),
    correctAnswer: map['correctAnswer'] ?? '',
    explanation: map['explanation'],
    topicTag: map['topicTag'],
    difficulty: map['difficulty'] ?? 1,
    order: map['order'] ?? 0,
    isAiGenerated: map['isAiGenerated'] ?? false,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
  );
}
