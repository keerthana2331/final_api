import 'dart:convert';
import 'dart:io';
import 'student.dart';
import 'course.dart'; 

class DataManager {
  static Map<String, Student> loadStudents() {
    Map<String, Student> students = {};
    try {
      final file = File('students.json');
      if (file.existsSync()) {
        final contents = file.readAsStringSync();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        for (var item in jsonData) {
          var student = Student.fromJson(item as Map<String, dynamic>);
          students[student.studentId] = student;
        }
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return students;
  }

  static void saveStudents(Map<String, Student> students) {
    try {
      final file = File('students.json');
      final jsonData = students.values.map((e) => e.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving students: $e');
    }
  }

  static Map<String, Course> loadCourses() {
    Map<String, Course> courses = {};
    try {
      final file = File('courses.json');
      if (file.existsSync()) {
        final contents = file.readAsStringSync();
        final jsonData = jsonDecode(contents) as List<dynamic>;
        for (var item in jsonData) {
          var course = Course.fromJson(item as Map<String, dynamic>);
          courses[course.courseId] = course;
        }
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return courses;
  }

  static void saveCourses(Map<String, Course> courses) {
    try {
      final file = File('courses.json');
      final jsonData = courses.values.map((e) => e.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving courses: $e');
    }
  }
}
