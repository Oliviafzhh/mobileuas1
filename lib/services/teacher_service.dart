import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Teacher>> getTeachers() {
    return _firestore
        .collection('teachers')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Teacher.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addTeacher(Teacher teacher) async {
    await _firestore.collection('teachers').add(teacher.toMap());
  }

  Future<void> updateTeacher(String id, Teacher teacher) async {
    await _firestore.collection('teachers').doc(id).update(teacher.toMap());
  }

  Future<void> deleteTeacher(String id) async {
    await _firestore.collection('teachers').doc(id).delete();
  }

  Future<Teacher?> getTeacherById(String id) async {
    final doc = await _firestore.collection('teachers').doc(id).get();
    return doc.exists ? Teacher.fromMap(doc.id, doc.data()!) : null;
  }
}