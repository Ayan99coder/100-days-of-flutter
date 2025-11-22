import 'package:flutter/material.dart';
import 'package:note_app/Model/note_model.dart';

import '../Database/dbHelper.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  bool isPinned = false;
  int selectedColor = 0xFFFFF176;
  final List<int> colors = [
    0xFF1A1F24,
    0xFFE57373,
    0xFFFFB74D,
    0xFFFFF176,
    0xFF81C784,
    0xFF64B5F6,
    0xFF9575CD,
    0xFFAED581,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                if (_title.text.trim().isEmpty ||
                    _content.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill all fields"),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final newNote = NoteModel(
                  id: null,
                  title: _title.text.trim(),
                  content: _content.text.trim(),
                  date: DateTime.now().toString().split(" ").first,
                  color: selectedColor,
                  isPinned: isPinned,
                );

                await DbHelper.instance.insertNote(newNote);

                // Reset fields
                setState(() {
                  _title.clear();
                  _content.clear();
                  selectedColor = 0xFF1A1F24;
                });

                // Success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Note Saved Successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );

                // Success SnackBar
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: _title,
              style: const TextStyle(fontSize: 22, color: Colors.black38),
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(color: Colors.black38),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ), // default line color
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87), // when typing
                ),
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: TextField(
                controller: _content,
                maxLines: null,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
                decoration: const InputDecoration(
                  hintText: "Write something...",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // default line color
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black87,
                    ), // when typing
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = color),
                  child: Container(
                    width: selectedColor == color ? 50 : 35,
                    height: selectedColor == color ? 50 : 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(color),
                      border: Border.all(
                        color: selectedColor == color
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
