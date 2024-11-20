import 'dart:convert';
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
      log('[$subURL] Alert saved successfully!');
    } else {
      log('[$subURL] Failed to submit alert to server ${ServerRequests.baseURL}!');
    }
  }

  static Future<List<Alert>> fetchAlerts(final String memberId) async {
    log("[$subURL] Fetching alerts");
    final response = await get(
      Uri.parse('${ServerRequests.baseURL}$subURL/get'),
      headers: {
        'memberId': memberId,
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      log('[$subURL] Alerts fetched successfully!');
      log('[$subURL] Body: ${response.body}');

      List<dynamic> jsonList = jsonDecode(response.body);
      List<Alert> alerts = jsonList
          .map((json) => Alert.fromJson(json))
          .toList();

      // now that we have the alerts, we can mark them as read
      // TODO guard behind checking if alerts list is empty, we don't need to mark as read if there are no alerts
      put(
        Uri.parse('${ServerRequests.baseURL}$subURL/confirm'),
        body: {
        'memberId': memberId,
        'alerts': response.body,
      });

      return alerts;
    } else {
      log('[$subURL] Failed to fetch alerts: ${response.body}');

      return [];
    }
  }

  static Future<void> saveAlertResponse({required bool isSafe}) async {
    // TODO implement
    log("[$subURL] Alert response sent");
    return Future.delayed(Duration(milliseconds: 500));
  }
}
