import '../screens/location.dart';
import '../services/networking.dart';

const openbyurl = "https://api.openweathermap.org/data/2.5/weather";

class WeatherModel {
  Future<dynamic> byName(String nam) async {
    Networkhelper network = Networkhelper(
        "$openbyurl?q=$nam&appid=4bca65322553d4a34a3307c076598ac0&units=metric"
    );
    var oww = await network.getData();
    return oww;
  }

  Future<dynamic> getter() async {
    Location location = Location();
    await location.getlocation();
    Networkhelper networkhelper = Networkhelper(
      "https://api.openweathermap.org/data/2.5/weather?lat=${location
          .latitude}&lon=${location
          .longitude}&appid=4bca65322553d4a34a3307c076598ac0&units=metric",
    );
    var datadecode = await networkhelper.getData();
    return datadecode;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return "🌩";
    } else if (condition < 400) {
      return "🌧";
    } else if (condition < 600) {
      return "🌦";
    } else if (condition < 700) {
      return "🌨";
    } else if (condition < 800) {
      return "🌫";
    } else if (condition == 800) {
      return "☀️";
    } else if (condition <= 804) {
      return "☁️";
    } else {
      return "🤷‍";
    }
  }

  String getMessage(double temp) {
    if (temp > 30) {
      return "It‘s 🍦 time";
    } else if (temp > 20) {
      return "Time for shorts and 👕";
    } else if (temp < 10) {
      return "You'll need 🧣 and 🧤";
    } else {
      return "Bring a 🧥 just in case";
    }
  }
}
