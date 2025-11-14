import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/grade_provider.dart';
import '../providers/student_provider.dart';
import '../providers/announcement_provider.dart';
import '../models/grade.dart';
import 'announcement_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final teacher = authProvider.userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: _TeacherContent(teacher: teacher),
    );
  }
}

class _TeacherContent extends StatelessWidget {
  final dynamic teacher;

  const _TeacherContent({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);
    final studentProvider = Provider.of<StudentProvider>(context);
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

    final teacherGrades = gradeProvider.getGradesByTeacher(teacher.id);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeacherInfo(teacher),
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
                  icon: Icons.grade,
                  title: 'Input Nilai',
                  count: null,
                  color: Colors.blue,
                  onTap: () {
                    _showInputGradeDialog(context, studentProvider.students, teacher);
                  },
                ),
                _DashboardCard(
                  icon: Icons.assignment,
                  title: 'Nilai Saya',
                  count: teacherGrades.length,
                  color: Colors.green,
                  onTap: () {
                    _showMyGrades(context, teacherGrades);
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
                  icon: Icons.people,
                  title: 'Data Siswa',
                  count: studentProvider.students.length,
                  color: Colors.purple,
                  onTap: () {
                    _showStudents(context, studentProvider.students);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo(dynamic teacher) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green[100],
              child: Text(
                teacher.name[0].toUpperCase(),
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
                    teacher.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIP: ${teacher.nip}'),
                  Text('Mata Pelajaran: ${teacher.subject}'),
                  Text('Email: ${teacher.email}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputGradeDialog(BuildContext context, List students, dynamic teacher) {
    showDialog(
      context: context,
      builder: (context) => _InputGradeDialog(students: students, teacher: teacher),
    );
  }

  void _showMyGrades(BuildContext context, List grades) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nilai yang Diinput'),
        content: SizedBox(
          width: double.maxFinite,
          child: grades.isEmpty
              ? const Center(child: Text('Belum ada nilai yang diinput'))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: grades.length,
                  itemBuilder: (context, index) {
                    final grade = grades[index];
                    return ListTile(
                      title: Text(grade.studentName),
                      subtitle: Text('${grade.subject} - ${grade.semester}'),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            grade.finalGrade.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            label: Text(
                              grade.gradePredicate,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: _getGradeColor(grade.gradePredicate),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
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

  void _showStudents(BuildContext context, List students) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Siswa'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
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

class _InputGradeDialog extends StatefulWidget {
  final List students;
  final dynamic teacher;

  const _InputGradeDialog({
    Key? key,
    required this.students,
    required this.teacher,
  }) : super(key: key);

  @override
  __InputGradeDialogState createState() => __InputGradeDialogState();
}

class __InputGradeDialogState extends State<_InputGradeDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStudentId;
  String? _selectedSubject;
  String? _selectedSemester;
  final _assignmentController = TextEditingController();
  final _midtermController = TextEditingController();
  final _finalExamController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context, listen: false);

    return AlertDialog(
      title: const Text('Input Nilai Siswa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedStudentId,
                decoration: const InputDecoration(
                  labelText: 'Pilih Siswa',
                  border: OutlineInputBorder(),
                ),
                items: widget.students.map<DropdownMenuItem<String>>((student) {
                  return DropdownMenuItem<String>(
                    value: student.id,
                    child: Text('${student.name} - ${student.className}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStudentId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih siswa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Mata Pelajaran',
                  border: OutlineInputBorder(),
                ),
                items: ['Matematika', 'Fisika', 'Kimia', 'Biologi', 'Bahasa Indonesia', 'Bahasa Inggris']
                    .map<DropdownMenuItem<String>>((subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih mata pelajaran';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSemester,
                decoration: const InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(),
                ),
                items: ['Ganjil 2024/2025', 'Genap 2024/2025', 'Ganjil 2025/2026', 'Genap 2025/2026']
                    .map<DropdownMenuItem<String>>((semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih semester';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _assignmentController,
                decoration: const InputDecoration(
                  labelText: 'Nilai Tugas (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai tugas';
                  }
                  final numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue < 0 || numericValue > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _midtermController,
                decoration: const InputDecoration(
                  labelText: 'Nilai UTS (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai UTS';
                  }
                  final numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue < 0 || numericValue > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _finalExamController,
                decoration: const InputDecoration(
                  labelText: 'Nilai UAS (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai UAS';
                  }
                  final numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue < 0 || numericValue > 100) {
                    return 'Nilai harus antara 0-100';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final selectedStudent = widget.students.firstWhere(
                (student) => student.id == _selectedStudentId,
              );

              final grade = Grade(
                studentId: _selectedStudentId!,
                studentName: selectedStudent.name,
                teacherId: widget.teacher.id,
                teacherName: widget.teacher.name,
                subject: _selectedSubject!,
                assignment: double.parse(_assignmentController.text),
                midterm: double.parse(_midtermController.text),
                finalExam: double.parse(_finalExamController.text),
                semester: _selectedSemester!,
              );

              await gradeProvider.addGrade(grade);

              // Clear form
              _assignmentController.clear();
              _midtermController.clear();
              _finalExamController.clear();
              setState(() {
                _selectedStudentId = null;
                _selectedSubject = null;
                _selectedSemester = null;
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Nilai berhasil disimpan'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _assignmentController.dispose();
    _midtermController.dispose();
    _finalExamController.dispose();
    super.dispose();
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