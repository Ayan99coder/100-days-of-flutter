import 'package:flutter/material.dart';
import 'db_helper.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage(),);
  }
}
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController controller = TextEditingController();

  void saveTask() async {
    String text = controller.text;
    if (text.isEmpty) return;
    await dbHelper.insertTask(text);
    controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task saved to database ✅")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Simple Example")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Enter task",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveTask,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}