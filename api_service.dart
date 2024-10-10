import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);


  Future<Map<String, Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return {
        for (var item in jsonData)
          Student.fromJson(item as Map<String, dynamic>).studentId: Student.fromJson(item)
      };
    } else {
      throw Exception('Failed to load students');
    }
  }


  Future<Map<String, Course>> fetchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return {
        for (var item in jsonData)
          Course.fromJson(item as Map<String, dynamic>).courseId: Course.fromJson(item)
      };
    } else {
      throw Exception('Failed to load courses');
    }
  }
Future<void> enrollStudentInCourse(String studentId, String courseId) async {
  final students = await fetchStudents();
  final courses = await fetchCourses();


  if (!students.containsKey(studentId)) {
    throw Exception('Student with ID $studentId does not exist');
  }

  if (!courses.containsKey(courseId)) {
    throw Exception('Course with ID $courseId does not exist');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/students/$studentId/enroll'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'courseId': courseId}),
  );

  if (response.statusCode == 200) {
    print('Student $studentId enrolled in course $courseId successfully.');
  } else {
    throw Exception('Failed to enroll student in course: ${response.body}');
  }
}


  Future<void> dropstudentfromcourse(String studentId, String courseId) async {
  final students = await fetchStudents();
  // ignore: unused_local_variable
  final courses = await fetchCourses();

  if (!students.containsKey(studentId)) {
    throw Exception('Student with ID $studentId does not exist');
  }


  final student = students[studentId];
  if (!student!.enrolledCourses.contains(courseId)) {
    throw Exception('Student is not enrolled in this course');
  }


  final response = await http.delete(
    Uri.parse('$baseUrl/students/$studentId/courses/$courseId'),
  );

  if (response.statusCode == 200) {
    print('Course $courseId dropped for student $studentId successfully.');
  } else {
    throw Exception('Failed to drop course: ${response.body}');
  }
}


  Future<void> updateStudent(String studentId, Map<String, dynamic> updates) async {
  final existingStudents = await fetchStudents();

  if (!existingStudents.containsKey(studentId)) {
    throw Exception('Student with ID $studentId does not exist');
  }


  final response = await http.put(
    Uri.parse('$baseUrl/students/$studentId'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(updates),
  );

  if (response.statusCode == 200) {
    print('Student $studentId updated successfully.');
  } else {
    throw Exception('Failed to update student: ${response.body}');
  }
}




  
  Future<void> updateCourse(String courseId, Course updatedCourse) async {

    final courses = await fetchCourses();
    if (!courses.containsKey(courseId)) {
      throw Exception('Course with ID $courseId does not exist');
    }


    final response = await http.patch(
      Uri.parse('$baseUrl/courses/$courseId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatedCourse.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

 Future<void> saveStudents(Map<String, Student> students) async {
    final existingStudents = await fetchStudents(); 

    for (var student in students.values) {
      if (!existingStudents.containsKey(student.studentId)) {
     
        await createStudent(student);
      }
      
    }
  }

 
  Future<void> saveCourses(Map<String, Course> courses) async {
    final existingCourses = await fetchCourses(); 

    for (var course in courses.values) {
      if (!existingCourses.containsKey(course.courseId)) {
 
        await createCourse(course);
      }
    
    }
  }

  Future<void> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student');
    }
  }

  Future<void> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create course');
    }
  }

Future<void> dropStudent(String studentId) async {
  final existingStudents = await fetchStudents();


  if (!existingStudents.containsKey(studentId)) {
    throw Exception('Student with ID $studentId does not exist');
  }

 
  final response = await http.delete(
    Uri.parse('$baseUrl/students/$studentId'),
  );

  if (response.statusCode == 200) {
    print('Student $studentId dropped successfully.');
  } else {
    throw Exception('Failed to drop student: ${response.body}');
  }
}



  Future<void> dropCourse(String studentId, String courseId) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/students/$studentId/courses/$courseId'),
  );

  if (response.statusCode == 200) {
    print('Course $courseId dropped for student $studentId successfully.');
  } else {
    throw Exception('Failed to drop course: ${response.body}');
  }
}
}