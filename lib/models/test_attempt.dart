class TestAttempt {
  final String id;
  final String userId;
  final String testId;
  final String schoolId;
  final List<AnswerRecord> answers;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int unanswered;
  final double accuracy;
  final int timeTakenSeconds;
  final DateTime startedAt;
  final DateTime completedAt;

  TestAttempt({
    required this.id,
    required this.userId,
    required this.testId,
    required this.schoolId,
    this.answers = const [],
    this.score = 0,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.unanswered = 0,
    this.accuracy = 0.0,
    this.timeTakenSeconds = 0,
    DateTime? startedAt,
    DateTime? completedAt,
  }) : startedAt = startedAt ?? DateTime.now(),
       completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'testId': testId,
    'schoolId': schoolId,
    'answers': answers.map((a) => a.toMap()).toList(),
    'score': score,
    'totalQuestions': totalQuestions,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
    'unanswered': unanswered,
    'accuracy': accuracy,
    'timeTakenSeconds': timeTakenSeconds,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt.toIso8601String(),
  };

  factory TestAttempt.fromMap(Map<String, dynamic> map, String id) => TestAttempt(
    id: id,
    userId: map['userId'] ?? '',
    testId: map['testId'] ?? '',
    schoolId: map['schoolId'] ?? '',
    answers: (map['answers'] as List?)?.map((a) => AnswerRecord.fromMap(a)).toList() ?? [],
    score: map['score'] ?? 0,
    totalQuestions: map['totalQuestions'] ?? 0,
    correctAnswers: map['correctAnswers'] ?? 0,
    incorrectAnswers: map['incorrectAnswers'] ?? 0,
    unanswered: map['unanswered'] ?? 0,
    accuracy: (map['accuracy'] ?? 0.0).toDouble(),
    timeTakenSeconds: map['timeTakenSeconds'] ?? 0,
    startedAt: map['startedAt'] != null ? DateTime.parse(map['startedAt']) : null,
    completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
  );
}

class AnswerRecord {
  final String questionId;
  final String? selectedAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;

  AnswerRecord({
    required this.questionId,
    this.selectedAnswer,
    this.isCorrect = false,
    this.timeSpentSeconds = 0,
  });

  Map<String, dynamic> toMap() => {
    'questionId': questionId,
    'selectedAnswer': selectedAnswer,
    'isCorrect': isCorrect,
    'timeSpentSeconds': timeSpentSeconds,
  };

  factory AnswerRecord.fromMap(Map<String, dynamic> map) => AnswerRecord(
    questionId: map['questionId'] ?? '',
    selectedAnswer: map['selectedAnswer'],
    isCorrect: map['isCorrect'] ?? false,
    timeSpentSeconds: map['timeSpentSeconds'] ?? 0,
  );
}
