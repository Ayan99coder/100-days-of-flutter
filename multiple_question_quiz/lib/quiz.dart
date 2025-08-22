class Quiz {
  String questionText;
  List<String> options;  // List of multiple options
  int correctAnswerIndex;  // Index of the correct answer

  Quiz({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}
