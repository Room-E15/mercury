import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/data/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T?> showPopup<T>(BuildContext context, String title, String content,
    {String? buttonText}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      );
    },
  );
}

Future<void> logUserInfo(
    SharedPreferencesWithCache prefs, RegisteredUserInfo user) async {
  await prefs.setBool('registered', true);
  await prefs.setString('id', user.id);
  await prefs.setString('firstName', user.firstName);
  await prefs.setString('lastName', user.lastName);
  await prefs.setString('countryCode', user.countryCode);
  await prefs.setString('phoneNumber', user.phoneNumber);
}

bool isRegistered(SharedPreferences prefs) {
  return prefs.getBool('registered') == true;
}

Future<void> awaitAll(List<Future> futures) async {
  for (var future in futures) {
    await future;
  }
}
