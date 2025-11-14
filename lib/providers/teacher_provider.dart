import 'package:flutter/foundation.dart';
import '../services/teacher_service.dart';
import '../models/teacher.dart';

class TeacherProvider with ChangeNotifier {
  final TeacherService _teacherService = TeacherService();
  List<Teacher> _teachers = [];
  bool _isLoading = false;

  List<Teacher> get teachers => _teachers;
  bool get isLoading => _isLoading;

  TeacherProvider() {
    loadTeachers();
  }

  void loadTeachers() {
    _teacherService.getTeachers().listen((teachers) {
      _teachers = teachers;
      notifyListeners();
    });
  }

  Future<void> addTeacher(Teacher teacher) async {
    await _teacherService.addTeacher(teacher);
  }

  Future<void> updateTeacher(String id, Teacher teacher) async {
    await _teacherService.updateTeacher(id, teacher);
  }

  Future<void> deleteTeacher(String id) async {
    await _teacherService.deleteTeacher(id);
  }
}