import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  static const String baseUrl = 'https://crudcrud.com/api/fd6aa6e720ba46238e0f347e883d0c9b'; // Replace with your API URL

  // Load students from the API
  static Future<Map<String, Student>> loadStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final List<dynamic> data = jsonDecode(response.body);
        Map<String, Student> students = {};
        for (var student in data) {
          students[student['_id']] = Student.fromJson(student);
        }
        return students;
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
        final List<dynamic> data = jsonDecode(response.body);
        Map<String, Course> courses = {};
        for (var course in data) {
          courses[course['_id']] = Course.fromJson(course);
        }
        return courses;
      } else {
        print('Failed to load courses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return {}; // Return an empty map if loading fails or data is null
  }

  // Save a single student to the API
  static Future<void> saveStudent(Student student) async {
    try {
      final json = jsonEncode(student.toJson());

      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      // Check the response from the API
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        print('Failed to save student. Status code: ${response.statusCode}');
      } else {
        print('Student saved successfully.');
      }
    } catch (e) {
      print('Error saving student: $e');
    }
  }

 // Save a single course to the API
  static Future<void> saveCourse(Course course) async {
    try {
      final json = jsonEncode(course.toJson());
      print('Request Body: $json'); // Debugging output

      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      // Log the status code and response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        print('Failed to save course. Status code: ${response.statusCode}');
        print('Error message: ${response.body}');
      } else {
        print('Course saved successfully.');
      }
    } catch (e) {
      print('Error saving course: $e');
    }
  }
}