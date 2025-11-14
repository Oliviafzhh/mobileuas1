import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../providers/teacher_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/announcement_provider.dart';
import 'add_student_screen.dart';
import 'add_teacher_screen.dart';
import 'announcement_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final teacherProvider = Provider.of<TeacherProvider>(context);
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sistem Informasi Akademik',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Selamat datang, Administrator',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
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
                  icon: Icons.people,
                  title: 'Data Siswa',
                  count: studentProvider.students.length,
                  color: Colors.blue,
                  onTap: () {
                    _showStudents(context);
                  },
                ),
                _DashboardCard(
                  icon: Icons.person,
                  title: 'Data Guru',
                  count: teacherProvider.teachers.length,
                  color: Colors.green,
                  onTap: () {
                    _showTeachers(context);
                  },
                ),
                _DashboardCard(
                  icon: Icons.schedule,
                  title: 'Jadwal',
                  count: scheduleProvider.schedules.length,
                  color: Colors.orange,
                  onTap: () {
                    _showSchedules(context);
                  },
                ),
                _DashboardCard(
                  icon: Icons.announcement,
                  title: 'Pengumuman',
                  count: announcementProvider.announcements.length,
                  color: Colors.purple,
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
                  icon: Icons.add,
                  title: 'Tambah Siswa',
                  count: null,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddStudentScreen(),
                      ),
                    );
                  },
                ),
                _DashboardCard(
                  icon: Icons.add,
                  title: 'Tambah Guru',
                  count: null,
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTeacherScreen(),
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

  void _showStudents(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Siswa'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: studentProvider.students.length,
            itemBuilder: (context, index) {
              final student = studentProvider.students[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(student.name[0]),
                ),
                title: Text(student.name),
                subtitle: Text('${student.className} - ${student.department}'),
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

  void _showTeachers(BuildContext context) {
    final teacherProvider = Provider.of<TeacherProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Guru'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: teacherProvider.teachers.length,
            itemBuilder: (context, index) {
              final teacher = teacherProvider.teachers[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(teacher.name[0]),
                ),
                title: Text(teacher.name),
                subtitle: Text(teacher.subject),
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

  void _showSchedules(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jadwal Pelajaran'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: scheduleProvider.schedules.length,
            itemBuilder: (context, index) {
              final schedule = scheduleProvider.schedules[index];
              return ListTile(
                leading: Container(
                  width: 4,
                  height: 40,
                  color: _getDayColor(schedule.day),
                ),
                title: Text(schedule.subject),
                subtitle: Text('${schedule.day} - ${schedule.time}'),
                trailing: Text(schedule.className),
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