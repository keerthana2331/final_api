import 'student.dart';
import 'course.dart';
import 'api_service.dart';
import 'utils.dart';

Future<void> main() async {
  final apiService =
      ApiService('https://crudcrud.com/api/90d7aacb30bc4ac885092b26b9d6d563');

  bool running = true;

  while (running) {
    print('\nStudent Course Enrollment System');
    print('1. Create Student');
    print('2. Create Course');
    print('3. Enroll Student in Course');
    print('4. View Student Schedule');
    print('5. View Course Roster');
    print('6. Drop Course');
    print('7. Drop Student');
    print('8. Update Student');
    print('9. Update Course');
    print('10. Exit');
    print(
        '11. View Student Balance (if applicable)'); // Add this option if applicable

    String choice = readInput('Choose an option', validChoices: [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11'
    ]);

    try {
      switch (choice) {
        case '1':
          await createStudent(apiService);
          break;
        case '2':
          await createCourse(apiService);
          break;
        case '3':
          await enrollStudentInCourse(apiService);
          break;
        case '4':
          await viewStudentSchedule(apiService);
          break;
        case '5':
          await viewCourseRoster(apiService);
          break;
        case '6':
          await dropCourse(apiService);
          break;
        case '7':
          await dropStudent(apiService);
          break;
        case '8':
          await updateStudent(apiService);
          break;
        case '9':
          await updateCourse(apiService);
          break;
        case '10':
          running = false;
          print('Goodbye!');
          break;

        default:
          print('Invalid choice. Please try again.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}

Future<void> createStudent(ApiService apiService) async {
  String name = readInput('Enter student name');
  String studentId = readInput('Enter student ID');

  Student newStudent = Student(name, studentId, []);
  await apiService.createStudent(newStudent);
  print('Student added successfully.');
}

Future<void> createCourse(ApiService apiService) async {
  String courseTitle = readInput('Enter course title');
  String courseId = readInput('Enter course ID');
  String instructorName = readInput('Enter instructor name');

  Course newCourse = Course(courseId, courseTitle, instructorName, []);
  await apiService.createCourse(newCourse);
  print('Course added successfully.');
}

Future<void> enrollStudentInCourse(ApiService apiService) async {
  String studentId = readInput('Enter student ID');
  String courseId = readInput('Enter course ID');
  // Check if student exists before enrolling
  final students = await apiService.fetchStudents();
  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  await apiService.enrollStudentInCourse(studentId, courseId);
  print('Student enrolled in course successfully.');
}

Future<void> viewStudentSchedule(ApiService apiService) async {
  String studentId = readInput('Enter student ID');

  final students = await apiService.fetchStudents();

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  if (student.enrolledCourses.isEmpty) {
    print('Student is not enrolled in any courses.');
  } else {
    print('Student Schedule:');
    final courses = await apiService.fetchCourses();
    for (var courseId in student.enrolledCourses) {
      print(
          '- Course ID: $courseId, Course Title: ${courses[courseId]?.courseTitle ?? 'Unknown'}');
    }
  }
}

// ... (other methods remain the same)

Future<void> viewCourseRoster(ApiService apiService) async {
  String courseId = readInput('Enter course ID');

  final courses = await apiService.fetchCourses();

  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;
  if (course.enrolledStudents.isEmpty) {
    print('No students are enrolled in this course.');
  } else {
    print('Course Roster:');
    final students = await apiService.fetchStudents();
    for (var studentId in course.enrolledStudents) {
      print(
          '- Student ID: $studentId, Name: ${students[studentId]?.name ?? 'Unknown'}');
    }
  }
}

Future<void> dropCourse(ApiService apiService) async {
  String studentId = readInput('Enter student ID');
  String courseId = readInput('Enter course ID');

  await apiService.dropStudentFromCourse(studentId, courseId);
  print('Course dropped successfully.');
}

extension on ApiService {
  dropStudentFromCourse(String studentId, String courseId) {}
}

Future<void> dropStudent(ApiService apiService) async {
  String studentId = readInput('Enter student ID');

  await apiService.deleteStudent(studentId);
  print(
      'Student dropped successfully from all courses and removed from the system.');
}

Future<void> updateStudent(ApiService apiService) async {
  String studentId = readInput('Enter student ID');

  final students = await apiService.fetchStudents();
  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  String newName = readInput('Enter new student name');

  Student updatedStudent =
      Student(newName, studentId, students[studentId]!.enrolledCourses);
  await apiService.updateStudent(studentId, updatedStudent);
  print('Student updated successfully.');
}

Future<void> updateCourse(ApiService apiService) async {
  String courseId = readInput('Enter course ID');

  final courses = await apiService.fetchCourses();
  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  String newTitle = readInput('Enter new course title');
  String newInstructor = readInput('Enter new instructor name');

  Course updatedCourse = Course(
      courseId, newTitle, newInstructor, courses[courseId]!.enrolledStudents);
  await apiService.updateCourse(courseId, updatedCourse);
  print('Course updated successfully.');
}
