import 'dart:convert'; // For encoding and decoding JSON
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:io'; // For handling IO operations like reading files or user input


class Student {
  String studentId;
  String name;
  List<String> enrolledCourses;

  Student({required this.studentId, required this.name, this.enrolledCourses = const []});

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'name': name,
      'enrolledCourses': enrolledCourses,
    };
  }

  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['studentId'],
      name: json['name'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
    );
  }
}


class Course {
  String courseId;
  String courseTitle;
  String instructorName;

  Course({required this.courseId, required this.courseTitle, required this.instructorName});

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseTitle': courseTitle,
      'instructorName': instructorName,
    };
  }

  static Course fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseTitle: json['courseTitle'],
      instructorName: json['instructorName'],
    );
  }
}

class DataManager {
  static const String baseUrl = 'https://crudcrud.com/api/50e72191875a48c9ac64d217e779cbd1'; 


  static Future<Map<String, Student>> loadStudents() async {
    Map<String, Student> students = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var student = Student.fromJson(item as Map<String, dynamic>);
          students[student.studentId] = student;
        }
      } else {
        print('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading students: $e');
    }
    return students;
  }

  
  static Future<void> saveStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/students'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(student.toJson()),
      );
      if (response.statusCode == 201) {
        print('Student saved successfully.');
      } else {
        print('Failed to save student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving student: $e');
    }
  }

  
  static Future<Map<String, Course>> loadCourses() async {
    Map<String, Course> courses = {};
    try {
      final response = await http.get(Uri.parse('$baseUrl/courses'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        for (var item in jsonData) {
          var course = Course.fromJson(item as Map<String, dynamic>);
          courses[course.courseId] = course;
        }
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading courses: $e');
    }
    return courses;
  }

  
  static Future<void> saveCourse(Course course) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(course.toJson()),
      );
      if (response.statusCode == 201) {
        print('Course saved successfully.');
      } else {
        print('Failed to save course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving course: $e');
    }
  }
}

void main() async {
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
    String choice = readInput('Choose an option', validChoices: [
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'
    ]);

    switch (choice) {
      case '1':
        await createStudent();
        break;
      case '2':
        await createCourse();
        break;
      case '3':
        await enrollStudentInCourse();
        break;
      case '4':
        await viewStudentSchedule();
        break;
      case '5':
        await viewCourseRoster();
        break;
      case '6':
        await dropCourse();
        break;
      case '7':
        await dropStudent();
        break;
      case '8':
        await updateStudent();
        break;
      case '9':
        await updateCourse();
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

const String coursesApiUrl = '/courses';


Future<void> loadCourses() async {
  try {
    final response = await http.get(Uri.parse(coursesApiUrl));
    
    if (response.statusCode == 200) {
      
      List<dynamic> jsonResponse = json.decode(response.body);
     
      if (jsonResponse.isNotEmpty) {
        for (var course in jsonResponse) {
          print('Course Title: ${course['courseTitle']}, Course ID: ${course['courseId']}, Instructor: ${course['instructor']}');
        }
      } else {
        print('No courses available.');
      }
    } else {
      print('Failed to load courses: ${response.statusCode}');
    }
  } catch (e) {
    print('Error loading courses: $e');
  }
}





Future<void> enrollStudentInCourse() async {
  String studentId = readInput('Enter student ID (numeric)', isId: true);
  String courseId = readInput('Enter course ID (numeric)', isId: true);

  
  Map<String, Student> students = await DataManager.loadStudents();
  Map<String, Course> courses = await DataManager.loadCourses();

 
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }
  if (!courses.containsKey(courseId)) {
    print('Error: Course with ID $courseId does not exist.');
    return;
  }

  
  Student student = students[studentId]!;
  student.enrolledCourses.add(courseId);
  await DataManager.saveStudent(student);
  print('Student $studentId enrolled in course $courseId successfully.');
}

Future<void> createStudent() async {
  String name = readInput('Enter student name', validChoices: null, isName: true);
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();
  
  
  if (students.containsKey(studentId)) {
    print('Error: A student with ID $studentId already exists.');
    return;
  }

  
  Map<String, Course> courses = await DataManager.loadCourses();
  print('Available Courses:');
  if (courses.isEmpty) {
    print('No courses available to select.');
    return;
  }

  for (var course in courses.values) {
    print('${course.courseId}: ${course.courseTitle}');
  }

  String courseChoice = readInput('Select a course by ID', validChoices: courses.keys.toList());
  String selectedCourseId = courseChoice;

  
  Student newStudent = Student(studentId: studentId, name: name, enrolledCourses: []);
  
 
  if (newStudent.enrolledCourses.contains(selectedCourseId)) {
    print('Error: Student is already enrolled in this course.');
    return;
  } else {
    newStudent.enrolledCourses.add(selectedCourseId);
  }

 
  await DataManager.saveStudent(newStudent);
  print('Student $name with ID $studentId has been successfully created and enrolled in the course.');
}





Future<void> createCourse() async {
  Map<String, Course> courses = await DataManager.loadCourses();

  String courseId;
  do {
    courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);
    if (courses.containsKey(courseId)) {
      print('Error: Course ID already exists. Please enter a unique ID.');
      courseId = ''; 
    }
  } while (courseId.isEmpty);  

  String courseTitle;
  do {
    courseTitle = readInput('Enter course title', validChoices: null, isName: true);
    bool titleExists = courses.values.any((course) => course.courseTitle == courseTitle);
    if (titleExists) {
      print('Error: Course title already exists. Please enter a unique title.');
      courseTitle = ''; 
    }
  } while (courseTitle.isEmpty); 
  String instructorName = readInput('Enter instructor name', validChoices: null, isName: true);

  Course course = Course(courseId: courseId, courseTitle: courseTitle, instructorName: instructorName);

  await DataManager.saveCourse(course);
  print('Course created successfully!');
}

