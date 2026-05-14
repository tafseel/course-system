import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/constants.dart';
import '../models/app_user.dart';
import '../models/school.dart';
import '../models/course.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../models/study_material.dart';
import '../models/sample_paper.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Schools
  Future<School?> getSchool(String id) async {
    final doc = await _firestore.collection(AppConstants.schoolsCollection).doc(id).get();
    if (!doc.exists) return null;
    return School.fromMap(doc.data()!, doc.id);
  }

  Future<School?> getSchoolByCode(String code) async {
    final schools = await _firestore
        .collection(AppConstants.schoolsCollection)
        .where('code', isEqualTo: code)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();
    if (schools.docs.isEmpty) return null;
    return School.fromMap(schools.docs.first.data(), schools.docs.first.id);
  }

  Future<List<School>> getAllSchools() async {
    final snapshot = await _firestore.collection(AppConstants.schoolsCollection).get();
    return snapshot.docs.map((doc) => School.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> createSchool(School school) async {
    final doc = await _firestore.collection(AppConstants.schoolsCollection).add(school.toMap());
    return doc.id;
  }

  Future<void> updateSchool(String id, Map<String, dynamic> data) async {
    await _firestore.collection(AppConstants.schoolsCollection).doc(id).update(data);
  }

  // Courses
  Future<List<Course>> getCourses(String schoolId) async {
    final snapshot = await _firestore
        .collection(AppConstants.coursesCollection)
        .where('schoolId', isEqualTo: schoolId)
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => Course.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> createCourse(Course course) async {
    final doc = await _firestore.collection(AppConstants.coursesCollection).add(course.toMap());
    return doc.id;
  }

  // Subjects
  Future<List<Subject>> getSubjects(String schoolId, String courseId) async {
    final snapshot = await _firestore
        .collection(AppConstants.subjectsCollection)
        .where('schoolId', isEqualTo: schoolId)
        .where('courseId', isEqualTo: courseId)
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .get();
    return snapshot.docs.map((doc) => Subject.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> createSubject(Subject subject) async {
    final doc = await _firestore.collection(AppConstants.subjectsCollection).add(subject.toMap());
    return doc.id;
  }

  // Chapters
  Future<List<Chapter>> getChapters(String schoolId, String courseId, String subjectId) async {
    final snapshot = await _firestore
        .collection(AppConstants.chaptersCollection)
        .where('schoolId', isEqualTo: schoolId)
        .where('courseId', isEqualTo: courseId)
        .where('subjectId', isEqualTo: subjectId)
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs.map((doc) => Chapter.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> createChapter(Chapter chapter) async {
    final doc = await _firestore.collection(AppConstants.chaptersCollection).add(chapter.toMap());
    return doc.id;
  }

  // Study Materials
  Future<List<StudyMaterial>> getStudyMaterials(String chapterId) async {
    final snapshot = await _firestore
        .collection(AppConstants.materialsCollection)
        .where('chapterId', isEqualTo: chapterId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => StudyMaterial.fromMap(doc.data(), doc.id)).toList();
  }

  Future<String> uploadMaterial(StudyMaterial material) async {
    final doc = await _firestore.collection(AppConstants.materialsCollection).add(material.toMap());
    return doc.id;
  }

  // Sample Papers
  Future<List<SamplePaper>> getSamplePapers(String schoolId, {String? subjectId}) async {
    Query query = _firestore
        .collection(AppConstants.samplePapersCollection)
        .where('schoolId', isEqualTo: schoolId);
    if (subjectId != null) {
      query = query.where('subjectId', isEqualTo: subjectId);
    }
    final snapshot = await query.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => SamplePaper.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<String> uploadSamplePaper(SamplePaper paper) async {
    final doc = await _firestore.collection(AppConstants.samplePapersCollection).add(paper.toMap());
    return doc.id;
  }

  // Users by school
  Future<List<AppUser>> getUsersBySchool(String schoolId, {String? role}) async {
    Query query = _firestore
        .collection(AppConstants.usersCollection)
        .where('schoolId', isEqualTo: schoolId);
    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }
}
