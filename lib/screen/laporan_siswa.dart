import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../providers/grade_provider.dart';
import '../models/grade.dart';

class LaporanSiswa extends StatelessWidget {
  final dynamic student;

  const LaporanSiswa({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);
    final studentGrades = gradeProvider.getGradesByStudent(student.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapor Siswa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePdf(context, student, studentGrades),
          ),
        ],
      ),
      body: _buildReportContent(student, studentGrades),
    );
  }

  Widget _buildReportContent(dynamic student, List<Grade> grades) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentInfo(student),
          const SizedBox(height: 24),
          _buildGradeTable(grades),
          const SizedBox(height: 24),
          _buildGradeSummary(grades),
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

  Widget _buildGradeTable(List<Grade> grades) {
    if (grades.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada nilai',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Nilai',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Mata Pelajaran')),
                  DataColumn(label: Text('Tugas')),
                  DataColumn(label: Text('UTS')),
                  DataColumn(label: Text('UAS')),
                  DataColumn(label: Text('Akhir')),
                  DataColumn(label: Text('Predikat')),
                  DataColumn(label: Text('Semester')),
                ],
                rows: grades.map((grade) {
                  return DataRow(cells: [
                    DataCell(Text(grade.subject)),
                    DataCell(Text(grade.assignment.toStringAsFixed(2))),
                    DataCell(Text(grade.midterm.toStringAsFixed(2))),
                    DataCell(Text(grade.finalExam.toStringAsFixed(2))),
                    DataCell(Text(grade.finalGrade.toStringAsFixed(2))),
                    DataCell(
                      Chip(
                        label: Text(
                          grade.gradePredicate,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getGradeColor(grade.gradePredicate),
                      ),
                    ),
                    DataCell(Text(grade.semester)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSummary(List<Grade> grades) {
    if (grades.isEmpty) return const SizedBox();

    final average = grades.map((g) => g.finalGrade).reduce((a, b) => a + b) / grades.length;
    final aCount = grades.where((g) => g.gradePredicate == 'A').length;
    final bCount = grades.where((g) => g.gradePredicate == 'B').length;
    final cCount = grades.where((g) => g.gradePredicate == 'C').length;
    final dCount = grades.where((g) => g.gradePredicate == 'D').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Nilai',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Rata-rata', average.toStringAsFixed(2), Colors.blue),
                _buildSummaryItem('A', '$aCount', Colors.green),
                _buildSummaryItem('B', '$bCount', Colors.blue),
                _buildSummaryItem('C', '$cCount', Colors.orange),
                _buildSummaryItem('D', '$dCount', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
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

  Future<void> _generatePdf(BuildContext context, dynamic student, List<Grade> grades) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'RAPOR SISWA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'SEKOLAH MENENGAH ATAS XYZ',
                  style: pw.TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),

              // Student Info
              pw.Text(
                'DATA SISWA',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                children: [
                  pw.Text('Nama: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(student.name),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('NIS: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(student.nis),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Kelas: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(student.className),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text('Jurusan: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(student.department),
                ],
              ),
              pw.SizedBox(height: 30),

              // Grades Table
              pw.Text(
                'DAFTAR NILAI',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              if (grades.isNotEmpty)
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Mata Pelajaran', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Tugas', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('UTS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('UAS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Akhir', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Predikat', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...grades.map((grade) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.subject),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.assignment.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.midterm.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.finalExam.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.finalGrade.toStringAsFixed(2)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(grade.gradePredicate),
                        ),
                      ],
                    )).toList(),
                  ],
                )
              else
                pw.Text('Belum ada nilai'),

              pw.SizedBox(height: 30),
              pw.Text(
                'Tanggal Cetak: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(fontSize: 12),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}