import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int count = 0;
  int phase = 0;
  final List<String> zikr = ["سُبْحَانَ ٱللّٰه", "اَلْـحَمْدُ لِلّٰه", "ٱللّٰهُ أَكْبَر"];
  final List<int> limits = [33, 33, 34];

  void _increment() {
    setState(() {
      count++;
      if (count > limits[phase]) {
        if (phase < zikr.length - 1) {
          phase++;
          count = 1;
        } else {
          phase = 0;
          count = 0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Tasbeeh-e-Fatima completed ")),
          );
        }
      }
    });
  }

  void _decrement() {
    setState(() {
      if (count > 0) {
        count--;
      }
    });
  }

  void _reset() {
    setState(() {
      count = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF004d00),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 80),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    zikr[phase],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 5,
                  alignment: Alignment.center,
                  shape: CircleBorder(),
                  fixedSize: Size(300, 300),
                ),
                onPressed: () {_increment();},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$count",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 80,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _reset();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        elevation: 5,
                        alignment: Alignment.center,
                        shape: CircleBorder(),
                        fixedSize: Size(100, 100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {_decrement();},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        elevation: 5,
                        alignment: Alignment.center,
                        shape: CircleBorder(),
                        fixedSize: Size(100, 100),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rotate_90_degrees_ccw_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
