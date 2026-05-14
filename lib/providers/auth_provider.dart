import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authState.listen((firebaseUser) async {
      if (firebaseUser != null) {
        _user = await _authService.getUserData(firebaseUser.uid);
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
    String? schoolCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        role: role,
        schoolCode: schoolCode,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signInWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<bool> verifySchoolCode(String code) async {
    return await _authService.verifySchoolCode(code);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
