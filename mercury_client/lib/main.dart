import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/app.dart';
import 'pages/settings/settings_controller.dart';
import 'pages/settings/settings_service.dart';
import 'config/app_config.dart';

void main() async {
  // needs to be called before any other asynchronous operations in main
  WidgetsFlutterBinding.ensureInitialized();

  // Set up SharedPreferences with a cache to save user info locally
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
        'themeMode',
        'apiEndpoint',
      },
    ),
  );

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService(), sharedPreferences);

  if (AppConfig.useCaching == false) {
    sharedPreferences.clear();
  }

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Pass the preferences to Server Requests so it can see the API Endpoint
  ServerRequests.init(sharedPreferences);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(
      settingsController: settingsController,
      sharedPreferences: sharedPreferences));
}
