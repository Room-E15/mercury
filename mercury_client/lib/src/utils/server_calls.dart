import 'dart:convert';
import 'dart:developer';

import 'package:mercury_client/src/entities/responses/sms_dispatch_response.dart';
import 'package:mercury_client/src/entities/responses/sms_verify_response.dart';
import 'package:mercury_client/src/entities/user_info.dart';
import 'package:mercury_client/src/services/globals.dart';
import 'package:http/http.dart';


Future<SMSDispatchResponse> requestServerSendCode(
    String countryCode, String phoneNumber, String carrier) async {
  log('[INFO] Asking server to send verification code');

  final uri = Uri.parse('$baseURL/sms/dispatch');
  final Response response = await post(
    uri,
    body: {
      'countryCode': "1",
      'phoneNumber': phoneNumber,
      'carrier': "att",
    },
  );
  
  return SMSDispatchResponse.fromJson(jsonDecode(response.body));
}

// if the user is registered, returns a FullUserInfo object
// Returns true if code is working and false if it is not
// Returns the User's Info if they are registered, and null otherwise
Future<SMSVerifyResponse> requestServerCheckCode(
    String code, String token) async {
  log('[INFO] Asking server to check verification code: $code and return registration status');

  final uri = Uri.parse('$baseURL/sms/verify');
  final Response response = await post(
    uri,
    body: {
      'token': token,
      'code': code,
    },
  );

  print(response.body);

  return SMSVerifyResponse.fromJson(jsonDecode(response.body));
}

// returns the user's ID if they were successfully registered
Future<String?> requestServerRegisterUser(UserInfo user) async {
  log('[INFO] Sending user data to server...');

  // Prepare the data for the HTTP request
    final uri = Uri.parse('$baseURL/demo/add');
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
