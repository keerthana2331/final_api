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

    String choice = readInput('Choose an option:',
        validChoices: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']);

    switch (choice) {
      case '1':
        await createStudent(students, courses);
        break;
      case '2':
        await createCourses(courses);
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
  String studentId = readInput('Enter student ID: ', existingIds: students.keys.toList());
  String name = readInput('Enter student name: ');

  String coursesInput = readInput('Enter course IDs the student is enrolled in (comma-separated): ', isOptional: true);
  List<String> selectedCourses = coursesInput.isNotEmpty ? coursesInput.split(',').map((e) => e.trim()).toList() : [];

  List<String> validCourses = [];

  for (var courseId in selectedCourses) {
    if (courses.containsKey(courseId)) {
      validCourses.add(courseId);
    } else {
      print('Course ID $courseId does not exist.');
      String createCourseChoice = readInput('Would you like to create this course? (yes/no): ', validChoices: ['yes', 'no']);
      
      if (createCourseChoice == 'yes') {
        await createCourses( courses); // Corrected method call
        validCourses.add(courseId);
      }
    }
  }

  Student newStudent = Student(name, studentId, validCourses);
  students[studentId] = newStudent;

  try {
    await DataManager.saveStudents(students);
    print('Student added successfully.');
  } catch (e) {
    print('Failed to save students. Please try again.'); // User-friendly error message
  }
}

Future<void> createCourses(Map<String, Course> courses) async {
  String courseTitle = readInput('Enter course title: ');
  String courseId = readInput('Enter course ID: ', existingIds: courses.keys.toList());
  String instructorName = readInput('Enter instructor name: ');
  
  String studentsInput = readInput('Enter student IDs enrolled in the course (comma-separated): ', isOptional: true);
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
  String studentId = readInput('Enter student ID: ');
  String courseId = readInput('Enter course ID: ');

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

  if (!student.enrolledcourses.contains(courseId)) {
    student.enrolledcourses.add(courseId);
    course.enrolledStudents.add(studentId);
    
    await DataManager.saveStudents(students);
    await DataManager.saveCourses(courses);
    
    print('Student $studentId enrolled in course $courseId successfully.');
  } else {
    print('Student $studentId is already enrolled in course $courseId.');
  }
}

Future<void> viewStudentSchedule(Map<String, Student> students) async {
  String studentId = readInput('Enter student ID: ');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  print('Schedule for ${student.studentid}:');
  if (student.enrolledcourses.isEmpty) {
    print('No courses enrolled.');
  } else {
    for (var courseId in student.enrolledcourses) {
      print('- Course ID: $courseId');
    }
  }
}

Future<void> viewCourseRoster(Map<String, Course> courses) async {
  String courseId = readInput('Enter course ID: ');

  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  Course course = courses[courseId]!;
  print('Roster for course ${course.toString()}:');
  if (course.enrolledStudents.isEmpty) {
    print('No students enrolled.');
  } else {
    for (var studentId in course.enrolledStudents) {
      print('- Student ID: $studentId');
    }
  }
}

Future<void> dropCourse(Map<String, Student> students, Map<String, Course> courses) async {
  String studentId = readInput('Enter student ID: ');
  String courseId = readInput('Enter course ID: ');

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

  if (student.enrolledcourses.remove(courseId)) {
    course.enrolledStudents.remove(studentId);
    
    await DataManager.saveStudents(students);
    await DataManager.saveCourses(courses);
    
    print('Student $studentId dropped from course $courseId successfully.');
  } else {
    print('Student $studentId is not enrolled in course $courseId.');
  }
}

Future<void> dropStudent(Map<String, Student> students) async {
  String studentId = readInput('Enter the Student ID to drop:', existingIds: students.keys.toList());

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
  String studentId = readInput('Enter student ID: ');

  if (!students.containsKey(studentId)) {
    print('Student ID $studentId does not exist.');
    return;
  }

  String name = readInput('Enter new student name (leave blank to keep current name): ');
  List<String> enrolledCourses = students[studentId]!.enrolledcourses;

  if (name.isNotEmpty) {
    students[studentId]!.name = name;
  }

  // Add any other updates necessary here
  await DataManager.saveStudents(students); // Corrected from saveStudens to saveStudents

  print('Student $studentId updated successfully.');
}

Future<void> updateCourse(Map<String, Course> courses) async {
  String courseId = readInput('Enter course ID: ');

  // Check if the course ID exists
  if (!courses.containsKey(courseId)) {
    print('Course ID $courseId does not exist.');
    return;
  }

  // Get the existing course
  Course existingCourse = courses[courseId]!;

  // Prompt for new title and instructor name
  String courseTitle = readInput('Enter new course title (leave blank to keep current title): ');
  String instructorName = readInput('Enter new instructor name (leave blank to keep current name): ');

  // Update title if provided
  if (courseTitle.isNotEmpty) {
    existingCourse.courseid= courseTitle;
  }

  // Update instructor name if provided
  if (instructorName.isNotEmpty) {
    existingCourse.instructorName = instructorName;
  }

  // Save the updated courses map
  await DataManager.saveCourses(courses);

  print('Course $courseId updated successfully.');
}

String readInput(String prompt, {List<String>? validChoices, bool isOptional = false, List<String>? existingIds}) {
  stdout.write(prompt);
  String? input = stdin.readLineSync();

  // Input validation loop
  while (true) {
    // Check for null input
    if (input == null) {
      print('Input cannot be null. Please try again.');
    } 
    // Check for empty input if it's not optional
    else if (!isOptional && input.isEmpty) {
      print('Input cannot be empty. Please try again.');
    } 
    // Check if existingIds is provided and contains the input
    else if (existingIds != null && existingIds.contains(input)) {
      print('Input must be unique. This ID already exists. Please try again.');
    } 
    // Check if validChoices is provided and input is not one of them
    else if (validChoices != null && !validChoices.contains(input)) {
      print('Invalid choice. Please select from: ${validChoices.join(', ')}');
    } 
    // If all checks passed, break the loop
    else {
      break;
    }

    stdout.write(prompt);
    input = stdin.readLineSync();
  }

  return input;
}
