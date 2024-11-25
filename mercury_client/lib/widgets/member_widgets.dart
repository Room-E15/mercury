import 'package:cupertino_battery_indicator/cupertino_battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:url_launcher/url_launcher.dart';

Widget memberWidgetBuilder(
    BuildContext context, RegisteredUser member, bool isLeader) {
  return Row(
    children: [
      member.nameWidgetBuilder(),
      Spacer(),
      !isLeader ? Container() : member.phoneWidgetBuilder(),
    ],
  );
}

Widget leaderWidgetBuilder(BuildContext context, RegisteredUser leader) {
  return Row(
    children: [
      leader.nameWidgetBuilder(),
      Spacer(),
      leader.phoneWidgetBuilder(),
    ],
  );
}

Widget memberWithInfoWidgetBuilder(
    BuildContext context, RegisteredUser leader) {
  return Row(
    children: [
      leader.nameWidgetBuilder(),
      Spacer(),
      IconButton(
          onPressed: () async {
            await _showMemberInfoPopup(context, leader);
          },
          icon: const Icon(Icons.info_outline)),
    ],
  );
}

Future<void> _showMemberInfoPopup(
    BuildContext context, RegisteredUser member) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user doesn't have to tap button
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(children: [
          Text('${member.firstName} ${member.lastName}'),
        ]),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              // Battery Info
              Container(
                child: member.response == null
                    ? null
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: BatteryIndicator(
                                value: (member.response!.battery) / 100),
                          ),
                          Text('${member.response!.battery}%'),
                        ],
                      ),
              ),
              SizedBox(height: 30), 
              // Contact Info
              TextButton(
                onPressed: () async {
                  await launchUrl(Uri.parse(
                      'tel:+${member.countryCode}${member.phoneNumber}'));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone),
                    const Padding(padding: EdgeInsetsDirectional.only(end: 10)),
                    member.phoneWidgetBuilder(),
                  ],
                ),
              ),
              // Location Info
              Container(
                child: member.response == null
                    ? null
                    : TextButton(
                        onPressed: () async {
                          var availableMaps = await MapLauncher.installedMaps;
                          if (availableMaps.isNotEmpty) {
                            await MapLauncher.showMarker(
                              mapType: availableMaps.first.mapType,
                              coords: Coords(member.response!.latitude,
                                  member.response!.longitude),
                              title:
                                  "'${member.firstName} ${member.lastName}'s Location at ${DateTime.now().toIso8601String()}'",
                            );
                          } else {
                            await launchUrl(Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=${member.response!.latitude},${member.response!.longitude}'));
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_on),
                              const Padding(
                                  padding: EdgeInsetsDirectional.only(end: 10)),
                              const Text('View Location'),
                            ])),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
