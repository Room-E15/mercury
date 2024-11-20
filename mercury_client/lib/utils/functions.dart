import 'dart:developer';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> getBatteryPercentage() async {
    try {
      // Fetch the battery level
      int batteryLevel = await _battery.batteryLevel;
      return batteryLevel;
    } catch (e) {
      // Handle any errors
      log('Failed to get battery percentage: $e');
      return -1; // Return -1 or another fallback value to indicate an error
    }
  }
}

class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log('Location services are disabled.');
        return null;
      }

      // Check location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        return null;
      }

      // Use the locationSettings parameter
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.best, // Adjust accuracy as needed
      );

      // Fetch the current position with exception handling
      return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    } catch (e) {
      // Handle any exceptions thrown by Geolocator
      log('Failed to get location: $e');
      return null;
    }
  }
}
