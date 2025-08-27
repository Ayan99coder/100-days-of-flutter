import 'package:flutter/material.dart';
import 'package:weather_new_one/UI/locationScreen.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_new_one/services/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage(), debugShowCheckedModeBanner: false);
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    getLocationInfo();
  }

  void getLocationInfo() async {
    var datadecode =await WeatherModel().getter();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Widgetdesign(Locationweather: datadecode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(child: SpinKitDoubleBounce(size: 100, color: Colors.black)),
    );
  }
}
