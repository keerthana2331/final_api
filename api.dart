import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  static const String baseUrl = 'https://crudcrud.com/api/2a728d20a9cc4b7f8a88d83ece3ff788'; // Replace with your API URL

  // Load students from the API
  static Future<Map<String, Student>> loadStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data != null && data is Map<String, dynamic>) {
          return data.map((key, value) => MapEntry(key, Student.fromJson(value)));
        }
      } else {
        print('Failed to load students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return {}; // Return an empty map if loading fails or data is null
  }

  // Load courses from the API
  static Future<Map<String, Course>> loadCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        if (data != null && data is Map<String, dynamic>) {
          return data.map((key, value) => MapEntry(key, Course.fromJson(value)));
        }
      } else {
        print('Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return {}; // Return an empty map if loading fails or data is null
  }

  // Save students to the API
  static Future<void> saveStudents(Map<String, Student> students) async {
    try {
      final json = jsonEncode(students.map((key, value) => MapEntry(key, value.toJson())));
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      if (response.statusCode != 201) {
        print('Failed to save students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving students: $e');
    }
  }

  // Save courses to the API
  static Future<void> saveCourses(Map<String, Course> courses) async {
    try {
      final json = jsonEncode(courses.map((key, value) => MapEntry(key, value.toJson())));
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      if (response.statusCode != 201) {
        print('Failed to save courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving courses: $e');
    }
  }
}



