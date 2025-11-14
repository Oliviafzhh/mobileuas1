class Student {
  String? id;
  final String nis;
  final String name;
  final String className;
  final String department;
  final String email;
  final String password;

  Student({
    this.id,
    required this.nis,
    required this.name,
    required this.className,
    required this.department,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'name': name,
      'className': className,
      'department': department,
      'email': email,
      'password': password,
    };
  }

  factory Student.fromMap(String id, Map<String, dynamic> map) {
    return Student(
      id: id,
      nis: map['nis'] ?? '',
      name: map['name'] ?? '',
      className: map['className'] ?? '',
      department: map['department'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}