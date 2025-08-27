import 'package:flutter/material.dart';
import 'package:weather_new_one/screens/CityScreen.dart';
import 'package:weather_new_one/services/weather.dart';

class Widgetdesign extends StatefulWidget {
  const Widgetdesign({super.key, required this.Locationweather});

  final Locationweather;

  @override
  State<Widgetdesign> createState() => _WidgetdesignState();
}

class _WidgetdesignState extends State<Widgetdesign> {
  WeatherModel weathers = WeatherModel();
  double? temperature;
  late String weathericon;

  late String weathertemp;
  String? city;
  String? descriptions;

  @override
  void initState() {
    super.initState();
    updateui(widget.Locationweather);
  }

  void updateui(dynamic weatherdata) {
    if (weatherdata == null) {
      temperature = 0;
      weathertemp = "none";
      weathericon = "not available";
      city = "unknown";
      return;
    }
    temperature = weatherdata["main"]["temp"];
    weathertemp = weathers.getMessage(weatherdata["main"]["temp"]);
    weathericon = weathers.getWeatherIcon(weatherdata["weather"][0]["id"]);
    city = weatherdata["name"];

    descriptions = weatherdata["weather"][0]["main"];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send, size: 25),
                  color: Colors.white,
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    var typedNames = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CityName();
                        },
                      ),
                    );
                    if (typedNames != null) {
                     var iconss= await WeatherModel().byName(typedNames);
                     setState(() {
                       updateui(iconss);
                     });
                    }
                  },
                  icon: Icon(Icons.account_balance_sharp, size: 25),
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
            child: Container(
              height: size.height * 0.30,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Colors.black12,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "$city",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$temperature",
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 80,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        weathericon,
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "$descriptions",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: size.height * 0.15,
              width: size.width * 0.90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(1, 1),
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$weathertemp in $city",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
