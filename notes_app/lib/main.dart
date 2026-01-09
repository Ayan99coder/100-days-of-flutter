import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'bottomnavigationbar.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Desktop / localhost ke liye
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bottomnavigationbar(),
    );
  }
}
