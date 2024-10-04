class Enrollment {
  final String studentId;
  final String courseId;

  Enrollment({required this.studentId, required this.courseId});

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'courseId': courseId,
    };
  }
}
