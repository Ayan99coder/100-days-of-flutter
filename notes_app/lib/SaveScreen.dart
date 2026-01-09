import 'package:flutter/material.dart';
import 'package:practice_area/Models/Models.dart';
import 'package:practice_area/database/database.dart';

class Savescreen extends StatefulWidget {
  const Savescreen({super.key});

  @override
  State<Savescreen> createState() => _SavescreenState();
}

class _SavescreenState extends State<Savescreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  int selectedIndex = 0;
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
  bool isPinned = false;
  bool isArchived = false;
  bool isTrashed = false;
  bool indicator = false;

  Future<void> safeScreen() async {
    if (_title.text
        .trim()
        .isEmpty || _content.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      indicator = true; // 🔄 START loader
    });

    try {
      final notes = NoteModel(
        title: _title.text.trim(),
        content: _content.text.trim(),
        color: selectedColor,
        isPinned: isPinned,
        date: DateTime
            .now()
            .toString()
            .split(" ")
            .first,
        isArchived: isArchived,
        isTrashed: isTrashed,
      );

      await DbHelper.instance.insertNote(notes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note Saved Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("DB Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        indicator = false;
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.push_pin)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.color_lens)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          IconButton(
            onPressed: indicator
                ? null
                : () async {
              await safeScreen();
              Navigator.pop(context);
            },
            icon: indicator
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.check, color: Colors.green),
          ),


        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: _title,
              maxLines: 1,
              maxLength: 50,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'title',
              ),
              style: textTheme.titleLarge!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                CustomButton(
                  selectedIndex: selectedIndex == 1,
                  names: "work",
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                CustomButton(
                  selectedIndex: selectedIndex == 2,
                  names: "ideas",
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
                CustomButton(
                  selectedIndex: selectedIndex == 3,
                  names: " Add Tags",
                  onTap: () {
                    setState(() {
                      selectedIndex = 3;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: _content,
                maxLines: null,
                maxLength: 1000,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'write here...',
                ),
                style: textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: Container(
                    width: selectedColor == color ? 50 : 30,
                    height: selectedColor == color ? 50 : 30,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.selectedIndex,
    required this.names,
    required this.onTap,
  });

  final bool selectedIndex;
  final String names;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(microseconds: 500),

          decoration: BoxDecoration(
            color: selectedIndex ? Colors.grey.shade50 : Colors.white,
            borderRadius: selectedIndex
                ? BorderRadius.circular(20)
                : BorderRadius.circular(10),
            border: selectedIndex
                ? Border.all(color: Colors.black)
                : Border.all(color: Colors.grey.shade500),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              names,
              style: textTheme.bodySmall!.copyWith(
                color: selectedIndex ? Colors.grey.shade900 : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
