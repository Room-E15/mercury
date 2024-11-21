import 'dart:developer';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class BatteryService {
  final Battery _battery = Battery();

  Future<int> getBatteryPercentage() async {
    return -1;
    try {
      return await _battery.batteryLevel;
    } on PlatformException catch (error) {
      log('Failed to get battery percentage: $error');
      // TODO can this return be better?
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
        log('[Location] Location services are disabled.');
        return null;
      }

      // Check location permissions
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('[Location] Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        log('[Location] Location permissions are permanently denied.');
        return null;
      }

      // Fetch the current position with exception handling
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      // Handle any exceptions thrown by Geolocator
      log('[Location] Failed to get location: $e');
      return null;
    }
  }
}
