import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final colorcontroller = TextEditingController();
  final soundcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          textfield(
            controllor: colorcontroller,
            label: "Color",
            text: "Enter your color name",
            color: Colors.grey.shade200,
            icon: Icon(Icons.abc),
          ),
          SizedBox(height: 10),
          textfield(
            controllor: soundcontroller,
            label: "Sound",
            text: "Enter your Sound num",
            color: Colors.grey.shade200,
            icon: Icon(Icons.format_list_numbered_rtl_outlined),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey,elevation: 10),
            onPressed: () {
              String color = colorcontroller.text.trim();
              int soundNum = int.tryParse(soundcontroller.text) ?? 1;
              Navigator.push(context, MaterialPageRoute(builder: (_)=>XyloScreen(color: color, sound: soundNum)));
            },
            child: Text("Pressed here"),

          ),
        ],
      ),
    );
  }
}
class textfield extends StatelessWidget {
  final TextEditingController controllor;
  final String label;
  final String text;
  final Color color;
  final Icon icon;

  const textfield({
    super.key,
    required this.controllor,
    required this.label,
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controllor,
        decoration: InputDecoration(
          labelText: label,
          hintText: text,
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          suffixIcon: icon,
        ),
      ),
    );
  }
}
class XyloScreen extends StatelessWidget {
  final String color;
  final int sound;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
   XyloScreen({super.key, required this.color, required this.sound});
Color getColorFromName(String name){
  switch(name.toLowerCase()) {
    case"red":
      return Colors.red;
    case "orange":
      return Colors.orange;
    case "yellow":
      return Colors.yellow;
    case "green":
      return Colors.green;
    case "teal":
      return Colors.teal;
    case "blue":
      return Colors.blue;
    case "purple":
      return Colors.purple;
    case "pink":
      return Colors.pink;
    default:
      return Colors.grey;
  }
}
  void playSound(int num) {
    player.open(
      Audio("assets/note$num.wav"),
    );
  }
  @override
  Widget build(BuildContext context) {
  Color barcode = getColorFromName(color);
    return Scaffold(
      appBar: AppBar(title: Text("Xylophone Player")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: barcode,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: TextButton(
                  onPressed: () => playSound(sound),
                  child: Text(
                    "${color.toUpperCase()} (Sound $sound)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}