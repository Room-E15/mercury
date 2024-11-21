import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/responses/sms_dispatch_response.dart';
import 'package:mercury_client/models/responses/sms_verify_response.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class SmsRequests extends ServerRequests {
  static final subURL = "/sms";

  static Future<SMSDispatchResponse?> requestSendCode(
      int countryCode, String phoneNumber, String carrier) async {
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
      log('[$subURL] Successfully sent verification code');
      return SMSDispatchResponse.fromJson(jsonDecode(response.body));
    } else {
      log('[$subURL] ERROR: Failed to send verification code: ${response.body}');
      return null;
    }
  }

  // if the user is registered, returns a FullUserInfo object
  // Returns true if code is working and false if it is not
  // Returns the User's Info if they are registered, and null otherwise
  static Future<SMSVerifyResponse> requestCheckCode(
      String code, String token) async {
    log('[INFO] Asking server to check verification code: $code and return registration status');

    final Response response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/verify'),
      body: {
        'token': token,
        'code': code,
      },
    );

    log(response.body);

    return SMSVerifyResponse.fromJson(jsonDecode(response.body));
  }
}