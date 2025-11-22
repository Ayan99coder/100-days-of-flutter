import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/Database/dbHelper.dart';
import 'package:note_app/Model/note_model.dart';
import 'package:note_app/Screens/ViewNoteScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await DbHelper.instance.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    // Dynamically determine number of columns
    int crossAxisCount = 2;
    if (screenWidth > 600) crossAxisCount = 3;
    if (screenWidth > 900) crossAxisCount = 4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "te",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "s",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    size: 29,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: notes.isEmpty
                ? Center(
              child: Lottie.asset(
                'assets/emptybox.json',
                width: screenWidth * 0.8,
                reverse: true,
              ),
            )
                : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: size.height * 0.01,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: size.height * 0.015,
                  crossAxisSpacing: screenWidth * 0.03,
                  childAspectRatio: 0.8,
                ),
                itemCount: notes.length,
                itemBuilder: (_, i) {
                  final note = notes[i];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ViewNoteScreen(note: note),
                        ),
                      );
                      await loadNotes();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(note.color),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: size.height * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                note.date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 11),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(5),
                                constraints: const BoxConstraints(),
                                icon: Icon(
                                  note.isPinned
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                ),
                                onPressed: () async {
                                  final newPinValue = !note.isPinned;
                                  await DbHelper.instance.togglePin(
                                      note.id!, newPinValue);
                                  await loadNotes();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                          Expanded(
                            child: Text(
                              note.content,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
