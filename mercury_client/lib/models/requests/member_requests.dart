import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/user_info.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:mercury_client/models/data/member.dart';

class MemberRequests extends ServerRequests {
  static const subURL = "/member";
  static const headers = {"Content-Type": "application/json"};

  // returns the user's ID if they were successfully registered
  // TODO consider refactoring, this design is kind of disgusting
  static Future<String?> requestRegisterUser(UserInfo user) async {
    log('[$subURL] Sending user data to server...');

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
      log('[$subURL] Failed to send user data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[$subURL] User data sent successfully!');
      final user = jsonDecode(response.body)['user'];
      if (user == null) {
        log('[$subURL] Failed to send user data to server.');
        return null;
      }

      return user['id'];
    } else {
      log('[$subURL] Failed to send user data to server.');
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
