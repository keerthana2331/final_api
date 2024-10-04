

class Student {
  String studentId;
  String id;
  List<String> enrolledCourses;

  Student(this.studentId, this.id, [this.enrolledCourses = const []]);

  // Convert a Student object into a Map object
  Map<String, dynamic> toJson() => {
        'name': studentId,
        'id': id,
        'enrolledCourses': enrolledCourses,
      };

  // Convert a Map object into a Student object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      json['name'] as String,
      json['id'] as String,
      (json['enrolledCourses'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
}
