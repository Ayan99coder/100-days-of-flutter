import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> diceNumber = [1, 1, 1, 1];
  List<int> score = [0, 0, 0, 0];

  void diceCalculation(int index) {
    int roll = Random().nextInt(6) + 1;
    diceNumber[index] = roll;
    score[index] = roll;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Column(
              children: [
                building(
                  onTap: () {
                    setState(() {
                      diceCalculation(0);
                    });
                  },
                  dicenumbers: diceNumber[0],
                  playername: "Player 1 :",
                  score: score[0],
                ),
                SizedBox(height: 300),
                building(
                  onTap: () {
                    setState(() {
                      diceCalculation(1);
                    });
                  },
                  dicenumbers: diceNumber[1],
                  playername: "Player 2 :",
                  score: score[1],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                building(
                  score: score[2],
                  dicenumbers: diceNumber[2],
                  onTap: () {
                    setState(() {
                      diceCalculation(2);
                    });
                  },
                  playername: "Player 3",
                ),
                SizedBox(height: 300),
                building(
                  onTap: () {
                    setState(() {
                      diceCalculation(3);
                    });
                  },
                  dicenumbers: diceNumber[3],
                  playername: "Player 4 :",
                  score: score[3],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class building extends StatelessWidget {
  final int dicenumbers;
  final int score;
  final String playername;
  final VoidCallback onTap;

  const building({
    super.key,
    required this.score,
    required this.dicenumbers,
    required this.onTap,
    required this.playername,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Di$dicenumbers.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text("$playername:$score"),
      ],
    );
  }
}
