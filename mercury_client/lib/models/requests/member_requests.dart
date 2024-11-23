import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class MemberRequests extends ServerRequests {
  static const subURL = '/member';
  static const headers = {'Content-Type': 'application/json'};

  // returns the user's ID if they were successfully registered
  static Future<String?> requestRegisterUser(User user) async {
    log('[$subURL] Sending user data to server...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/addMember'),
      body: {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'countryCode': user.countryCode.toString(),
        'phoneNumber': user.phoneNumber,
      },
    ).onError((obj, stackTrace) {
      log('[$subURL] Failed to send user data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // try and decode response to get member id
      if (json
          case {
            'user': Map<String, dynamic> member,
          }) {
        log('[$subURL] User registered successfully!');
        return RegisteredUser.fromJson(member).id;

        // if there was an error, log it
      } else if (json
          case {
            'status': String _,
            'error': String error,
          }) {
        log('[$subURL] ERROR: $error');
        return null;
      }
    }

    // if we made it here, the response returned with a bad status code
    log('[$subURL] Failed to send user data to server.');
    return null;
  }
}
