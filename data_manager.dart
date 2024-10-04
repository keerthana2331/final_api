import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'main.dart'; 

class DataManager {
  static const String baseUrl = 'https://crudcrud.com/api/50e72191875a48c9ac64d217e779cbd1';
static Future<Map<String, Student>> loadStudents() async {
  Map<String, Student> students = {};
  try {
    print('Attempting to load students...'); // Debugging print
    final response = await http.get(Uri.parse('$baseUrl/students'));
    
    if (response.statusCode == 200) {
      print('Students loaded successfully.'); // Debugging print
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      for (var item in jsonData) {
        var student = Student.fromJson(item as Map<String, dynamic>);
        students[student.studentId] = student;
      }
    } else {
      print('Failed to load students: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging the actual response
    }
  } catch (e) {
    print('Error loading students: $e');
  }
  return students;
}


  static Future<void> saveStudent(Student student) async {
  try {
    print('Attempting to save student...'); // Debugging print

    // Check if student ID and name are valid
    if (student.studentId.isEmpty || student.name.isEmpty) {
      print('Student ID and name cannot be empty.');
      return;
    }

    // Load existing students to check for duplicates
    final existingStudents = await loadStudents();

    // Check if the student already exists
    if (existingStudents.containsKey(student.studentId)) {
      // Update the existing student's enrolled courses
      var existingStudent = existingStudents[student.studentId];
      existingStudent?.enrolledCourses.addAll(student.enrolledCourses);
      existingStudent?.enrolledCourses = existingStudent.enrolledCourses.toSet().toList(); // Remove duplicates in courses
      // Update the student in the API
      final response = await http.put(
        Uri.parse('$baseUrl/students/${student.studentId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(existingStudent.toString()), // Ensure to use the updated existing student
      );
      if (response.statusCode == 200) {
        print('Student updated successfully.');
      } else {
        print('Failed to update student: ${response.statusCode}');
      }
    } else {
      // Student doesn't exist, create a new student
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode == 201) {
        print('Student saved successfully.');
      } else {
        print('Failed to save student: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error saving student: ${e.toString()}');
  }
}


  static Future<void> saveCourse(Course course) async {
  try {
    print('Attempting to save course...'); // Debugging print
    
    if (course.courseId.isEmpty || course.courseTitle.isEmpty) {
      print('Course ID and title cannot be empty.');
      return;
    }

    final existingCourses = await loadCourses();
    if (existingCourses.containsKey(course.courseId)) {
      print('Updating course...'); // Debugging print
      final response = await http.put(
        Uri.parse('$baseUrl/courses/${course.courseId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );
      if (response.statusCode == 200) {
        print('Course updated successfully.');
      } else {
        print('Failed to update course: ${response.statusCode}');
      }
    } else {
      print('Creating new course...'); // Debugging print
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );
      if (response.statusCode == 201) {
        print('Course saved successfully.');
      } else {
        print('Failed to save course: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error saving course: ${e.toString()}');
  }
}
static Future<Map<String, Course>> loadCourses() async {
  Map<String, Course> courses = {};
  try {
    print('Attempting to load courses...'); // Debugging print
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    
    if (response.statusCode == 200) {
      print('Courses loaded successfully.'); // Debugging print
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      for (var item in jsonData) {
        var course = Course.fromJson(item as Map<String, dynamic>);
        courses[course.courseId] = course;
      }
    } else {
      print('Failed to load courses: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debugging the actual response
    }
  } catch (e) {
    print('Error loading courses: $e');
  }
  return courses;
}
}