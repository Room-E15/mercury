import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/app.dart';
import 'pages/settings/settings_controller.dart';
import 'pages/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // needs to be called before any other asynchronous operations in main

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  final sharedPreferences = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      // When an allowlist is included, any keys that aren't included cannot be used.
      allowList: <String>{
        'registered',
        'id',
        'firstName',
        'lastName',
        'countryCode',
        'phoneNumber',
      },
    ),
  );

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
      settingsController: settingsController,
      sharedPreferences: sharedPreferences));
}
