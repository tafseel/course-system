class StudentProgress {
  final String id;
  final String userId;
  final String schoolId;
  final String? courseId;
  final String? subjectId;
  final String? chapterId;
  final int totalTestsAttempted;
  final int totalQuestionsAnswered;
  final int correctAnswers;
  final int incorrectAnswers;
  final double overallAccuracy;
  final int totalStudyTimeMinutes;
  final List<String> completedChapters;
  final Map<String, double> chapterAccuracy;
  final List<String> weakTopics;
  final List<String> strongTopics;
  final DateTime lastUpdated;

  StudentProgress({
    required this.id,
    required this.userId,
    required this.schoolId,
    this.courseId,
    this.subjectId,
    this.chapterId,
    this.totalTestsAttempted = 0,
    this.totalQuestionsAnswered = 0,
    this.correctAnswers = 0,
    this.incorrectAnswers = 0,
    this.overallAccuracy = 0.0,
    this.totalStudyTimeMinutes = 0,
    this.completedChapters = const [],
    this.chapterAccuracy = const {},
    this.weakTopics = const [],
    this.strongTopics = const [],
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'schoolId': schoolId,
    'courseId': courseId,
    'subjectId': subjectId,
    'chapterId': chapterId,
    'totalTestsAttempted': totalTestsAttempted,
    'totalQuestionsAnswered': totalQuestionsAnswered,
    'correctAnswers': correctAnswers,
    'incorrectAnswers': incorrectAnswers,
    'overallAccuracy': overallAccuracy,
    'totalStudyTimeMinutes': totalStudyTimeMinutes,
    'completedChapters': completedChapters,
    'chapterAccuracy': chapterAccuracy,
    'weakTopics': weakTopics,
    'strongTopics': strongTopics,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory StudentProgress.fromMap(Map<String, dynamic> map, String id) => StudentProgress(
    id: id,
    userId: map['userId'] ?? '',
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'],
    subjectId: map['subjectId'],
    chapterId: map['chapterId'],
    totalTestsAttempted: map['totalTestsAttempted'] ?? 0,
    totalQuestionsAnswered: map['totalQuestionsAnswered'] ?? 0,
    correctAnswers: map['correctAnswers'] ?? 0,
    incorrectAnswers: map['incorrectAnswers'] ?? 0,
    overallAccuracy: (map['overallAccuracy'] ?? 0.0).toDouble(),
    totalStudyTimeMinutes: map['totalStudyTimeMinutes'] ?? 0,
    completedChapters: List<String>.from(map['completedChapters'] ?? []),
    chapterAccuracy: Map<String, double>.from(
      (map['chapterAccuracy'] as Map?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {},
    ),
    weakTopics: List<String>.from(map['weakTopics'] ?? []),
    strongTopics: List<String>.from(map['strongTopics'] ?? []),
    lastUpdated: map['lastUpdated'] != null ? DateTime.parse(map['lastUpdated']) : null,
  );
}
