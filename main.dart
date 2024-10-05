import 'api.dart';
import 'student.dart';
import 'course.dart';
import 'utilis.dart';


void main() async {
  // Use 'await' to wait for the future to complete
  Map<String, Student> students = await ApiService.loadStudents();
  Map<String, Course> courses = await ApiService.loadCourses();
  bool running = true;

  while (running) {
    // Display the menu
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
    print('10. Available Courses');
    print('11. Exit');

    // Read user input for menu choice
    String choice = readInput(
      'Choose an option',
      validChoices: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'],
    );

    switch (choice) {
      case '1':
        createStudent(students, courses);
        break;
      case '2':
        createCourse(courses);
        break;
      case '3':
        enrollStudentInCourse(students, courses);
        break;
      case '4':
        viewStudentSchedule(students, courses);
        break;
      case '5':
        viewCourseRoster(courses, students);
        break;
      case '6':
        dropCourse(students, courses);
        break;
      case '7':
        dropStudent(students, courses);
        break;
      case '8':
        updateStudent(students);
        break;
      case '9':
        updateCourse(courses);
        break;
      case '10':
        printAvailableCourses(courses);
        break;
      case '11':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.');
    }

    if (choice != '11') {
      saveData(students, courses);
    }
  }
}

// Save student and course data
void saveData(Map<String, Student> students, Map<String, Course> courses) {
  ApiService.saveStudents(students);
  ApiService.saveCourses(courses);
  print('Data saved successfully.');
}

// Create a new student
void createStudent(Map<String, Student> students, Map<String, Course> courses) {
  String name = readInput('Enter student name');
  String studentId = readInput('Enter student ID',
      isUnique: true, existingIds: students.keys.toList());

  printAvailableCourses(courses);

  String coursesInput = readInput(
    'Enter course IDs the student is enrolled in (comma-separated)',
    isOptional: true,
  );
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

// Print available courses
void printAvailableCourses(Map<String, Course> courses) {
  if (courses.isEmpty) {
    print('No courses available.');
    return;
  }

  print('Available Courses:');
  for (var course in courses.values) {
    print('- Course ID: ${course.courseId}, Title: ${course.courseTitle}');
  }
}

// Create a new course
void createCourse(Map<String, Course> courses) {
  String courseTitle = readInput('Enter course title');
  String courseId = readInput('Enter course ID',
      isUnique: true, existingIds: courses.keys.toList());
  String instructorName = readInput('Enter instructor name');
  String studentsInput = readInput(
    'Enter student IDs enrolled in the course (comma-separated)',
    isOptional: true,
  );
  List<String> enrolledStudents = studentsInput.isNotEmpty
      ? studentsInput.split(',').map((e) => e.trim()).toList()
      : [];

  courses[courseId] =
      Course(courseId, courseTitle, instructorName, enrolledStudents);
  print('Course added successfully.');
}

// Enroll a student in a course
void enrollStudentInCourse(
    Map<String, Student> students, Map<String, Course> courses) {
  String studentId = readInput(
      'Enter student ID', existingIds: students.keys.toList());
  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  String courseId =
      readInput('Enter course ID', existingIds: courses.keys.toList());
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

// View a student's schedule
void viewStudentSchedule(
    Map<String, Student> students, Map<String, Course> courses) {
  String studentId =
      readInput('Enter student ID', existingIds: students.keys.toList());

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
      print(
          '- Course ID: $courseId, Course Title: ${courses[courseId]?.courseTitle ?? 'Unknown'}');
    }
  }
}

// View a course's roster
void viewCourseRoster(
    Map<String, Course> courses, Map<String, Student> students) {
  String courseId =
      readInput('Enter course ID', existingIds: courses.keys.toList());

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
      print(
          '- Student ID: $studentId, Name: ${students[studentId]?.name ?? 'Unknown'}');
    }
  }
}

// Drop a course for a student
void dropCourse(Map<String, Student> students, Map<String, Course> courses) {
  String studentId =
      readInput('Enter student ID', existingIds: students.keys.toList());
  String courseId =
      readInput('Enter course ID', existingIds: courses.keys.toList());

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

// Drop a student from the system
void dropStudent(Map<String, Student> students, Map<String, Course> courses) {
  String studentId =
      readInput('Enter student ID', existingIds: students.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;

  for (String courseId in student.enrolledCourses) {
    Course course = courses[courseId]!;
    course.enrolledStudents.remove(studentId);
  }

  students.remove(studentId);

  print(
      'Student dropped successfully from all courses and removed from the system.');
}

// Update a student's details
void updateStudent(Map<String, Student> students) {
  String studentId =
      readInput('Enter student ID', existingIds: students.keys.toList());

  if (!students.containsKey(studentId)) {
    print('Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;

  String newName = readInput('Enter new student name');
  String newCoursesInput = readInput(
      'Enter new course IDs the student is enrolled in (comma-separated)',
      isOptional: true);
  List<String> newCourses = newCoursesInput.isNotEmpty
      ? newCoursesInput.split(',').map((e) => e.trim()).toList()
      : [];

  student.name = newName;
  student.enrolledCourses = newCourses;

  print('Student updated successfully.');
}

// Update a course's details
void updateCourse(Map<String, Course> courses) {
  String courseId =
      readInput('Enter course ID', existingIds: courses.keys.toList());

  if (!courses.containsKey(courseId)) {
    print('Course with ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;

  String newTitle = readInput('Enter new course title');
  String newInstructor = readInput('Enter new instructor name');
  String newStudentsInput = readInput(
      'Enter new student IDs enrolled in the course (comma-separated)',
      isOptional: true);
  List<String> newStudents = newStudentsInput.isNotEmpty
      ? newStudentsInput.split(',').map((e) => e.trim()).toList()
      : [];

  course.courseTitle = newTitle;
  course.instructorName = newInstructor;
  course.enrolledStudents = newStudents;

  print('Course updated successfully.');
}