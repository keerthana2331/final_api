import 'dart:io';

String readInput(String prompt, {List<String>? validChoices, bool isOptional = false, List<String>? existingIds}) {
  String? input;

  do {
    print(prompt);
    input = stdin.readLineSync();

    // Check if the input is unique if existingIds is provided
    if (existingIds != null && existingIds.contains(input)) {
      print('This ID already exists. Please enter a unique ID.');
    }

    // Check if the input is optional
    if (isOptional && (input == null || input.isEmpty)) {
      return ''; // Return empty if optional
    }

  } while (existingIds != null && existingIds.contains(input));

  return input ?? '';
}
