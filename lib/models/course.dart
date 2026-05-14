class Course {
  final String id;
  final String schoolId;
  final String name;
  final String? description;
  final String? imageUrl;
  final String grade;
  final bool isActive;
  final DateTime createdAt;
  final int subjectCount;

  Course({
    required this.id,
    required this.schoolId,
    required this.name,
    this.description,
    this.imageUrl,
    this.grade = '',
    this.isActive = true,
    DateTime? createdAt,
    this.subjectCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'grade': grade,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'subjectCount': subjectCount,
  };

  factory Course.fromMap(Map<String, dynamic> map, String id) => Course(
    id: id,
    schoolId: map['schoolId'] ?? '',
    name: map['name'] ?? '',
    description: map['description'],
    imageUrl: map['imageUrl'],
    grade: map['grade'] ?? '',
    isActive: map['isActive'] ?? true,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    subjectCount: map['subjectCount'] ?? 0,
  );
}
