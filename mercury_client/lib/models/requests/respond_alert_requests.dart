import 'dart:developer';

import 'package:http/http.dart';
import 'package:mercury_client/models/requests/server_requests.dart';
import 'package:mercury_client/utils/functions.dart';

class RespondAlertRequests extends ServerRequests {
  static final subURL = "/respondAlert";
  static final locationService = LocationService();
  static final batteryService = BatteryService();


  static Future<bool> saveAlertResponse({required String memberId, required bool isSafe}) async {
    final location = await locationService.getCurrentLocation();
    final batteryPercentage = await batteryService.getBatteryPercentage();

    // TODO should we await this, and if the server doesn't respond we don't remove the icon?
    var response = await post(
      Uri.parse('${ServerRequests.baseURL}$subURL/save'),
      body: {
        'memberId': memberId,
        'isSafe': isSafe.toString(),
        'latitude': location?.latitude.toString() ?? '',
        'longitude': location?.longitude.toString() ?? '',
        'batteryPercentage': batteryPercentage.toString(),
      },
    ).onError((error, stackTrace) {
      return Response('', 500);
    });

    log("[$subURL] Alert response sent");
    return response.statusCode == 200;
  }

}