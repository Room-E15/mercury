import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class GroupRequests extends ServerRequests {
  static final subURL = '/group';

  // loads in the group objects to use for the dashboard
  static Future<List<Group>> fetchGroups(String memberId) async {
    log('[$subURL] Querying server for groups...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/getGroups'),
      body: {
        'memberId': memberId.toString(),
      },
    ).onError((obj, stackTrace) {
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[$subURL] Group identification data sent successfully!');
    } else {
      log('[$subURL] ERROR: Failed to send group identification to server.');
      // TODO figure out something better to do if registration fails
    }

    log('[$subURL] Body: ${response.body}');

    try {
      // recursively parse json response body
      final parsedJsonList = jsonDecode(response.body) as List<dynamic>;
      return parsedJsonList.map((json) {
        if (json is Map<String, dynamic>) {
          return Group.fromJson(json);
        } else {
          throw Exception('Failed to cast $json to Map<String, dynamic>');
        }
      }).toList();
    } catch (e) {
      log('[$subURL] ERROR: Failed to parse group data from server: $e');
      return [];
    }
  }

  static Future<void> requestCreateGroup(
      String memberId, String groupName) async {
    log('[$subURL] Requesting Group creation...');

    // Prepare the data for the HTTP request
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/createGroup'),
      body: {
        'memberId': memberId,
        'groupName': groupName,
      },
    ).onError((obj, stackTrace) {
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[$subURL] Group data sent successfully!');
    } else {
      log('[$subURL] ERROR: Failed to send group data to server.');
    }
  }

// allows the member to join another group
  static Future<void> requestJoinGroup(String memberId, String groupId) async {
    log('[$subURL] Requesting Group join...');

    // Prepare the data for the HTTP request
    final uri = Uri.parse('${ServerRequests.baseURL}$subURL/joinGroup');
    final response = await post(
      uri,
      body: {
        'memberId': memberId,
        'groupId': groupId,
      },
    ).onError((obj, stackTrace) {
      return Response('', 500);
    });

    // Log response
    if (response.statusCode == 200) {
      log('[$subURL] Join group data sent successfully!');
    } else {
      log('[$subURL] ERROR: Failed to send group join information to server.');
      // TODO figure out something better to do if registration fails
    }
  }
}
