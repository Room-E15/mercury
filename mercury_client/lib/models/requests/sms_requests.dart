import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class SmsRequests extends ServerRequests {
  static final subURL = '/sms';

  static Future<String?> requestSendCode(
      int countryCode, String phoneNumber, String carrier) async {
    String? token;
    log('[$subURL] Asking server to send verification code');

    final Response response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/dispatch'),
      body: {
        'countryCode': countryCode.toString(),
        'phoneNumber': phoneNumber,
        'carrier': carrier.toLowerCase(),
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)
          case {
            'carrierFound': bool carrierFound,
            // TODO change pattern once API is updated
            'token': String? recievedToken,
          }) {
        if (carrierFound) {
          token = recievedToken;
          log('[$subURL] Successfully sent verification code');
        } else {
          log('[$subURL] ERROR: Carrier not found');
        }
      } else {
        log('[$subURL] ERROR: Failed to decode json: ${response.body}');
      }
    } else {
      log('[$subURL] ERROR: Failed to send verification code: ${response.body}');
    }

    return token;
  }

  // if the user is registered, returns a FullUserInfo object
  // Returns true if code is working and false if it is not
  // Returns the User's Info if they are registered, and null otherwise
  static Future<(bool, RegisteredUser?)> requestCheckCode(
      String code, String token) async {
    log('[$subURL] Asking server to check verification code: $code and return registration status');

    final Response response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/verify'),
      body: {
        'token': token,
        'code': code,
      },
    );

    log('[$subURL] verification status: ${response.body}');

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['correctCode'] is! bool) {
        throw Exception('Failed to parse correctCode from JSON: $json');
      }

      final correctCode = json['correctCode'] as bool;
      log('[$subURL] Successfully checked verification code');

      if (correctCode && json['userInfo'] is Map<String, dynamic>) {
        final userInfo = json['userInfo'] as Map<String, dynamic>;
        final user = RegisteredUser.fromJson(userInfo);
        return (true, user);
      } else {
        return (correctCode, null);
      }
    } catch (e) {
      log('[$subURL] ERROR: Failed to decode json: ${response.body}');
    }
    return (false, null);
  }
}
