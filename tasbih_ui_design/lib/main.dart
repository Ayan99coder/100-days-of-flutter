import 'package:flutter/material.dart';
import 'package:tasbih_ui_design/screen/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage(), debugShowCheckedModeBanner: false);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool selectedIndex = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF004d00),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: size.height * 0.90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/tasbih.png"),
                SizedBox(height: 100),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = !selectedIndex;
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Homescreen()),
                        );
                      });
                    });
                  },
                  child: AnimatedContainer(
                    curve: Curves.bounceInOut,
                    duration: Duration(seconds: 1),
                    height: 40,
                    width: selectedIndex
                        ? size.width * 0.80
                        : size.width * 0.40,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: selectedIndex
                            ? [
                                Colors.green,
                                Colors.green.shade700,
                                Colors.green.shade200,
                              ]
                            : [Colors.green, Colors.black],
                      ),
                    ),

                    child: Center(
                      child: Text(
                        selectedIndex ? "Tapped" : "Tap me",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
