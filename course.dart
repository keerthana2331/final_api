
class Course {
  String courseid;
  String title;
  String instructorName;
  List<String> enrolledStudents;

  Course(this.courseid, this.title, this.instructorName, [this.enrolledStudents = const []]);

  // Convert a Course object into a Map object
  Map<String, dynamic> toJson() => {
        'id': courseid,
        'title': title,
        'instructorName': instructorName,
        'enrolledStudents': enrolledStudents,
      };

  // Convert a Map object into a Course object
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json['id'] as String,
      json['title'] as String,
      json['instructorName'] as String,
      (json['enrolledStudents'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
