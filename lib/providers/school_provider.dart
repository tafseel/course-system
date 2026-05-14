import 'package:flutter/foundation.dart';
import '../models/school.dart';
import '../models/course.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../services/firestore_service.dart';

class SchoolProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  School? _currentSchool;
  List<Course> _courses = [];
  List<Subject> _subjects = [];
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _error;

  School? get currentSchool => _currentSchool;
  List<Course> get courses => _courses;
  List<Subject> get subjects => _subjects;
  List<Chapter> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSchool(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentSchool = await _firestoreService.getSchool(schoolId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSchoolByCode(String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentSchool = await _firestoreService.getSchoolByCode(code);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCourses(String schoolId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _courses = await _firestoreService.getCourses(schoolId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSubjects(String schoolId, String courseId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _subjects = await _firestoreService.getSubjects(schoolId, courseId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChapters(String schoolId, String courseId, String subjectId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _chapters = await _firestoreService.getChapters(schoolId, courseId, subjectId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> createCourse(Course course) async {
    final id = await _firestoreService.createCourse(course);
    await loadCourses(course.schoolId);
    return id;
  }

  Future<String> createSubject(Subject subject) async {
    final id = await _firestoreService.createSubject(subject);
    await loadSubjects(subject.schoolId, subject.courseId);
    return id;
  }

  Future<String> createChapter(Chapter chapter) async {
    final id = await _firestoreService.createChapter(chapter);
    await loadChapters(chapter.schoolId, chapter.courseId, chapter.subjectId);
    return id;
  }

  void clear() {
    _currentSchool = null;
    _courses = [];
    _subjects = [];
    _chapters = [];
    _error = null;
    notifyListeners();
  }
}
