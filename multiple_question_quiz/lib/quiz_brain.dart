import 'package:multiple_question_quiz/quiz.dart';

class QuizBrain {
  List<Quiz> _questionBank = [
    Quiz(
      questionText: 'What is the capital of France?',
      options: ['Berlin', 'Madrid', 'Paris', 'Rome'],
      correctAnswerIndex: 2, // Paris is the correct answer
    ),
    Quiz(
      questionText: 'Who developed Flutter?',
      options: ['Facebook', 'Google', 'Apple', 'Microsoft'],
      correctAnswerIndex: 1, // Google is the correct answer
    ),
    Quiz(
      questionText: 'Which language is used in Flutter?',
      options: ['Kotlin', 'Java', 'Dart', 'Swift'],
      correctAnswerIndex: 2, // Dart is the correct answer
    ),
    Quiz(
      questionText: 'What is the largest planet in our solar system?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswerIndex: 2, // Jupiter is the correct answer
    ),
    Quiz(
      questionText: 'Which is the longest river in the world?',
      options: ['Amazon', 'Nile', 'Yangtze', 'Ganges'],
      correctAnswerIndex: 1, // Nile is the correct answer
    ),
  ];

  int _questionIndex = 0;

  String getQuestion() {
    return _questionBank[_questionIndex].questionText;
  }

  List<String> getOptions() {
    return _questionBank[_questionIndex].options;
  }

  int getCorrectAnswerIndex() {
    return _questionBank[_questionIndex].correctAnswerIndex;
  }

  void nextQuestion() {
    if (_questionIndex < _questionBank.length - 1) {
      _questionIndex++;
    }
  }

  bool isFinished() {
    return _questionIndex >= _questionBank.length - 1;
  }

  void reset() {
    _questionIndex = 0;
  }
}
