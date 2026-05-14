enum TestType { quickTest, chapterTest, samplePaper, questionPaper, mockTest }

class TestModel {
  final String id;
  final String schoolId;
  final String? courseId;
  final String? subjectId;
  final String? chapterId;
  final String title;
  final String? description;
  final TestType type;
  final int totalQuestions;
  final int durationMinutes;
  final int passingScore;
  final bool isActive;
  final String createdBy;
  final DateTime createdAt;

  TestModel({
    required this.id,
    required this.schoolId,
    this.courseId,
    this.subjectId,
    this.chapterId,
    required this.title,
    this.description,
    this.type = TestType.quickTest,
    this.totalQuestions = 0,
    this.durationMinutes = 30,
    this.passingScore = 40,
    this.isActive = true,
    required this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'courseId': courseId,
    'subjectId': subjectId,
    'chapterId': chapterId,
    'title': title,
    'description': description,
    'type': type.name,
    'totalQuestions': totalQuestions,
    'durationMinutes': durationMinutes,
    'passingScore': passingScore,
    'isActive': isActive,
    'createdBy': createdBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory TestModel.fromMap(Map<String, dynamic> map, String id) => TestModel(
    id: id,
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'],
    subjectId: map['subjectId'],
    chapterId: map['chapterId'],
    title: map['title'] ?? '',
    description: map['description'],
    type: TestType.values.firstWhere(
      (e) => e.name == map['type'], orElse: () => TestType.quickTest,
    ),
    totalQuestions: map['totalQuestions'] ?? 0,
    durationMinutes: map['durationMinutes'] ?? 30,
    passingScore: map['passingScore'] ?? 40,
    isActive: map['isActive'] ?? true,
    createdBy: map['createdBy'] ?? '',
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
  );
}
