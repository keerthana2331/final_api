import 'student.dart';

class Course {
    String courseid;
    String name;
    String instructorName;
    List<String> enrolledStudents;


    Course(this.name, this.courseid,this.instructorName,this.enrolledStudents);

    factory Course.fromJson(Map<String, dynamic> json) {
        return Course(
            json['name'],
            json['id'],
            json['instructorname'],
             List<String>.from(json['students']),

        );
    }

    Map<String, dynamic> toJson() {
        return {
            'name': name,
            'id': courseid,
            'instructorname':instructorName,
            'Student': enrolledStudents
        };
    }
}