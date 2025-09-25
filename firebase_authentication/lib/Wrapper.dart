import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Homescreen.dart';
import 'login.dart';
class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});
  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}
class _WrapperScreenState extends State<WrapperScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
