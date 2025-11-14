class Schedule {
  String? id;
  final String day;
  final String time;
  final String subject;
  final String teacherId;
  final String teacherName;
  final String className;

  Schedule({
    this.id,
    required this.day,
    required this.time,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.className,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'time': time,
      'subject': subject,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'className': className,
    };
  }

  factory Schedule.fromMap(String id, Map<String, dynamic> map) {
    return Schedule(
      id: id,
      day: map['day'] ?? '',
      time: map['time'] ?? '',
      subject: map['subject'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? '',
      className: map['className'] ?? '',
    );
  }
}