import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Schedule>> getSchedules() {
    return _firestore
        .collection('schedules')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Schedule.fromMap(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Schedule>> getSchedulesByClass(String className) {
    return _firestore
        .collection('schedules')
        .where('className', isEqualTo: className)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Schedule.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addSchedule(Schedule schedule) async {
    await _firestore.collection('schedules').add(schedule.toMap());
  }

  Future<void> updateSchedule(String id, Schedule schedule) async {
    await _firestore.collection('schedules').doc(id).update(schedule.toMap());
  }

  Future<void> deleteSchedule(String id) async {
    await _firestore.collection('schedules').doc(id).delete();
  }
}