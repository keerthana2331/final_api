
import 'student.dart';
import 'course.dart';
import 'api_service.dart';
import 'utils.dart';

Future<void> main() async {
  final apiService = ApiService('https://crudcrud.com/api/8ed332d4e5574fd6b50436c8f4da2962');
  

  final students = await apiService.fetchStudents();
  final courses = await apiService.fetchCourses();

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
    
    String choice = readInput('Choose an option', validChoices: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);

    switch (choice) {
      case '1':
        await createStudent(apiService, students, courses);
        break;
      case '2':
        await createCourse(apiService, courses);
        break;
      case '3':
        await enrollStudentInCourse(apiService, students,courses);
        break;
      case '4':
        await viewStudentSchedule(students, courses);
        break;
      case '5':
        await viewCourseRoster(courses, students);
        break;
      case '6':
        await dropCourse(apiService, students, courses);
        break;
      case '7':
        await dropStudent(apiService, students, courses);
        break;
      case '8':
        await updateStudent(apiService, students);
        break;
      case '9':
        await updateCourse(apiService, courses);
        break;
      case '10':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.');
    }

    if (choice != '9') {
      await saveData(apiService, students, courses);
    }
  }
}

Future<void> saveData(ApiService apiService, Map<String, Student> students, Map<String, Course> courses) async {
  await apiService.saveStudents(students);
  await apiService.saveCourses(courses);
  print('Data saved successfully.');
}

Future<void> createStudent(ApiService apiService, Map<String, Student> students, Map<String, Course> courses) async {
  String name = readInput('Enter student name');
  String studentId = readInput('Enter student ID', isUnique: true, existingIds: students.keys.toList());

  printAvailableCourses(courses);

  String coursesInput = readInput('Enter course IDs the student is enrolled in (comma-separated)', isOptional: true);
  List<String> selectedCourses = coursesInput.isNotEmpty
      ? coursesInput.split(',').map((e) => e.trim()).toList()
      : [];

  List<String> validCourses = [];
  for (var courseId in selectedCourses) {
    if (courses.containsKey(courseId)) {
      validCourses.add(courseId);
    } else {
      print('Course ID $courseId does not exist and will be ignored.');
    }
  }

  students[studentId] = Student(name, studentId, validCourses);
  print('Student added successfully.');
}

Future<void> createCourse(ApiService apiService, Map<String, Course> courses) async {
  String courseTitle = readInput('Enter course title');
  String courseId = readInput('Enter course ID', isUnique: true, existingIds: courses.keys.toList());
  String instructorName = readInput('Enter instructor name');
  String studentsInput = readInput('Enter student IDs enrolled in the course (comma-separated)', isOptional: true);
  List<String> enrolledStudents = studentsInput.isNotEmpty
      ? studentsInput.split(',').map((e) => e.trim()).toList()
      : [];

  courses[courseId] = Course(courseId, courseTitle, instructorName, enrolledStudents);
  print('Course added successfully.');
}

Future<void> enrollStudentInCourse(ApiService apiService, Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID', existingIds: students.keys.toList());
  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  String courseId = readInput('Enter course ID', existingIds: courses.keys.toList());
  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  Course course = courses[courseId]!;

  if (student.enrolledCourses.contains(courseId)) {
    print('Student is already enrolled in this course.');
  } else {
    student.enrolledCourses.add(courseId);
    course.enrolledStudents.add(studentId);
    print('Student enrolled in course successfully.');
  }
}

Future<void> viewStudentSchedule(Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID', existingIds: students.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  if (student.enrolledCourses.isEmpty) {
    print('Student is not enrolled in any courses.');
  } else {
    print('Student Schedule:');
    for (var courseId in student.enrolledCourses) {
      print('- Course ID: $courseId, Course Title: ${courses[courseId]?.courseTitle ?? 'Unknown'}');
    }
  }
}

Future<void> viewCourseRoster(Map<String, Course> courses, Map<String, Student> students) async {
  String courseId = readInput('Enter course ID', existingIds: courses.keys.toList());

  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;
  if (course.enrolledStudents.isEmpty) {
    print('No students are enrolled in this course.');
  } else {
    print('Course Roster:');
    for (var studentId in course.enrolledStudents) {
      print('- Student ID: $studentId, Name: ${students[studentId]?.name ?? 'Unknown'}');
    }
  }
}

Future<void> dropCourse(ApiService apiService, Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID', existingIds: students.keys.toList());
  String courseId = readInput('Enter course ID', existingIds: courses.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }
  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  Course course = courses[courseId]!;

  if (student.enrolledCourses.contains(courseId)) {
    student.enrolledCourses.remove(courseId);
    course.enrolledStudents.remove(studentId);
    print('Course dropped successfully.');
  } else {
    print('Student is not enrolled in this course.');
  }
}

Future<void> dropStudent(ApiService apiService, Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID', existingIds: students.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student? student = students[studentId];

  if (student == null) {
    print('Student not found.');
    return;
  }

  for (String courseId in student.enrolledCourses) {
    Course course = courses[courseId]!;
    course.enrolledStudents.remove(studentId);
  }

  students.remove(studentId);

  print('Student dropped successfully from all courses and removed from the system.');
}

Future<void> updateStudent(ApiService apiService, Map<String, Student> students) async {
  String studentId = readInput('Enter student ID', existingIds: students.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;

  String newName = readInput('Enter new student name');
  String newCoursesInput = readInput('Enter new course IDs the student is enrolled in (comma-separated)', isOptional: true);
  List<String> newCourses = newCoursesInput.isNotEmpty
      ? newCoursesInput.split(',').map((e) => e.trim()).toList()
      : [];

  student.name = newName;
  student.enrolledCourses = newCourses;

  print('Student updated successfully.');
}

Future<void> updateCourse(ApiService apiService, Map<String, Course> courses) async {
  String courseId = readInput('Enter course ID', existingIds: courses.keys.toList());

  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;

  String newTitle = readInput('Enter new course title');
  String newInstructor = readInput('Enter new instructor name');
  String newStudentsInput = readInput('Enter new student IDs enrolled in the course (comma-separated)', isOptional: true);
  List<String> newStudents = newStudentsInput.isNotEmpty
      ? newStudentsInput.split(',').map((e) => e.trim()).toList()
      : [];

  course.courseTitle = newTitle;
  course.instructorName = newInstructor;
  course.enrolledStudents = newStudents;

  print('Course updated successfully.');
}


void printAvailableCourses(Map<String, Course> courses) {
  if (courses.isEmpty) {
    print('No available courses at this time.');
  } else {
    print('Available Courses:');
    for (var course in courses.values) {
      print('- Course ID: ${course.courseId}, Title: ${course.courseTitle}, Instructor: ${course.instructorName}');
    }
  }
}


