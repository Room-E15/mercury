import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:mercury_client/utils/functions.dart';

class RespondAlertRequests extends ServerRequests {
  static final subURL = "/respondAlert";
  static final locationService = LocationService();
  static final batteryService = BatteryService();


  static Future<bool> saveAlertResponse({required String memberId, required String alertId, required bool isSafe}) async {
    final location = await locationService.getCurrentLocation();
    final batteryPercent = await batteryService.getBatteryPercentage();

    // TODO should we await this, and if the server doesn't respond we don't remove the icon?
    final response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/save'),
      body: {
        'memberId': memberId,
        'alertId': alertId,
        'isSafe': isSafe.toString(),
        'latitude': location?.latitude.toString() ?? '',
        'longitude': location?.longitude.toString() ?? '',
        'batteryPercent': batteryPercent.toString(),
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    final success = response.statusCode == 200;
    log("[$subURL] Alert response sent ${success ? 'successfully' : 'unsuccessfully'}");
    return success;
  }

}