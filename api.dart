import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  // Base URLs for students and courses
  static const String studentBaseUrl =
      'https://crudcrud.com/api/3070c18d842c4cfe8d40d58e033cdbb8/students';
  static const String courseBaseUrl =
      'https://crudcrud.com/api/3070c18d842c4cfe8d40d58e033cdbb8/courses';

  // Load all students from the API
  // static Future<Map<String, Student>> loadStudents() async {
  //   try {
  //     final response = await http.get(Uri.parse(studentBaseUrl));

  //     if (response.statusCode == 200 && response.body.isNotEmpty) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       Map<String, Student> students = {};
  //       for (var student in data) {
  //         students[student['_id']] = Student.fromJson(student);
  //       }
  //       return students;
  //     } else {
  //       print('Failed to load students. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error loading students: $e');
  //   }
  //   return {};
  // }
 
  // // Load all courses from the API
  // static Future<Map<String, Course>> loadCourses() async {
  //   try {
  //     final response = await http.get(Uri.parse(courseBaseUrl));

  //     if (response.statusCode == 200 && response.body.isNotEmpty) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       Map<String, Course> courses = {};
  //       for (var course in data) {
  //         courses[course['_id']] = Course.fromJson(course);
  //       }
  //       return courses;
  //     } else {
  //       print('Failed to load courses. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error loading courses: $e');
  //   }
  //   return {};
  // }

  // // Save a student to the API
  // static Future<void> saveStudent(Student student) async {
  //   try {
  //     final jsonBody = jsonEncode(student.toJson());
  //     final response = await http.post(
  //       Uri.parse(studentBaseUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonBody,
  //     );

  //     if (response.statusCode == 201) {
  //       print('Student saved successfully.');
  //     } else {
  //       print('Failed to save student. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error saving student: $e');
  //   }
  // }


  // Load all students from the API
  static Future<Map<String, Student>> loadStudents() async {
    try {
      final response = await http.get(Uri.parse(studentBaseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        Map<String, Student> students = {};
        for (var student in data) {
          students[student['_id']] = Student.fromJson(student);
        }
        return students;
      } else {
        print('Failed to load students. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return {};
  }

  // Save a student to the API
  static Future<void> saveStudent(Student student) async {
    try {
      final jsonBody = jsonEncode(student.toJson());
      final response = await http.post(
        Uri.parse(studentBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print('Student saved successfully.');
      } else {
        print('Failed to save student. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error saving student: $e');
    }
  }

  // Load all courses from the API
  static Future<Map<String, Course>> loadCourses() async {
    try {
      final response = await http.get(Uri.parse(courseBaseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        Map<String, Course> courses = {};
        for (var course in data) {
          courses[course['_id']] = Course.fromJson(course);
        }
        return courses;
      } else {
        print('Failed to load courses. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return {};
  }

  // Save a course to the API
  static Future<void> saveCourse(Course course) async {
    try {
      final jsonBody = jsonEncode(course.toJson());
      final response = await http.post(
        Uri.parse(courseBaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        print('Course saved successfully.');
      } else {
        print('Failed to save course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error saving course: $e');
    }
  }

  // Other methods (update and delete) remain unchanged...
}







  // Update a student in the API
  Future<void> updateStudent(String id, Student student, dynamic studentBaseUrl) async {
    try {
      final jsonBody = jsonEncode(student.toJson());
      final response = await http.put(
        Uri.parse('$studentBaseUrl/$id'), // Use the student ID in the URL
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Student updated successfully.');
      } else {
        print('Failed to update student. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating student: $e');
    }
  }

  // Delete a student from the API
  Future<void> deleteStudent(String id, dynamic studentBaseUrl) async {
    try {
      final response = await http.delete(Uri.parse('$studentBaseUrl/$id'));

      if (response.statusCode == 200) {
        print('Student deleted successfully.');
      } else {
        print('Failed to delete student. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  // // Save a course to the API
  // static Future<void> saveCourse(Course course) async {
  //   try {
  //     final jsonBody = jsonEncode(course.toJson());
  //     final response = await http.post(
  //       Uri.parse(courseBaseUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonBody,
  //     );

  //     if (response.statusCode == 201) {
  //       print('Course saved successfully.');
  //     } else {
  //       print('Failed to save course. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error saving course: $e');
  //   }
  // }

  // Update a course in the API
  Future<void> updateCourse(String id, Course course, dynamic courseBaseUrl) async {
    try {
      final jsonBody = jsonEncode(course.toJson());
      final response = await http.put(
        Uri.parse('$courseBaseUrl/$id'), // Use the course ID in the URL
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Course updated successfully.');
      } else {
        print('Failed to update course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  // Delete a course from the API
  Future<void> deleteCourse(String id, dynamic courseBaseUrl) async {
    try {
      final response = await http.delete(Uri.parse('$courseBaseUrl/$id'));

      if (response.statusCode == 200) {
        print('Course deleted successfully.');
      } else {
        print('Failed to delete course. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

