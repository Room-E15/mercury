import 'dart:developer';

import 'package:mercury_client/src/entities/user_info.dart';
import 'package:mercury_client/src/services/globals.dart';
import 'package:http/http.dart';


Future<void> requestServerSendCode(
    String countryCode, String phoneNumber, String carrier) async {
  // TODO implement
  log('[INFO] Asking server to send verification code');
  return Future.delayed(const Duration(seconds: 2));
}

// if the user is registered, returns a FullUserInfo object
// Returns true if code is working and false if it is not
// Returns the User's Info if they are registered, and null otherwise
Future<(bool, RegisteredUserInfo?)> requestServerCheckCode(
    String code, String countryCode, String phoneNumber) async {
  // TODO implement, currently placeholder
  log('[INFO] Asking server to check verification code: $code');
  log('[INFO] Checking server for phone registration status...');

  return Future.delayed(const Duration(seconds: 2), () {
    // temp code check, temp user is not registered return
    return (code == '1234', null);
  });
}

// returns the user's ID if they were successfully registered
Future<String?> requestServerRegisterUser(UserInfo user) async {
  log('[INFO] Sending user data to server...');

  // Prepare the data for the HTTP request
    final uri = Uri.parse('$baseURL/add');
    final response = await post(
      uri,
      body: {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'countryCode': user.countryCode,
        'phoneNumber': user.phoneNumber,
      },
    ).onError((obj, stackTrace) {
      log('[ERROR] Failed to send user data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[INFO] User data sent successfully!');
      return response.body;
    } else {
      log('[ERROR] Failed to send user data to server.');
      return null;
    }
}
