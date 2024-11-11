import 'dart:convert';
import 'dart:developer';

import 'package:mercury_client/src/entities/user_info.dart';
import 'package:mercury_client/src/entities/group.dart';
import 'package:mercury_client/src/services/globals.dart';
import 'package:http/http.dart';

Future<bool> requestServerCheckCode(
    String code, String countryCode, String phoneNumber) async {
  // TODO implement, currently placeholder
  log('Asking server to check verification code: $code');

  return Future.delayed(const Duration(seconds: 2), () {
    return code == '1234';
  });
}

Future<void> requestServerSendCode(
    String countryCode, String phoneNumber, String carrier) async {
  // TODO implement
  log('Asking server to check verification code');
}

// returns the user's ID if they were successfully registered
Future<String?> requestServerRegisterUser(UserInfo user) async {
  log('[INFO] Sending user data to server...');

  // Prepare the data for the HTTP request
    final uri = Uri.parse('$baseURL/member/addMember');
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

// loads in the group objects to use for the dashboard
Future<List<Group>> fetchServerGroups(String memberId) async {
  // TODO implement and make async
  log('Querying server for groups...');

  // Prepare the data for the HTTP request
  final uri = Uri.parse('$baseURL/group/getGroups');
  final response = await post(
    uri,
    body: {
      'memberId': memberId.toString(),
    },
  ).onError((obj, stackTrace) {
    log('[ERROR] Failed to send group data to server.');
    return Response('', 500);
  });

  // Log response
  if (response.statusCode == 200) {
    log('[INFO] Group identification data sent successfully!');
  } else {
    log('[ERROR] Failed to send group identification to server.');
    // TODO figure out something better to do if registration fails
  }

  log("Body: ${response.body}");
  List<dynamic> jsonList = jsonDecode(response.body);
  List<Group> groupList = jsonList.map((json) => Group.fromJson(json)).toList();
  return Future.value(groupList);
}

// loads in the group objects to use for the dashboard
Future<void> requestServerCreateGroup(String memberId, String groupName) async {
  log('Requesting Group creation...');

  // Prepare the data for the HTTP request
  final uri = Uri.parse('$baseURL/group/createGroup');
  final response = await post(
    uri,
    body: {
      'memberId': memberId,
      'groupName': groupName,
    },
  ).onError((obj, stackTrace) {
    log('[ERROR] Failed to send group data to server.');
    return Response('', 500);
  });

  // Log response
  if (response.statusCode == 200) {
    log('[INFO] Group data sent successfully!');
  } else {
    log('[ERROR] Failed to send group information to server.');
    // TODO figure out something better to do if registration fails
  }
}
