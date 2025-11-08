import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String label;
  int? lines;
  final TextEditingController contoller;

  CustomTextField({
    super.key,
    required this.label,
    required this.lines,
    required this.contoller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: contoller,
        maxLines: lines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Colors.grey, // gray placeholder
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFF1A2027),
          // slightly lighter dark box
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
          ),
        ),
      ),
    );
  }
}

class Timepickertextfield extends StatelessWidget {
   Timepickertextfield({
    super.key,
    required this.contoller,
    required this.lines,
    required this.label,
     required this.onTap,
  });

  String label;
  int? lines;
  final TextEditingController contoller;
final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onTap:onTap,
        controller: contoller,
        maxLines: lines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(Icons.access_time),
          hintStyle: const TextStyle(
            color: Colors.grey, // gray placeholder
            fontSize: 14,

          ),
          filled: true,
          fillColor: const Color(0xFF1A2027),
          // slightly lighter dark box
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
          ),
        ),
      ),
    );
  }
}

const styles = TextStyle(color: Colors.white, fontWeight: FontWeight.w300);
