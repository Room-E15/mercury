
import 'package:mercury_client/models/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logUserInfo(
    SharedPreferencesWithCache prefs, RegisteredUser user) async {
  await prefs.setBool('registered', true);
  await prefs.setString('id', user.id);
  await prefs.setString('firstName', user.firstName);
  await prefs.setString('lastName', user.lastName);
  await prefs.setInt('countryCode', user.countryCode);
  await prefs.setString('phoneNumber', user.phoneNumber);
}

