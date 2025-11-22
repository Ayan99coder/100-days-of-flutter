import 'package:flutter/material.dart';
import 'package:note_app/Screens/HomeScreen.dart';
import 'addNoteScreen.dart';

class NavigationBarse extends StatefulWidget {
  const NavigationBarse({super.key});

  @override
  State<NavigationBarse> createState() => _NavigationBarseState();
}

class _NavigationBarseState extends State<NavigationBarse> {
  int index = 0;

  final screens = [
    Homescreen(),
    AddNote(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: screens[index],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        child: Container(
          height: screenHeight * 0.09, // responsive height
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(screenHeight * 0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              navIcon(Icons.home, 0, screenHeight),
              navIcon(Icons.add, 1, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget navIcon(IconData icon, int i, double screenHeight) {
    bool selected = index == i;

    return GestureDetector(
      onTap: () {
        setState(() {
          index = i;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: EdgeInsets.all(selected ? screenHeight * 0.018 : screenHeight * 0.012),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(screenHeight * 0.02),
        ),
        child: Icon(
          icon,
          size: selected ? screenHeight * 0.035 : screenHeight * 0.03,
          color: selected ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}
