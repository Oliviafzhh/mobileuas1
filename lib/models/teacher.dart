class Teacher {
  String? id;
  final String nip;
  final String name;
  final String subject;
  final String email;
  final String password;

  Teacher({
    this.id,
    required this.nip,
    required this.name,
    required this.subject,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'nip': nip,
      'name': name,
      'subject': subject,
      'email': email,
      'password': password,
    };
  }

  factory Teacher.fromMap(String id, Map<String, dynamic> map) {
    return Teacher(
      id: id,
      nip: map['nip'] ?? '',
      name: map['name'] ?? '',
      subject: map['subject'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}