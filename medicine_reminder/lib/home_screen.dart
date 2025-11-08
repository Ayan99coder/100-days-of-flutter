import 'package:flutter/material.dart';
import 'package:medicine_reminder/custom_widgets.dart';

import 'Pateint_Model.dart';
import 'db_Helper.dart';
import 'notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Medicine> medicines = [];

  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    final data = await DBHelper.instance.getAllMedicines();
    setState(() => medicines = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E2A3E),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogueBox,
        elevation: 5,
        backgroundColor: Colors.blue.shade900,
        shape: CircleBorder(),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: medicines.isEmpty
          ? const Center(child: Text('No Medicines Added Yet'))
          : ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final med = medicines[index];
                return Card(
                  color: Colors.deepPurple,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(med.name,style: styles,),
                    subtitle: Text('${med.dosage} - ${med.time}',style: styles,),
                  ),
                );
              },
            ),
    );
  }

  void _showDialogueBox() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final timeController = TextEditingController();
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 5,
        backgroundColor: Color(0xFF0E2A3E),
        title: Text("Add med ", style: styles),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Medicine Name", style: styles),
            CustomTextField(
              contoller: nameController,
              label: "e.g., Iburprofen",
              lines: 1,
            ),
            Text("Dosage", style: styles),
            CustomTextField(
              contoller: dosageController,
              label: "e.g., tablets/ 10mg",
              lines: 1,
            ),
            Text("Reminder Time", style: styles),
            Timepickertextfield(
              contoller: timeController,
              lines: 1,
              label: "Select medicine time",
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  final formattedTime = pickedTime.format(context);
                  setState(() {
                    timeController.text = formattedTime;
                  });
                }
              },
            ),
            Text("Notes (Optional)", style: styles),
            CustomTextField(
              contoller: noteController,
              label: "Take with food",
              lines: 5,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      dosageController.text.isEmpty ||
                      timeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }

                  final medicine = Medicine(
                    name: nameController.text,
                    dosage: dosageController.text,
                    time: timeController.text,
                    note: noteController.text,
                  );
                  await DBHelper.instance.insertMedicine(medicine);
                  final now = DateTime.now();
                  final pickedTime = TimeOfDay(
                    hour: int.parse(
                        timeController.text.split(':')[0]), // basic parse (for simplicity)
                    minute: int.parse(
                        timeController.text.split(':')[1].split(' ')[0]),
                  );

                  DateTime scheduledTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  // If time already passed → next day
                  if (scheduledTime.isBefore(now)) {
                    scheduledTime = scheduledTime.add(const Duration(days: 1));
                  }

                  // 🔔 Schedule Notification
                  await NotificationService.scheduleNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
                    title: 'Time to take your medicine 💊',
                    body: '${medicine.name} - ${medicine.dosage}',
                    scheduledTime: scheduledTime,
                  );
                  await loadMedicines();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medicine Saved!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  elevation: 5,
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Color(0xFF0E2A3E),
                ),
                child: Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
