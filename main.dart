import 'dart:io';
import 'student.dart';
import 'course.dart';
import 'data_manager.dart';


Future<void> main() async {
  final students = await DataManager.loadStudents();
  final courses = await DataManager.loadCourses();

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
    
    String choice = readInput('Choose an option :',
        validChoices: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);

    switch (choice) {
      case '1':
        await createStudent(students, courses);
        break;
      case '2':
        await createCourse(courses);
        break;
      case '3':
        await enrollStudentInCourse(students, courses);
        break;
      case '4':
        await viewStudentSchedule(students);
        break;
      case '5':
        await viewCourseRoster(courses);
        break;
      case '6':
        await dropCourse(students, courses);
        break;
      case '7':
        await dropStudent(students);
        break;
      case '8':
        await updateStudent(students);
        break;
      case '9':
        await updateCourse(courses);
        break;
      case '10':
        running = false;
        print('Goodbye!');
        break;
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

Future<void> createStudent(Map<String, Student> students, Map<String, Course> courses) async {
  // Prompt for the student ID with uniqueness check
  String studentId = readInput('Enter student ID : ', existingIds: students.keys.toList());

  String name = readInput('Enter student name : ');
  

  String coursesInput = readInput('Enter course IDs the student is enrolled in (comma-separated) : ', isOptional: true);
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

  // Create a new Student object
  Student newStudent = Student(name, studentId, validCourses);
  
  // Add the new student to the map
  students[studentId] = newStudent;

  // Save the updated students map
  await DataManager.saveStudents(students);

  print('Student added successfully.');
}

Future<void> createCourse(Map<String, Course> courses) async {
  String courseTitle = readInput('Enter course title : ');
  String courseId = readInput('Enter course ID : ', existingIds: courses.keys.toList());
  String instructorName = readInput('Enter instructor name : ');
  
  String studentsInput = readInput('Enter student IDs enrolled in the course (comma-separated) : ', isOptional: true);
  List<String> enrolledStudents = studentsInput.isNotEmpty
      ? studentsInput.split(',').map((e) => e.trim()).toList()
      : [];

  Course newCourse = Course(courseId, courseTitle, instructorName, enrolledStudents);

  // Add the course to the courses map
  courses[courseId] = newCourse;

  // Now save the entire courses map
  await DataManager.saveCourses(courses);

  print('Course added successfully.');
}

Future<void> enrollStudentInCourse(Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID');
  String courseId = readInput('Enter course ID');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  Course course = courses[courseId]!;

  if (!student.enrolledCourses.contains(courseId)) {
    student.enrolledCourses.add(courseId);
    course.enrolledStudents.add(studentId);
    
    await DataManager.saveStudents(students);
    await DataManager.saveCourses(courses);
    
    print('Student $studentId enrolled in course $courseId successfully.');
  } else {
    print('Student $studentId is already enrolled in course $courseId.');
  }
}

Future<void> viewStudentSchedule(Map<String, Student> students) async {
  String studentId = readInput('Enter student ID');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  print('Schedule for ${student.studentId}:');
  if (student.enrolledCourses.isEmpty) {
    print('No courses enrolled.');
  } else {
    for (var courseId in student.enrolledCourses) {
      print('- Course ID: $courseId');
    }
  }
}

Future<void> viewCourseRoster(Map<String, Course> courses) async {
  String courseId = readInput('Enter course ID');

  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;
  print('Roster for course ${course.title}:');
  if (course.enrolledStudents.isEmpty) {
    print('No students enrolled.');
  } else {
    for (var studentId in course.enrolledStudents) {
      print('- Student ID: $studentId');
    }
  }
}

Future<void> dropCourse(Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID');
  String courseId = readInput('Enter course ID');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  Course course = courses[courseId]!;

  if (student.enrolledCourses.remove(courseId)) {
    course.enrolledStudents.remove(studentId);
    
    await DataManager.saveStudents(students);
    await DataManager.saveCourses(courses);
    
    print('Student $studentId dropped from course $courseId successfully.');
  } else {
    print('Student $studentId is not enrolled in course $courseId.');
  }
}

Future<void> dropStudent(Map<String, Student> students) async {
  String studentId = readInput('Enter the Student ID to drop', existingIds: students.keys.toList());

  // Check if the student exists
  if (students.containsKey(studentId)) {
    // Remove the student from the map
    students.remove(studentId);

    // Save the updated students map
    await DataManager.saveStudents(students);

    print('Student removed successfully.');
  } else {
    print('Student with ID $studentId does not exist.');
  }
}

Future<void> updateStudent(Map<String, Student> students) async {
  String studentId = readInput('Enter student ID');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  String name = readInput('Enter new student name (leave blank to keep current name)');
  List<String> enrolledCourses= students[studentId]!.enrolledCourses;

  if (name.isNotEmpty) {
    students[studentId]!.studentId = name;
  }

  // Add any other updates necessary here
await DataManager.saveStudents(students); // Corrected from saveStudens to saveStudents

  print('Student $studentId updated successfully.');
}

Future<void> updateCourse(Map<String, Course> courses) async {
  String courseId = readInput('Enter course ID');

  // Check if the course ID exists
  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  // Get the existing course
  Course existingCourse = courses[courseId]!;

  // Prompt for new title and instructor name
  String courseTitle = readInput('Enter new course title (leave blank to keep current title)');
  String instructorName = readInput('Enter new instructor name (leave blank to keep current name)');

  // Update title if provided
  if (courseTitle.isNotEmpty) {
    existingCourse.title = courseTitle;
  }

  // Update instructor name if provided
  if (instructorName.isNotEmpty) {
    existingCourse.instructorName = instructorName;
  }

  // Save the updated course back to the DataManager
await DataManager.saveCourses(courses); // Corrected to save all courses
 // Changed from saveCourses to saveCourse
  print('Course $courseId updated successfully.');
}


String readInput(String prompt, {List<String>? validChoices, bool isOptional = false, List<String>? existingIds}) {
  // Implement this method to read user input and validate based on the parameters.
  // This function must be completed based on your specific input handling logic.
  // Make sure to include any checks for existing IDs if provided.
  stdout.write(prompt);
  String? input = stdin.readLineSync();

  // Example validation (you may adjust based on your needs)
  while (input == null || (!isOptional && input.isEmpty) || (existingIds != null && existingIds.contains(input))) {
    print('Invalid input. Please try again.');
    stdout.write(prompt);
    input = stdin.readLineSync();
  }

  return input;
}
