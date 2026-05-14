class SamplePaper {
  final String id;
  final String schoolId;
  final String? courseId;
  final String? subjectId;
  final String title;
  final String? description;
  final String fileUrl;
  final String? fileName;
  final String? year;
  final String uploadedBy;
  final DateTime createdAt;

  SamplePaper({
    required this.id,
    required this.schoolId,
    this.courseId,
    this.subjectId,
    required this.title,
    this.description,
    required this.fileUrl,
    this.fileName,
    this.year,
    required this.uploadedBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'schoolId': schoolId,
    'courseId': courseId,
    'subjectId': subjectId,
    'title': title,
    'description': description,
    'fileUrl': fileUrl,
    'fileName': fileName,
    'year': year,
    'uploadedBy': uploadedBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory SamplePaper.fromMap(Map<String, dynamic> map, String id) => SamplePaper(
    id: id,
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'],
    subjectId: map['subjectId'],
    title: map['title'] ?? '',
    description: map['description'],
    fileUrl: map['fileUrl'] ?? '',
    fileName: map['fileName'],
    year: map['year'],
    uploadedBy: map['uploadedBy'] ?? '',
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
  );
}
