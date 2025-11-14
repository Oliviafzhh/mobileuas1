class Grade {
  String? id;
  final String studentId;
  final String studentName;
  final String teacherId;
  final String teacherName;
  final String subject;
  final double assignment;
  final double midterm;
  final double finalExam;
  final String semester;

  Grade({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.assignment,
    required this.midterm,
    required this.finalExam,
    required this.semester,
  });

  double get finalGrade {
    return (assignment * 0.3) + (midterm * 0.3) + (finalExam * 0.4);
  }

  String get gradePredicate {
    final grade = finalGrade;
    if (grade >= 85) return 'A';
    if (grade >= 75) return 'B';
    if (grade >= 65) return 'C';
    return 'D';
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'subject': subject,
      'assignment': assignment,
      'midterm': midterm,
      'finalExam': finalExam,
      'semester': semester,
      'finalGrade': finalGrade,
      'gradePredicate': gradePredicate,
    };
  }

  factory Grade.fromMap(String id, Map<String, dynamic> map) {
    return Grade(
      id: id,
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? '',
      subject: map['subject'] ?? '',
      assignment: (map['assignment'] as num).toDouble(),
      midterm: (map['midterm'] as num).toDouble(),
      finalExam: (map['finalExam'] as num).toDouble(),
      semester: map['semester'] ?? '',
    );
  }
}