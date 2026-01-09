import 'package:flutter/material.dart';
import 'package:practice_area/ArhiveScreen.dart';
import 'package:practice_area/HomePage.dart';
import 'package:practice_area/TrashScreen.dart';
class Bottomnavigationbar extends StatefulWidget {
  const Bottomnavigationbar({super.key});

  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  int _currentIndex = 0;
  final List<Widget> screen = [HomePage(),ArchiveScreen(),Trashscreen(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.blue.shade900,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes_outlined),
            activeIcon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            activeIcon: Icon(Icons.archive),
            label: 'Archive',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restore_from_trash_outlined),
            activeIcon: Icon(Icons.restore_from_trash_sharp),
            label: 'Trash',
          ),
        ],
      ),
    );
  }
}

