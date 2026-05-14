

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;
  final String? schoolId;
  final String? schoolCode;
  final bool isApproved;
  final String? grade;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.schoolId,
    this.schoolCode,
    this.isApproved = false,
    this.grade,
    this.phone,
    this.photoUrl,
    DateTime? createdAt,
    this.lastLogin,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'role': role,
    'schoolId': schoolId,
    'schoolCode': schoolCode,
    'isApproved': isApproved,
    'grade': grade,
    'phone': phone,
    'photoUrl': photoUrl,
    'createdAt': createdAt.toIso8601String(),
    'lastLogin': lastLogin?.toIso8601String(),
  };

  factory AppUser.fromMap(Map<String, dynamic> map, String id) => AppUser(
    uid: id,
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    role: map['role'] ?? 'student',
    schoolId: map['schoolId'],
    schoolCode: map['schoolCode'],
    isApproved: map['isApproved'] ?? false,
    grade: map['grade'],
    phone: map['phone'],
    photoUrl: map['photoUrl'],
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
  );

  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    String? schoolId,
    String? schoolCode,
    bool? isApproved,
    String? grade,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) => AppUser(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    name: name ?? this.name,
    role: role ?? this.role,
    schoolId: schoolId ?? this.schoolId,
    schoolCode: schoolCode ?? this.schoolCode,
    isApproved: isApproved ?? this.isApproved,
    grade: grade ?? this.grade,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    createdAt: createdAt ?? this.createdAt,
    lastLogin: lastLogin ?? this.lastLogin,
  );

  bool get isStudent => role == 'student';
  bool get isTeacher => role == 'teacher';
  bool get isSchoolAdmin => role == 'school_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isAdmin => isSchoolAdmin || isSuperAdmin;
}
