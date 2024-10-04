class Student {
  String studentId;
  String name;
  List<String> enrolledCourses;

  Student({
    required this.studentId,
    required this.name,
    required this.enrolledCourses,
  });

  
  bool isEnrolledInCourse(String courseId) {
    return enrolledCourses.contains(courseId);
  }


  void enrollInCourse(String courseId) {
    if (!isEnrolledInCourse(courseId)) {
      enrolledCourses.add(courseId);
    } else {
      print('Error: Student $name is already enrolled in course $courseId.');
    }
  }

  
  void dropCourse(String courseId) {
    enrolledCourses.remove(courseId);
  }

 
  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'enrolledCourses': enrolledCourses,
    };
  }

 
  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      name: json['name'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
    );
  }
}
