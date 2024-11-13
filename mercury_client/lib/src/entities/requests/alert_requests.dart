import 'dart:developer';

import 'package:mercury_client/src/entities/data/alert.dart';
import 'package:mercury_client/src/entities/requests/server_requests.dart';

class AlertRequests extends ServerRequests {
  static final subURL = "/alert";


  static Future<List<Alert>> fetchAlerts() async {
    // TODO implement
    log("Fetching alerts");
    return Future.delayed(Duration(seconds: 5)).then((value) {
      return AlertTestData.alerts;
    });
  }

  static Future<void> saveResponse({required bool isSafe}) async {
    // TODO implement
    log("Alert response sent");
    return Future.delayed(Duration(milliseconds: 500));
  }

}