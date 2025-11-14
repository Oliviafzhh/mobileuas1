import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Student>> getStudents() {
    return _firestore
        .collection('students')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Student.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addStudent(Student student) async {
    await _firestore.collection('students').add(student.toMap());
  }

  Future<void> updateStudent(String id, Student student) async {
    await _firestore.collection('students').doc(id).update(student.toMap());
  }

  Future<void> deleteStudent(String id) async {
    await _firestore.collection('students').doc(id).delete();
  }

  Future<Student?> getStudentById(String id) async {
    final doc = await _firestore.collection('students').doc(id).get();
    return doc.exists ? Student.fromMap(doc.id, doc.data()!) : null;
  }
}