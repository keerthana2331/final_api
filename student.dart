

class Student {
    String studentid;
    String name;
    List<String> enrolledcourses;

    Student(this.name, this.studentid, this.enrolledcourses);

    factory Student.fromJson(Map<String, dynamic> json) {
        return Student(
            json['name'],
            json['id'],
            List<String>.from(json['courses']),
        );
    }

    Map<String, dynamic> toJson() {
        return {
            'name': name,
            'id': studentid,
            'courses': enrolledcourses ,
        };
    }
}
