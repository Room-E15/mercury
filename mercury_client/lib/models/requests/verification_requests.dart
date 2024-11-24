import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/responses/carrier_list_response.dart';
import 'package:mercury_client/models/responses/sms_dispatch_response.dart';
import 'package:mercury_client/models/responses/sms_verify_response.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:mercury_client/models/responses/user_creation_response.dart';


class VerificationRequests extends ServerRequests {
  static final subURL = "/v";
  static const headers = {"Content-Type": "application/json"};

  static Future<CarrierListResponse?> requestCarrierLists() async {
    log('[$subURL] Asking server for carrier list');

    final Response response = await get(
      Uri.parse('${ServerRequests.baseURL}$subURL/carriers'),
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      log('[$subURL] Successfully received carrier list');
      return CarrierListResponse.fromJson(response.body);
    } else {
      log('[$subURL] ERROR: Failed to receive carrier list: ${response.body}');
      return null;
    }
  }

  static Future<SMSDispatchResponse?> requestDispatch(
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
  static Future<SMSVerifyResponse> requestVerifyCode(
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

  // returns the user's ID if they were successfully registered
  // TODO consider refactoring, this design is kind of disgusting
  static Future<UserCreationResponse?> requestRegisterUser(String token, String firstName, String lastName) async {
    log('[$subURL] Sending user data to server...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/register'),
      body: {
        'token': token,
        'firstName': firstName,
        'lastName': lastName,
      },
    ).onError((obj, stackTrace) {
      log('[$subURL] Failed to send user data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[INFO] User data sent successfully!');
      UserCreationResponse userResponse =
          UserCreationResponse.fromJson(jsonDecode(response.body));
      return userResponse;
    } else {
      log('[$subURL] Failed to send user data to server.');
      return null;
    }
  }
}