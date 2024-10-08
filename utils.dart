import 'dart:io';

String readInput(
  String prompt, {
  List<String>? validChoices,
  bool isUnique = false,
  List<String>? existingIds,
  bool isOptional = false,
  bool isNumeric = false,
}) {
  while (true) {
    stdout.write('$prompt: ');
    String? input = stdin.readLineSync();

    if (input == null || input.trim().isEmpty) {
      if (isOptional) {
        return '';
      } else {
        print('Input cannot be empty. Please try again.');
        continue;
      }
    }

    String trimmedInput = input.trim();

    if (validChoices != null && !validChoices.contains(trimmedInput)) {
      print('Invalid choice. Please select from: ${validChoices.join(', ')}');
      continue;
    }

    if (isUnique && existingIds != null && existingIds.contains(trimmedInput)) {
      print('ID $trimmedInput already exists. Please enter a unique ID.');
      continue;
    }

    if (isNumeric && !RegExp(r'^[0-9]+$').hasMatch(trimmedInput)) {
      print('Input must be a numeric value. Please try again.');
      continue;
    }

    return trimmedInput;
  }
}
