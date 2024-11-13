import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/src/entities/data/user_info.dart';
import 'package:mercury_client/src/entities/requests/server_requests.dart';

class MemberRequests extends ServerRequests {
  static final subURL = "/member";

  // returns the user's ID if they were successfully registered
  static Future<String?> requestRegisterUser(UserInfo user) async {
    log('[INFO] Sending user data to server...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/addMember'),
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
}