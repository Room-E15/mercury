import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/data/alert.dart';
import 'package:mercury_client/models/requests/server_requests.dart';

class AlertRequests extends ServerRequests {
  static final subURL = "/alert";

  static Future<void> saveAlert(final String memberId, final String groupId,
      final String title, final String description) async {
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/send'),
      body: {
        'memberId': memberId,
        'groupId': groupId,
        'title': title,
        'description': description,
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      log('Alert saved successfully!');
    } else {
      log('Failed to submit alert to server ${ServerRequests.baseURL}!');
    }
  }

  static Future<List<Alert>> fetchAlerts(final String memberId) async {
    // TODO implement
    log("Fetching alerts");
    final response =
        await get(Uri.parse('${ServerRequests.baseURL}$subURL/get'), headers: {
      'memberId': memberId,
    }).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      log('Alerts fetched successfully!');
      log('Body: ${response.body}');
      // TODO figure out how to decode alerts, this is how caden did it
      // List<dynamic> jsonList = jsonDecode(response.body);
      // List<Group> groupList =
      //     jsonList.map((json) => Group.fromJson(json)).toList();
      // return Future.value(groupList);
      return AlertTestData.alerts;
    } else {
      log('Failed to fetch alerts from server ${ServerRequests.baseURL}!');
      return [];
    }
  }

  static Future<void> saveAlertResponse({required bool isSafe}) async {
    // TODO implement
    log("Alert response sent");
    return Future.delayed(Duration(milliseconds: 500));
  }
}
