import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  static const String baseUrl ='https://crudcrud.com/api/1e6121f8dedf444d8842d7eb4d2362ef'; 

  
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
    return {}; 
  }

  
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
    return {};
  }

 
  static Future<void> saveStudent(Student student) async {
    try {
      final json = jsonEncode(student.toJson());

      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      
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


  static Future<void> saveCourse(Course course) async {
    try {
      final json = jsonEncode(course.toJson());
      print('Request Body: $json'); 

      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: json,
      );

      
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