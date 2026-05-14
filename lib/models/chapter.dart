class Chapter {
  final String id;
  final String schoolId;
  final String courseId;
  final String subjectId;
  final String name;
  final String? description;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final int materialCount;
  final int questionCount;

  Chapter({
    required this.id,
    required this.schoolId,
    required this.courseId,
    required this.subjectId,
    required this.name,
    this.description,
    this.order = 0,
    this.isActive = true,
    DateTime? createdAt,
    this.materialCount = 0,
    this.questionCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'courseId': courseId,
    'subjectId': subjectId,
    'name': name,
    'description': description,
    'order': order,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'materialCount': materialCount,
    'questionCount': questionCount,
  };

  factory Chapter.fromMap(Map<String, dynamic> map, String id) => Chapter(
    id: id,
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'] ?? '',
    subjectId: map['subjectId'] ?? '',
    name: map['name'] ?? '',
    description: map['description'],
    order: map['order'] ?? 0,
    isActive: map['isActive'] ?? true,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    materialCount: map['materialCount'] ?? 0,
    questionCount: map['questionCount'] ?? 0,
  );
}
