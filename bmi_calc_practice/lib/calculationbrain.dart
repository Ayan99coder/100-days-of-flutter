import 'dart:math';

class Calculationbrain {
  Calculationbrain({required this.height, required this.weight}) {
    _bmi = weight / pow(height / 100, 2);
  }

  final double height;
  final double weight;
  late double _bmi;

  String calculatebmi() {
    return _bmi.toStringAsFixed(1);
  }

  String getresult() {
    if (_bmi < 14) {
      return "Underweight";
    } else if (_bmi < 18) {
      return "Healthy weight ";
    } else if (_bmi < 25) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  String suggestion() {
    if (_bmi >= 25) {
      return "You have a higher than normal body weight. Try to exercise.";
    } else if (_bmi > 18.5) {
      return "You have a normal body weight. Good job!";
    } else {
      return "Your body weight is lower than normal. You should eat more.";
    }
  }
}
