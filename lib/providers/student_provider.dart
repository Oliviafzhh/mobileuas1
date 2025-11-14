import 'package:flutter/foundation.dart';
import '../services/student_service.dart';
import '../models/student.dart';

class StudentProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  List<Student> _students = [];
  bool _isLoading = false;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;

  StudentProvider() {
    loadStudents();
  }

  void loadStudents() {
    _studentService.getStudents().listen((students) {
      _students = students;
      notifyListeners();
    });
  }

  Future<void> addStudent(Student student) async {
    await _studentService.addStudent(student);
  }

  Future<void> updateStudent(String id, Student student) async {
    await _studentService.updateStudent(id, student);
  }

  Future<void> deleteStudent(String id) async {
    await _studentService.deleteStudent(id);
  }
}