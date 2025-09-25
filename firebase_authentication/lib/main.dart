import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Forgot_password.dart';
import 'Homescreen.dart';
import 'Sign.dart';
import 'Wrapper.dart';
import 'login.dart';
import 'otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      initialRoute: '/',
      routes: {
        '/': (_) => const WrapperScreen(),
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/Forgot': (_) => const ForgotPassword(),
        '/otp': (_) => const OtpScreen(),
      },
    );
  }
}