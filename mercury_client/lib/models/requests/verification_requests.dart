import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/carrier_tab_list.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class VerificationRequests extends ServerRequests {
  static final subURL = "/v";
  static const headers = {"Content-Type": "application/json"};

  static Future<CarrierTabList?> requestCarrierLists() async {
    log('[$subURL] Asking server for carrier list');

    final Response response = await get(
      Uri.parse('${ServerRequests.baseURL}$subURL/carriers'),
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      log('json: $json');

      // try and decode response to get member id
      if (json is List) {
        log('[$subURL] Successfully received carrier list');

        return CarrierTabList.fromJson(json.cast<Map<String, dynamic>>());

        // if there was an error, log it
      } else if (json
          case {
            'status': String _,
            'error': String error,
          }) {
        log('[$subURL] ERROR: $error');
        return null;
      }
      log('[$subURL] Did not meet any conditions');
      return null;
    } else {
      log('[$subURL] ERROR: Failed to receive carrier list: ${response.body}');
      return null;
    }
  }

  static Future<String?> requestDispatch(
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
      return null;
    }
    return token;
  }

  // if the user is registered, returns a FullUserInfo object
  // Returns true if code is working and false if it is not
  // Returns the User's Info if they are registered, and null otherwise
  static Future<(bool, RegisteredUser?)> requestVerifyCode(
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

  // returns the user's ID if they were successfully registered
  // TODO consider refactoring, this design is kind of disgusting
  static Future<RegisteredUser?> requestRegisterUser(
      String token, String firstName, String lastName) async {
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


    log('[$subURL] verification status: ${response.body}');

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return RegisteredUser.fromJson(json);
    } catch (e) {
      log('[$subURL] ERROR: Failed to decode json: ${response.body}');
    }
    return null;

    // Log response
    // if (response.statusCode == 200) {
    //   log('[INFO] User data sent successfully!');
    //   UserCreationResponse userResponse =
    //       UserCreationResponse.fromJson(jsonDecode(response.body));
    //   return userResponse;
    // } else {
    //   log('[$subURL] Failed to send user data to server.');
    //   return null;
    // }
  }
}