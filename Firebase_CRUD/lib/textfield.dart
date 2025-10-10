import 'package:flutter/material.dart';

class userText extends StatelessWidget {
  const userText({super.key, required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black38),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),

      ),
    );
  }
}