Future<void> viewCourseRoster() async {
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);

  
  Map<String, Student> students = await DataManager.loadStudents();

  
  List<String> enrolledStudents = [];
  for (var student in students.values) {
    if (student.enrolledCourses.contains(courseId)) {
      enrolledStudents.add(student.studentId);
    }
  }

 
  if (enrolledStudents.isEmpty) {
    print('No students are enrolled in Course ID: $courseId.');
  } else {
    print('Roster for Course ID: $courseId');
    for (var studentId in enrolledStudents) {
      print('Student ID: $studentId');
    }
  }
}

Future<void> dropStudent() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();

  
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }

  
  students.remove(studentId);
  print('Student $studentId dropped successfully.');
}



Future<void> dropCourse() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();

 
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;

  
  if (student.enrolledCourses.contains(courseId)) {
    student.enrolledCourses.remove(courseId);
    await DataManager.saveStudent(student);
    print('Course $courseId dropped for student $studentId successfully.');
  } else {
    print('Error: Student is not enrolled in this course.');
  }
}

Future<void> updateStudent() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);

  
  Map<String, Student> students = await DataManager.loadStudents();

  
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }

  String name = readInput('Enter new student name');
  Student student = students[studentId]!;
  student.name = name;
  await DataManager.saveStudent(student);
  print('Student $studentId updated successfully.');
}
Future<void> updateCourse() async {
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);

  
  Map<String, Course> courses = await DataManager.loadCourses();

 
  if (!courses.containsKey(courseId)) {
    print('Error: Course with ID $courseId does not exist.');
    return;
  }

  String courseTitle = readInput('Enter new course title');
  String instructorName = readInput('Enter new instructor name');

  Course course = courses[courseId]!;
  course.courseTitle = courseTitle;
  course.instructorName = instructorName;
  await DataManager.saveCourse(course);
  print('Course $courseId updated successfully.');
}

String readInput(String prompt, {List<String>? validChoices, bool isId = false, bool isName = false}) {
  stdout.write('$prompt: ');
  String? input = stdin.readLineSync();

  if (isId) {
    while (input == null || input.isEmpty || !RegExp(r'^\d+$').hasMatch(input)) {
      print('Invalid input. Please enter a valid numeric ID.');
      stdout.write('$prompt: ');
      input = stdin.readLineSync();
    }
  } else if (isName) {
    while (input == null || input.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(input)) {
      print('Invalid input. Please enter a valid name (alphabetic characters only).');
      stdout.write('$prompt: ');
      input = stdin.readLineSync();
    }
  }
  return input ?? '';
}

StudentInCourse() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);
  String courseId = readInput('Enter course ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();
  Map<String, Course> courses = await DataManager.loadCourses();

 
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }

  if (!courses.containsKey(courseId)) {
    print('Error: Course with ID $courseId does not exist.');
    return;
  }

  
  Student student = students[studentId]!;
  if (!student.enrolledCourses.contains(courseId)) {
    student.enrolledCourses.add(courseId);
    await DataManager.saveStudent(student);
    print('Student $studentId enrolled in course $courseId successfully.');
  } else {
    print('Error: Student is already enrolled in this course.');
  }
}



Future<void> viewStudentSchedule() async {
  String studentId = readInput('Enter student ID (numeric)', validChoices: null, isId: true);

 
  Map<String, Student> students = await DataManager.loadStudents();

  
  if (!students.containsKey(studentId)) {
    print('Error: Student with ID $studentId does not exist.');
    return;
  }

  Student student = students[studentId]!;
  print('Schedule for student ${student.name}:');

 
  if (student.enrolledCourses.isEmpty) {
    print('Student ${student.name} is not enrolled in any courses. Please enroll in courses to view the schedule.');
  } else {
    print('Enrolled courses:');
    for (var courseId in student.enrolledCourses) {
      print('Course ID: $courseId');
    }
  }
}
