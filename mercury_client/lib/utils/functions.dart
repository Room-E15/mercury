import 'dart:developer';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatteryService {
  static final Battery _battery = Battery();

  static Future<int> getBatteryPercentage() async {
    var batteryLevel = -1;
    try {
      batteryLevel = await _battery.batteryLevel;
    } on PlatformException catch (e) {
      log('[Battery] Failed to get battery level: $e');
    }
    return batteryLevel;
  }
}

class LocationService {
  static Future<Position?> getCurrentLocation() async {
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

void clearUserData(SharedPreferencesWithCache preferences) {
  preferences.remove('registered');
  preferences.remove('id');
  preferences.remove('firstName');
  preferences.remove('lastName');
  preferences.remove('countryCode');
  preferences.remove('phoneNumber');
}
