import 'dart:convert';
import 'package:http/http.dart' as http;
import 'student.dart';
import 'course.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, Student>> fetchStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      print('Fetching students from: ${Uri.parse('$baseUrl/students')}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return {
          for (var item in jsonData)
            Student.fromJson(item as Map<String, dynamic>).studentId:
                Student.fromJson(item)
        };
      } else if (response.statusCode == 404) {
        print('Students endpoint not found. Returning empty map.');
        return {};
      } else {
        throw Exception(
            'Failed to load students: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching students: $e');
      return {};
    }
  }

  Future<Map<String, Course>> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      print('Fetching courses from: ${Uri.parse('$baseUrl/courses')}');
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return {
          for (var item in jsonData)
            Course.fromJson(item as Map<String, dynamic>).courseId:
                Course.fromJson(item)
        };
      } else if (response.statusCode == 404) {
        print('Courses endpoint not found. Returning empty map.');
        return {};
      } else {
        throw Exception(
            'Failed to load courses: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching courses: $e');
      return {};
    }
  }

  Future<void> enrollStudentInCourse(String studentId, String courseId) async {
    try {
      final students = await fetchStudents();
      final courses = await fetchCourses();

      if (!students.containsKey(studentId)) {
        throw Exception('Student with ID $studentId does not exist');
      }
      if (!courses.containsKey(courseId)) {
        throw Exception('Course with ID $courseId does not exist');
      }

      final student = students[studentId]!;
      final course = courses[courseId]!;

      if (student.enrolledCourses.contains(courseId)) {
        throw Exception('Student is already enrolled in this course');
      }

      student.enrolledCourses.add(courseId);
      course.enrolledStudents.add(studentId);

      await updateStudent(studentId, student);
      await updateCourse(courseId, course);
    } catch (e) {
      throw Exception('Error enrolling student in course: $e');
    }
  }

  Future<void> updateStudent(String studentId, Student updatedStudent) async {
    try {
      final url = Uri.parse('$baseUrl/students/$studentId');
      print('Updating student at: $url');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedStudent.toJson()),
      );

      if (response.statusCode == 200) {
        print('Student updated successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Student with ID $studentId not found in the API');
      } else {
        throw Exception(
            'Failed to update student: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating student: $e');
    }
  }

  Future<void> updateCourse(String courseId, Course updatedCourse) async {
    try {
      final url = Uri.parse('$baseUrl/courses/$courseId');
      print('Updating course at: $url');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedCourse.toJson()),
      );

      if (response.statusCode == 200) {
        print('Course updated successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Course with ID $courseId not found in the API');
      } else {
        throw Exception(
            'Failed to update course: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  Future<void> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create student: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating student: $e');
    }
  }

  Future<void> createCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
            'Failed to create course: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      final students = await fetchStudents();
      if (!students.containsKey(studentId)) {
        throw Exception('Student with ID $studentId does not exist');
      }

      final student = students[studentId]!;
      final courses = await fetchCourses();

      // Remove student from all enrolled courses
      for (var courseId in student.enrolledCourses) {
        if (courses.containsKey(courseId)) {
          var course = courses[courseId]!;
          course.enrolledStudents.remove(studentId);
          await updateCourse(courseId, course);
        }
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/students/$studentId'),
      );

      if (response.statusCode != 204) {
        throw Exception(
            'Failed to delete student: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting student: $e');
    }
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      final courses = await fetchCourses();
      if (!courses.containsKey(courseId)) {
        throw Exception('Course with ID $courseId does not exist');
      }

      final course = courses[courseId]!;
      final students = await fetchStudents();

     
      for (var studentId in course.enrolledStudents) {
        if (students.containsKey(studentId)) {
          var student = students[studentId]!;
          student.enrolledCourses.remove(courseId);
          await updateStudent(studentId, student);
        }
      }

   
      final response = await http.delete(
        Uri.parse('$baseUrl/courses/$courseId'),
      );

      if (response.statusCode != 204) {
        throw Exception(
            'Failed to delete course: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }
}