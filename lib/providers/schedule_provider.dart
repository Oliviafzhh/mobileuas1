import 'package:flutter/foundation.dart';
import '../services/schedule_service.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  final ScheduleService _scheduleService = ScheduleService();
  List<Schedule> _schedules = [];
  bool _isLoading = false;

  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;

  ScheduleProvider() {
    loadSchedules();
  }

  void loadSchedules() {
    _scheduleService.getSchedules().listen((schedules) {
      _schedules = schedules;
      notifyListeners();
    });
  }

  Future<void> addSchedule(Schedule schedule) async {
    await _scheduleService.addSchedule(schedule);
  }

  Future<void> updateSchedule(String id, Schedule schedule) async {
    await _scheduleService.updateSchedule(id, schedule);
  }

  Future<void> deleteSchedule(String id) async {
    await _scheduleService.deleteSchedule(id);
  }
}