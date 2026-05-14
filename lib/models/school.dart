class School {
  final String id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String state;
  final String? phone;
  final String? email;
  final String? logoUrl;
  final bool isActive;
  final DateTime createdAt;
  final int studentCount;
  final int teacherCount;

  School({
    required this.id,
    required this.name,
    required this.code,
    this.address = '',
    this.city = '',
    this.state = '',
    this.phone,
    this.email,
    this.logoUrl,
    this.isActive = true,
    DateTime? createdAt,
    this.studentCount = 0,
    this.teacherCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'name': name,
    'code': code,
    'address': address,
    'city': city,
    'state': state,
    'phone': phone,
    'email': email,
    'logoUrl': logoUrl,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'studentCount': studentCount,
    'teacherCount': teacherCount,
  };

  factory School.fromMap(Map<String, dynamic> map, String id) => School(
    id: id,
    name: map['name'] ?? '',
    code: map['code'] ?? '',
    address: map['address'] ?? '',
    city: map['city'] ?? '',
    state: map['state'] ?? '',
    phone: map['phone'],
    email: map['email'],
    logoUrl: map['logoUrl'],
    isActive: map['isActive'] ?? true,
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    studentCount: map['studentCount'] ?? 0,
    teacherCount: map['teacherCount'] ?? 0,
  );
}
