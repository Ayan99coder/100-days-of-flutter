import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:practice_area/Models/Models.dart';
import 'package:practice_area/SaveScreen.dart';
import 'package:practice_area/database/database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> notes = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await DbHelper.instance.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  void searchNotes(String query) async {
    if (query.isEmpty) {
      getData();
    } else {
      final data = await DbHelper.instance.searchNotes(query);
      setState(() {
        notes = data;
      });
    }
  }

  void saveScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Savescreen()),
    );
    getData();
  }

  // ---------------- APP BARS ----------------

  PreferredSizeWidget _normalAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("Notes"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              isSearching = true;
            });
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _searchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            isSearching = false;
            searchController.clear();
          });
          getData();
        },
      ),
      title: TextField(
        controller: searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Search notes...",
          border: InputBorder.none,
        ),
        onChanged: searchNotes,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            searchController.clear();
            getData();
          },
        ),
      ],
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isSearching ? _searchAppBar() : _normalAppBar(),

      body: notes.isEmpty
          ? Center(
        child: isSearching
            ? const Text("No notes found")
            : Lottie.asset(
          'assets/notesappempty.json',
          width: size.width * 0.8,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: size.width * 0.03,
          mainAxisSpacing: size.height * 0.015,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final data = notes[index];
            return GestureDetector(
              onLongPress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.archive_outlined),
                            title: const Text("Archive this note"),
                            onTap: () async {
                              await DbHelper.instance.toggleArchive(
                                data.id!,
                                true,
                              );
                              Navigator.pop(context);
                              getData();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                      color: Colors.black.withOpacity(0.06),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: Color(data.color),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(23),
                            bottomLeft: Radius.circular(23),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              12, 16, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      data.title,
                                      style: textTheme.titleLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      data.isPinned
                                          ? Icons.push_pin
                                          : Icons.push_pin_outlined,
                                    ),
                                    onPressed: () async {
                                      await DbHelper.instance.togglePin(
                                        data.id!,
                                        !data.isPinned,
                                      );
                                      getData();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.content,
                                style: textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.date,
                                style: textTheme.labelMedium?.copyWith(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: saveScreen,
        backgroundColor: Colors.white,
        foregroundColor: Colors.purple,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
