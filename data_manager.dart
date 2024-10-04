import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class DataManager {
  static const String baseUrl = 'https://crudcrud.com/api/35ccf31f6d574082892652111085b167'; // Replace with your API base URL

  // Load Students
  static Future<Map<String, Student>> loadStudents() async {
    Map<String, Student> students = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var student = Student.fromJson(item as Map<String, dynamic>);
          students[student.studentid] = student; // Ensure you are using a unique field for key
        }
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return students;
  }

  // Load Courses
  static Future<Map<String, Course>> loadCourses() async {
    Map<String, Course> courses = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var course = Course.fromJson(item as Map<String, dynamic>);
          courses[course.courseid] = course; // Ensure courseId is used
        }
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return courses;
  }

  // Save Students
  static Future<void> saveStudents(Map<String, Student> students) async {
    try {
      for (var student in students.values) {
        final response = await http.post(
          Uri.parse('$baseUrl/students'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(student.toJson()),
        );
        if (response.statusCode != 200) {
          print('Failed to save student: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error saving students: $e');
    }
  }

  // Save Courses
  static Future<void> saveCourses(Map<String, Course> courses) async {
    try {
      for (var course in courses.values) {
        final response = await http.post(
          Uri.parse('$baseUrl/courses'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(course.toJson()),
        );
        if (response.statusCode != 200) {
          print('Failed to save course: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error saving courses: $e');
    }
  }
}
