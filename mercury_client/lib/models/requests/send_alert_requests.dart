import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/config/app_config.dart';
import 'package:mercury_client/models/data/alert.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendAlertRequests extends ServerRequests {
  static final subURL = '/sendAlert';

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

  // band-aid solution to have alerts fetched in the background while app running
  static Future<void> backgroundFetchAlerts({
    required final SharedPreferencesWithCache preferences,
    required final String memberId,
    required final Iterable<Alert> ignored,
    required final Future<void> Function(List<Alert>) onNewAlert,
  }) async {
    while (preferences.getBool('registered') == true) {
      var future = fetchAlerts(memberId, ignored).then(onNewAlert).onError((error, stackTrace) {});
      await Future.delayed(Duration(milliseconds: AppConfig.alertRefreshRate));
      await future;
    }
  }

  static Future<List<Alert>> fetchAlerts(final String memberId, final Iterable<Alert> ignored) async {
    log('[$subURL] Fetching alerts');
    final response = await get(
      Uri.parse('${ServerRequests.baseURL}$subURL/get'),
      headers: {
        'memberId': memberId,
        'ignoreAlertIds': jsonEncode(ignored.map((alert) => alert.id).toList()),
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    if (response.statusCode == 200) {
      log('[$subURL] Alerts fetched: ${response.body}');
      List<Alert> alerts = [];

      try {
        alerts = (jsonDecode(response.body) as List<dynamic>).map((json) {
          return Alert.fromJson(json as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        log('[$subURL] Failed to parse alerts: $e');
      }

      if (alerts.isNotEmpty) {
        // now that we have the alerts, we can mark them as read
        put(Uri.parse('${ServerRequests.baseURL}$subURL/confirm'), body: {
          'memberId': memberId,
          'jsonAlertIds': jsonEncode(alerts.map((alert) => alert.id).toList()),
        }).onError((error, stackTrace) => Response('', 500));
      }

      return alerts;
    } else {
      log('[$subURL] Failed to fetch alerts: ${response.body}');
      return [];
    }
  }
}
