import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getlocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print(permission);
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 100,
    );
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
