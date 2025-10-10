import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:repract/Adder.dart';
import 'package:repract/database.dart';
import 'package:repract/person.dart';
import 'package:repract/textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required before Firebase.initializeApp()
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Adder(),);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final dataBase _base = dataBase();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _Location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Form",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            userText(controller: _name, hintText: "name"),
            SizedBox(height: 25),
            TextField(
              controller: _age,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "age",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black38),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 25),
            userText(controller: _Location, hintText: "Location"),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final name = _name.text.trim();
                final age = int.tryParse(_age.text.trim()) ?? 0;
                final city = _Location.text.trim();
                final newPerson = Person(
                  id: null,
                  name: name,
                  city: city,
                  age: age,
                );
                await _base.createPerson(newPerson);
                _name.clear();
                _age.clear();
                _Location.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
