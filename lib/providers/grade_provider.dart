import 'package:flutter/foundation.dart';
import '../services/grade_service.dart';
import '../models/grade.dart';

class GradeProvider with ChangeNotifier {
  final GradeService _gradeService = GradeService();
  List<Grade> _grades = [];
  bool _isLoading = false;

  List<Grade> get grades => _grades;
  bool get isLoading => _isLoading;

  GradeProvider() {
    loadGrades();
  }

  void loadGrades() {
    _gradeService.getAllGrades().listen((grades) {
      _grades = grades;
      notifyListeners();
    });
  }

  Future<void> addGrade(Grade grade) async {
    await _gradeService.addGrade(grade);
  }

  Future<void> updateGrade(String id, Grade grade) async {
    await _gradeService.updateGrade(id, grade);
  }

  Future<void> deleteGrade(String id) async {
    await _gradeService.deleteGrade(id);
  }

  List<Grade> getGradesByStudent(String studentId) {
    return _grades.where((grade) => grade.studentId == studentId).toList();
  }

  List<Grade> getGradesByTeacher(String teacherId) {
    return _grades.where((grade) => grade.teacherId == teacherId).toList();
  }
}