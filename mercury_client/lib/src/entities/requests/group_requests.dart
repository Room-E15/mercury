import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/src/entities/data/group.dart';
import 'package:mercury_client/src/entities/requests/server_requests.dart';

class GroupRequests extends ServerRequests {
  static final subURL = "/group";

  // loads in the group objects to use for the dashboard
  static Future<List<Group>> fetchGroups(String memberId) async {
    log('Querying server for groups...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/getGroups'),
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
    List<Group> groupList =
        jsonList.map((json) => Group.fromJson(json)).toList();
    return Future.value(groupList);
  }

  static Future<void> requestCreateGroup(
      String memberId, String groupName) async {
    log('Requesting Group creation...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/createGroup'),
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
      log('[ERROR] Failed to send group data to server.');
    }
  }

// allows the member to join another group
  static Future<void> requestJoinGroup(String memberId, String groupId) async {
    log('Requesting Group join...');

    // Prepare the data for the HTTP request
    final uri = Uri.parse('${ServerRequests.baseURL}$subURL/joinGroup');
    final response = await post(
      uri,
      body: {
        'memberId': memberId,
        'groupId': groupId,
      },
    ).onError((obj, stackTrace) {
      log('[ERROR] Failed to send group join packet data to server.');
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[INFO] Join group data sent successfully!');
    } else {
      log('[ERROR] Failed to send group join information to server.');
      // TODO figure out something better to do if registration fails
    }
  }
}
