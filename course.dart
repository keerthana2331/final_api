class Course {
  String id;
  String title;
  String instructorName;
  List<String> enrolledStudents;

  Course(this.id, this.title, this.instructorName, this.enrolledStudents);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'instructorName': instructorName,
      'enrolledStudents': enrolledStudents,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json['id'],
      json['title'],
      json['instructorName'],
      List<String>.from(json['enrolledStudents']),
    );
  }
}
