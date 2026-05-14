class Subject {
  final String id;
  final String schoolId;
  final String courseId;
  final String name;
  final String? description;
  final String? iconUrl;
  final bool isActive;
  final DateTime createdAt;
  final int chapterCount;

  Subject({
    required this.id,
    required this.schoolId,
    required this.courseId,
    required this.name,
    this.description,
    this.iconUrl,
    this.isActive = true,
    DateTime? createdAt,
    this.chapterCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'courseId': courseId,
    'name': name,
    'description': description,
    'iconUrl': iconUrl,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'chapterCount': chapterCount,
  };

  factory Subject.fromMap(Map<String, dynamic> map, String id) => Subject(
    id: id,
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'] ?? '',
    name: map['name'] ?? '',
    description: map['description'],
    iconUrl: map['iconUrl'],
    isActive: map['isActive'] ?? true,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    chapterCount: map['chapterCount'] ?? 0,
  );
}
