import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_model.dart';
import '../models/question.dart';
import '../models/test_attempt.dart';
import '../models/student_progress.dart';
import '../services/ai_service.dart';
import '../config/constants.dart';

class TestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AIService _aiService = AIService();

  List<TestModel> _tests = [];
  List<Question> _currentQuestions = [];
  List<TestAttempt> _attempts = [];
  StudentProgress? _progress;
  bool _isLoading = false;
  String? _error;

  List<TestModel> get tests => _tests;
  List<Question> get currentQuestions => _currentQuestions;
  List<TestAttempt> get attempts => _attempts;
  StudentProgress? get progress => _progress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTests(String schoolId, {String? chapterId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      Query query = _firestore
          .collection(AppConstants.testsCollection)
          .where('schoolId', isEqualTo: schoolId)
          .where('isActive', isEqualTo: true);
      if (chapterId != null) {
        query = query.where('chapterId', isEqualTo: chapterId);
      }
      final snapshot = await query.orderBy('createdAt', descending: true).get();
      _tests = snapshot.docs.map((doc) => TestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuestions(String testId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection(AppConstants.questionsCollection)
          .where('testId', isEqualTo: testId)
          .orderBy('order')
          .get();
      _currentQuestions = snapshot.docs.map((doc) => Question.fromMap(doc.data(), doc.id)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Question>> generateAiQuestions({
    required String text,
    required String chapterId,
    required String subjectId,
    required String courseId,
    required String schoolId,
    int count = 10,
  }) async {
    return await _aiService.generateQuestionsFromText(
      text: text,
      chapterId: chapterId,
      subjectId: subjectId,
      courseId: courseId,
      schoolId: schoolId,
      questionCount: count,
    );
  }

  Future<bool> saveAiQuestions(String testId, List<Question> questions) async {
    try {
      final batch = _firestore.batch();
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        final docRef = _firestore.collection(AppConstants.questionsCollection).doc(q.id);
        batch.set(docRef, q.toMap());
      }
      await batch.commit();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> submitTestAttempt(TestAttempt attempt) async {
    try {
      await _firestore
          .collection(AppConstants.testsCollection)
          .doc(attempt.testId)
          .collection('attempts')
          .doc(attempt.id)
          .set(attempt.toMap());

      await _updateProgress(attempt);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _updateProgress(TestAttempt attempt) async {
    final progressId = '${attempt.userId}_${attempt.schoolId}';
    final docRef = _firestore
        .collection(AppConstants.progressCollection)
        .doc(progressId);

    final doc = await docRef.get();
    if (doc.exists) {
      final p = StudentProgress.fromMap(doc.data()!, progressId);
      final newTotal = p.totalQuestionsAnswered + attempt.totalQuestions;
      final newCorrect = p.correctAnswers + attempt.correctAnswers;
      await docRef.update({
        'totalTestsAttempted': FieldValue.increment(1),
        'totalQuestionsAnswered': FieldValue.increment(attempt.totalQuestions),
        'correctAnswers': FieldValue.increment(attempt.correctAnswers),
        'incorrectAnswers': FieldValue.increment(attempt.incorrectAnswers),
        'overallAccuracy': newTotal > 0 ? newCorrect / newTotal : 0,
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    } else {
      final progress = StudentProgress(
        id: progressId,
        userId: attempt.userId,
        schoolId: attempt.schoolId,
        totalTestsAttempted: 1,
        totalQuestionsAnswered: attempt.totalQuestions,
        correctAnswers: attempt.correctAnswers,
        incorrectAnswers: attempt.incorrectAnswers,
        overallAccuracy: attempt.totalQuestions > 0
            ? attempt.correctAnswers / attempt.totalQuestions
            : 0,
      );
      await docRef.set(progress.toMap());
    }
    await loadProgress(attempt.userId, attempt.schoolId);
  }

  Future<void> loadProgress(String userId, String schoolId) async {
    try {
      final progressId = '${userId}_$schoolId';
      final doc = await _firestore
          .collection(AppConstants.progressCollection)
          .doc(progressId)
          .get();
      if (doc.exists) {
        _progress = StudentProgress.fromMap(doc.data()!, progressId);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadAttempts(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.testsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .limit(20)
          .get();
      _attempts = snapshot.docs.map((doc) => TestAttempt.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clear() {
    _tests = [];
    _currentQuestions = [];
    _attempts = [];
    _progress = null;
    _error = null;
    notifyListeners();
  }
}
