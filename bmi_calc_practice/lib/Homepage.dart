import 'package:bmi_calc_practice/main.dart';
import 'package:flutter/material.dart';
import 'package:bmi_calc_practice/Widgets.dart';

class Homepages extends StatelessWidget {
  const Homepages({super.key, required this.category, required this.yourbmi, required this.suggestion});

  final String category;
  final String yourbmi;
  final String suggestion;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text(
          "Result",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Your BMI", style: textstyle),
            SizedBox(height: 10),
            Container(
              height: size.height * 0.70,
              width: size.width * 0.90,
              decoration: BoxDecoration(color: Color(0xFF1D1E33)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(category, style: textstyle1),
                      Text(yourbmi, style: textstyle2),
                      Text(
                        suggestion,
                        textAlign: TextAlign.center,
                        style: textstyle3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage(),),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "Recalculate",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
