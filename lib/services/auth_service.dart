import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../config/constants.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<firebase_auth.User?> get authState => _auth.authStateChanges();
  firebase_auth.User? get currentUser => _auth.currentUser;

  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
    String? schoolCode,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email, password: password,
    );
    final user = result.user!;

    String? schoolId;
    if (schoolCode != null) {
      final schools = await _firestore
          .collection(AppConstants.schoolsCollection)
          .where('code', isEqualTo: schoolCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
      if (schools.docs.isNotEmpty) {
        schoolId = schools.docs.first.id;
      }
    }

    final appUser = AppUser(
      uid: user.uid,
      email: email,
      name: name,
      role: role,
      schoolId: schoolId,
      schoolCode: schoolCode,
      isApproved: role == AppConstants.superAdminRole,
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(appUser.toMap());

    return appUser;
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email, password: password,
    );
    final user = result.user;
    if (user == null) return null;

    await _firestore.collection(AppConstants.usersCollection).doc(user.uid).update({
      'lastLogin': DateTime.now().toIso8601String(),
    });

    return await getUserData(user.uid);
  }

  Future<AppUser?> getUserData(String uid) async {
    final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.data()!, doc.id);
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<AppUser?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await getUserData(user.uid);
  }

  Future<bool> approveStudent(String uid) async {
    await _firestore.collection(AppConstants.usersCollection).doc(uid).update({
      'isApproved': true,
    });
    return true;
  }

  Future<bool> verifySchoolCode(String code) async {
    final schools = await _firestore
        .collection(AppConstants.schoolsCollection)
        .where('code', isEqualTo: code)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();
    return schools.docs.isNotEmpty;
  }
}
