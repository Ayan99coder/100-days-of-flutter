import 'package:flutter/material.dart';
import 'package:practice_area/Models/Models.dart';

import 'database/database.dart';

class Trashscreen extends StatefulWidget {
  const Trashscreen({super.key});

  @override
  State<Trashscreen> createState() => _TrashscreenState();
}

class _TrashscreenState extends State<Trashscreen> {
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await DbHelper.instance.getTrashNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: notes.isEmpty
          ? Center(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.350,
                    width: size.width * 0.350,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.archive,
                        size: 100,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.020),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      "Your trash note will appear here",
                      style: TextTheme.of(context).titleLarge!.copyWith(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.010),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: Text(
                      "trash notes to make your main list clean and organized . You can archive them any time",
                      textAlign: TextAlign.center,
                      style: TextTheme.of(context).titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final data = notes[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () async {
                                  await DbHelper.instance.deleteNote(data.id!);
                                  Navigator.pop(context);
                                  getData();
                                },
                                leading: Icon(Icons.delete),
                                title: Text(
                                  "Delete this note?",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.020),
                              ListTile(
                                onTap: () async {
                                  await DbHelper.instance.toggleArchive(
                                    data.id!,
                                    false,
                                  );
                                  Navigator.pop(context);
                                  getData();
                                },
                                leading: Icon(Icons.delete),
                                title: Text(
                                  "Fallback to Archive notes?",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 4),
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data.title,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: size.height * 0.04,
                                  width: size.width * 0.04,
                                  decoration: BoxDecoration(
                                    color: Color(data.color),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              data.content,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
