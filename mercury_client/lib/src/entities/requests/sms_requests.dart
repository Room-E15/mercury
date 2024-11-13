import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/src/entities/responses/sms_dispatch_response.dart';
import 'package:mercury_client/src/entities/responses/sms_verify_response.dart';
import 'package:mercury_client/src/entities/requests/server_requests.dart';

class SmsRequests extends ServerRequests {
  static final subURL = "/sms";

  static Future<SMSDispatchResponse> requestSendCode(
      String countryCode, String phoneNumber, String carrier) async {
    log('[INFO] Asking server to send verification code');

    final Response response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/dispatch'),
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