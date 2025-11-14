import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';
import '../models/teacher.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Check in students collection
      var studentQuery = await _firestore
          .collection('students')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (studentQuery.docs.isNotEmpty) {
        var studentDoc = studentQuery.docs.first;
        return {
          'success': true,
          'role': 'student',
          'data': Student.fromMap(studentDoc.id, studentDoc.data()),
        };
      }

      // Check in teachers collection
      var teacherQuery = await _firestore
          .collection('teachers')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (teacherQuery.docs.isNotEmpty) {
        var teacherDoc = teacherQuery.docs.first;
        return {
          'success': true,
          'role': 'teacher',
          'data': Teacher.fromMap(teacherDoc.id, teacherDoc.data()),
        };
      }

      // Check admin (hardcoded for simplicity)
      if (email == 'admin@school.com' && password == 'admin123') {
        return {
          'success': true,
          'role': 'admin',
          'data': {'name': 'Administrator'},
        };
      }

      return {'success': false, 'message': 'Email atau password salah'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}