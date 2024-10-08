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
 Future<bool> studentExists(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/students/$id'));

    return response.statusCode == 200; 
  }

 Future<void> createStudent(Student student) async {
    if (await studentExists(student.studentId)) {
      throw Exception('Student already exists');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent(String studentId, Student student) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/students/$studentId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode == 404) {
      throw Exception('Student not found for update');
    } else if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }


  // Delete a student from the API
  Future<void> deleteStudent(String studentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/students/$studentId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete student');
    }
  }

  // Fetch all courses from the API
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

  // Create a new course in the API
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

  // Update a course in the API
  Future<void> updateCourse(String courseId, Course course) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/courses/$courseId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update course');
    }
  }

 
  Future<void> deleteCourse(String courseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$courseId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete course');
    }
  }

  Future<Map<String, Student>> loadStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return {
          for (var item in jsonData)
            Student.fromJson(item as Map<String, dynamic>).studentId: Student.fromJson(item)
        };
      } else {
        print('Failed to load students from API.');
        return {};
      }
    } catch (e) {
      print('Error loading students: $e');
      return {};
    }
  }

  Future<Map<String, Course>> loadCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return {
          for (var item in jsonData)
            Course.fromJson(item as Map<String, dynamic>).courseId: Course.fromJson(item)
        };
      } else {
        print('Failed to load courses from API.');
        return {};
      }
    } catch (e) {
      print('Error loading courses: $e');
      return {};
    }
  }


  Future<void> saveStudents(Map<String, Student> students) async {
    for (var student in students.values) {
      await createStudent(student);
    }
    print('Students saved successfully to API.');
  }

 
  Future<void> saveCourses(Map<String, Course> courses) async {
    for (var course in courses.values) {
      await createCourse(course);
    }
    print('Courses saved successfully to API.');
  }
}

