import 'package:data_passing_day_one/person.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
  TextEditingController names = TextEditingController();
  TextEditingController age = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller:names ,
            ),
            SizedBox(height: 20,),
            TextField(
              controller:age ,
            ),
            SizedBox(height: 20,),
            ElevatedButton(

              onPressed: () {
                int ageValue = int.tryParse(age.text) ?? 0;
                Person person = Person(name: names.text, age: ageValue);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(person:person),
                  ),
                );
              },
              child: const Text("Go to Detail Page"),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Person person;
  const DetailPage({super.key,required this.person});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Page")),
      body: Center(
        child: Text("Hello, $person.name! and $person.age ", style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
