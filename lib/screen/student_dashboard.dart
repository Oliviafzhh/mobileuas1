import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/grade_provider.dart';
import '../providers/announcement_provider.dart';
import 'laporan_siswa.dart';
import 'announcement_screen.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final student = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: _StudentContent(student: student),
    );
  }
}

class _StudentContent extends StatelessWidget {
  final dynamic student;

  const _StudentContent({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final gradeProvider = Provider.of<GradeProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

    final studentSchedules = scheduleProvider.schedules
        .where((schedule) => schedule.className == student.className)
        .toList();

    final studentGrades = gradeProvider.getGradesByStudent(student.id);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentInfo(student),
          const SizedBox(height: 24),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              children: [
                _DashboardCard(
                  icon: Icons.schedule,
                  title: 'Jadwal',
                  count: studentSchedules.length,
                  color: Colors.blue,
                  onTap: () {
                    _showSchedules(context, studentSchedules);
                  },
                ),
                _DashboardCard(
                  icon: Icons.grade,
                  title: 'Nilai',
                  count: studentGrades.length,
                  color: Colors.green,
                  onTap: () {
                    _showGrades(context, studentGrades);
                  },
                ),
                _DashboardCard(
                  icon: Icons.announcement,
                  title: 'Pengumuman',
                  count: announcementProvider.announcements.length,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnnouncementScreen(),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.assignment,
                  title: 'Rapor',
                  count: null,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanSiswa(student: student),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInfo(dynamic student) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue[100],
              child: Text(
                student.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIS: ${student.nis}'),
                  Text('Kelas: ${student.className}'),
                  Text('Jurusan: ${student.department}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSchedules(BuildContext context, List schedules) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jadwal Pelajaran'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                leading: Container(
                  width: 4,
                  height: 40,
                  color: _getDayColor(schedule.day),
                ),
                title: Text(schedule.subject),
                subtitle: Text('Guru: ${schedule.teacherName}'),
                trailing: Text('${schedule.time}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showGrades(BuildContext context, List grades) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nilai'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final grade = grades[index];
              return ListTile(
                title: Text(grade.subject),
                subtitle: Text('Nilai Akhir: ${grade.finalGrade.toStringAsFixed(2)}'),
                trailing: Chip(
                  label: Text(
                    grade.gradePredicate,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getGradeColor(grade.gradePredicate),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Color _getDayColor(String day) {
    switch (day) {
      case 'Senin': return Colors.blue;
      case 'Selasa': return Colors.green;
      case 'Rabu': return Colors.orange;
      case 'Kamis': return Colors.purple;
      case 'Jumat': return Colors.red;
      case 'Sabtu': return Colors.brown;
      default: return Colors.grey;
    }
  }

  Color _getGradeColor(String predicate) {
    switch (predicate) {
      case 'A': return Colors.green;
      case 'B': return Colors.blue;
      case 'C': return Colors.orange;
      case 'D': return Colors.red;
      default: return Colors.grey;
    }
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? count;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (count != null) ...[
                const SizedBox(height: 4),
                Text(
                  '$count Data',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}