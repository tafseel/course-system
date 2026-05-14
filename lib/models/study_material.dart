enum StudyMaterialType { pdf, video, link, document }

class StudyMaterial {
  final String id;
  final String schoolId;
  final String courseId;
  final String subjectId;
  final String chapterId;
  final String title;
  final String? description;
  final StudyMaterialType type;
  final String fileUrl;
  final String? fileName;
  final int fileSize;
  final String uploadedBy;
  final DateTime createdAt;

  StudyMaterial({
    required this.id,
    required this.schoolId,
    required this.courseId,
    required this.subjectId,
    required this.chapterId,
    required this.title,
    this.description,
    this.type = StudyMaterialType.pdf,
    required this.fileUrl,
    this.fileName,
    this.fileSize = 0,
    required this.uploadedBy,
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
    'fileUrl': fileUrl,
    'fileName': fileName,
    'fileSize': fileSize,
    'uploadedBy': uploadedBy,
    'createdAt': createdAt.toIso8601String(),
  };

  factory StudyMaterial.fromMap(Map<String, dynamic> map, String id) => StudyMaterial(
    id: id,
    schoolId: map['schoolId'] ?? '',
    courseId: map['courseId'] ?? '',
    subjectId: map['subjectId'] ?? '',
    chapterId: map['chapterId'] ?? '',
    title: map['title'] ?? '',
    description: map['description'],
    type: StudyMaterialType.values.firstWhere(
      (e) => e.name == map['type'], orElse: () => StudyMaterialType.pdf,
    ),
    fileUrl: map['fileUrl'] ?? '',
    fileName: map['fileName'],
    fileSize: map['fileSize'] ?? 0,
    uploadedBy: map['uploadedBy'] ?? '',
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
  );
}
