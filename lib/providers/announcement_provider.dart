import 'package:flutter/foundation.dart';
import '../services/announcement_service.dart';
import '../models/announcement.dart';

class AnnouncementProvider with ChangeNotifier {
  final AnnouncementService _announcementService = AnnouncementService();
  List<Announcement> _announcements = [];
  bool _isLoading = false;

  List<Announcement> get announcements => _announcements;
  bool get isLoading => _isLoading;

  AnnouncementProvider() {
    loadAnnouncements();
  }

  void loadAnnouncements() {
    _announcementService.getAnnouncements().listen((announcements) {
      _announcements = announcements;
      notifyListeners();
    });
  }

  Future<void> addAnnouncement(Announcement announcement) async {
    await _announcementService.addAnnouncement(announcement);
  }

  Future<void> updateAnnouncement(String id, Announcement announcement) async {
    await _announcementService.updateAnnouncement(id, announcement);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _announcementService.deleteAnnouncement(id);
  }
}