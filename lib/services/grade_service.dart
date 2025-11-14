import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade.dart';

class GradeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Grade>> getGradesByStudent(String studentId) {
    return _firestore
        .collection('grades')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Grade.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Grade>> getGradesByTeacher(String teacherId) {
    return _firestore
        .collection('grades')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Grade.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addGrade(Grade grade) async {
    await _firestore.collection('grades').add(grade.toMap());
  }

  Future<void> updateGrade(String id, Grade grade) async {
    await _firestore.collection('grades').doc(id).update(grade.toMap());
  }

  Future<void> deleteGrade(String id) async {
    await _firestore.collection('grades').doc(id).delete();
  }

  Stream<List<Grade>> getAllGrades() {
    return _firestore
        .collection('grades')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Grade.fromMap(doc.id, doc.data()))
            .toList());
  }
}