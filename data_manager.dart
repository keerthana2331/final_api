import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class DataManager {
  static const String baseUrl = 'https://crudcrud.com/api/5794e6fc3976443681db99a6eb8a2ec2'; // Replace with your API base URL

  static Future<Map<String, Student>> loadStudents() async {
    Map<String, Student> students = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var student = Student.fromJson(item as Map<String, dynamic>);
      students[student.studentId] = student;


        }
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return students;
  }

  static Future<void> saveStudents(Map<String, Student> students) async {
    try {
      final jsonData = students.values.map((e) => e.toJson()).toList();
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      if (response.statusCode != 200) {
        print('Failed to save students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving students: $e');
    }
  }

  static Future<Map<String, Course>> loadCourses() async {
    Map<String, Course> courses = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var course = Course.fromJson(item as Map<String, dynamic>);
          courses[course.courseid] = course;
        }
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return courses;
  }

  static Future<void> saveCourses(Map<String, Course> courses) async {
    try {
      final jsonData = courses.values.map((e) => e.toJson()).toList();
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      if (response.statusCode != 200) {
        print('Failed to save courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving courses: $e');
    }
  }
}


