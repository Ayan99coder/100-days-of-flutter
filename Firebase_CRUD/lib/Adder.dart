import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:repract/person.dart';
import 'database.dart';
import 'main.dart';

class Adder extends StatefulWidget {
  const Adder({super.key});

  @override
  State<Adder> createState() => _AdderState();
}

class _AdderState extends State<Adder> {
  Stream? EmployeeStream;

  getontheload() async {
    EmployeeStream = await _base.getPersonsStream();
  }

  void initState() {
    getontheload();
    super.initState();
  }

  final dataBase _base = dataBase();

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: _base.getPersonsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final persons = snapshot.data!;
        if (persons.isEmpty) {
          return const Center(child: Text('No persons yet'));
        }
        return ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final p = persons[index];
            return ListTile(
              title: Text('Name : ${p.name},\n Location : ${p.city}'),
              subtitle: Text('Age: ${p.age}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditDialog(context, p.id!,);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _confirmDelete(context, p.id!);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, String employeeId) {
    final personsCollection = FirebaseFirestore.instance.collection('persons');
    personsCollection.doc(employeeId).get().then((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        TextEditingController nameController =
        TextEditingController(text: data['name']);
        TextEditingController ageController =
        TextEditingController(text: data['age'].toString());
        TextEditingController locationController =
        TextEditingController(text: data['city']);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Edit Employee"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Location"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updatedName = nameController.text.trim();
                  final updatedAge = int.tryParse(ageController.text.trim());
                  final updatedCity = locationController.text.trim();

                  if (updatedName.isEmpty ||
                      updatedAge == null ||
                      updatedCity.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill all fields correctly")),
                    );
                    return;
                  }

                  final updatedPerson = Person(
                    id: employeeId,
                    name: updatedName,
                    age: updatedAge,
                    city: updatedCity,
                  );

                  await _base.updatePerson(updatedPerson);

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Employee updated successfully")),
                  );
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      }
    });
  }

  void _confirmDelete(BuildContext context, String employeeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Employee"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _base.deletePerson(employeeId);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Homepage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
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
              "FireBase",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(children: [Expanded(child: allEmployeeDetails())]),
        ),
      ),
    );
  }
}
