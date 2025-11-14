import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/student.dart';
import '../models/teacher.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  dynamic _userData;
  String _userRole = '';
  bool _isLoading = false;

  dynamic get userData => _userData;
  String get userRole => _userRole;
  bool get isLoading => _isLoading;

  // Tambahkan getter untuk role checking
  bool get isAdmin => _userRole == 'admin';
  bool get isTeacher => _userRole == 'teacher';
  bool get isStudent => _userRole == 'student';

  // Helper methods untuk akses yang type-safe
  Student? get studentData => isStudent ? _userData as Student : null;
  Teacher? get teacherData => isTeacher ? _userData as Teacher : null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);

    _isLoading = false;
    
    if (result['success']) {
      _userRole = result['role'];
      _userData = result['data'];
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _userData = null;
    _userRole = '';
    notifyListeners();
  }
}