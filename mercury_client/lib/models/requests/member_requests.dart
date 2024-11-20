import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/user_info.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:mercury_client/models/data/member.dart';
import 'package:mercury_client/models/responses/user_creation_response.dart';

class MemberRequests extends ServerRequests {
  static const subURL = "/member";
  static const headers = {"Content-Type": "application/json"};

  // returns the user's ID if they were successfully registered
  static Future<String?> requestRegisterUser(UserInfo user) async {
    log('[INFO] Sending user data to server...');
    log('User data: ${user.firstName}, ${user.lastName}, ${user.countryCode}, ${user.phoneNumber}');

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
      log('[ERROR] Failed to send user data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[INFO] User data sent successfully!');
      UserCreationResponse userResponse =
          UserCreationResponse.fromJson(jsonDecode(response.body));
      return userResponse.user?.id;
    } else {
      log('[ERROR] Failed to send user data to server.');
      return null;
    }
  }

  static Future<List<Member>> fetchMembers() async {
    Response response = await get(
      Uri.parse('${ServerRequests.baseURL}$subURL/all'),
      headers: headers,
    );

    return jsonDecode(response.body)
        .map((memberMap) => Member.fromMap(memberMap))
        .toList();
  }
}
