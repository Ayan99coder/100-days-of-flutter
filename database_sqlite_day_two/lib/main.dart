import 'package:flutter/material.dart';

import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SimpleApp(),);
  }
}
class SimpleApp extends StatefulWidget {
  const SimpleApp({super.key});

  @override
  State<SimpleApp> createState() => _SimpleAppState();
}

class _SimpleAppState extends State<SimpleApp> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController controller = TextEditingController();

  List<Map<String, dynamic>> tasks = []; // yahan tasks store honge

  @override
  void initState() {
    super.initState();
    loadTasks(); // jab app start ho, tasks load ho
  }

  // Load tasks from database
  void loadTasks() async {
    final data = await dbHelper.getTasks();
    setState(() {
      tasks = data;
    });
  }

  // Save task to database
  void saveTask() async {
    String text = controller.text;
    if (text.isEmpty) return;

    await dbHelper.insertTask(text); // database me save
    controller.clear();

    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("SQLite Todo List")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: "Enter task",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: saveTask,
                    child: const Text("Save"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text("No tasks yet"))
                    : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final item = tasks[index];
                    return Card(
                      child: ListTile(
                        title: Text(item["title"]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
