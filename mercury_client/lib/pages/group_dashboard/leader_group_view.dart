import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/pages/settings/settings_view.dart';
import 'package:mercury_client/pages/send_alert/send_alert_view.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/models/data/member.dart';
import 'package:mercury_client/pages/join_server_prompt/join_server_prompt_view.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';
import 'package:mercury_client/pages/qr/qr_present_view.dart';

class LeaderGroupView extends StatelessWidget {
  const LeaderGroupView({
    super.key,
    required this.group,
    required this.preferences,
  });

  final Group group;

  final SharedPreferencesWithCache preferences;

  Widget _memberWidgetBuilder(context, index, memberList) {
    final member = memberList[index];

    return Row(
      children: [
        Text(
          "${member.firstName} ${member.lastName}",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Text("+${member.countryCode} ${member.phoneNumber}",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Member> unsafe = getUnsafeResponses();
    final List<Member> safe = getSafeResponses();
    final List<Member> noResponse = getNoResponses();

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: SafeArea(
        child: Drawer(child: Builder(builder: (BuildContext context2) {
          return Column(children: [
            Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: appLogo),
            TextButton(
                child: const Row(children: [
                  Icon(Icons.settings),
                  Padding(padding: EdgeInsetsDirectional.only(end: 10)),
                  Text("Settings")
                ]),
                onPressed: () {
                  Scaffold.of(context2).closeDrawer();
                  Navigator.restorablePushNamed(
                      context, SettingsView.routeName);
                }),
            TextButton(
                child: const Row(children: [
                  Icon(Icons.door_back_door),
                  Padding(padding: EdgeInsetsDirectional.only(end: 10)),
                  Text("Leave Server")
                ]),
                onPressed: () {
                  Scaffold.of(context2).closeDrawer();
                  Navigator.restorablePushNamed(
                      context, JoinServerPromptView.routeName);
                })
          ]);
        })),
      ),
      appBar: AppBar(
        title: appLogo,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, ProfileView.routeName);
              },
              icon: const Icon(Icons.person_rounded))
        ],
      ),
      body: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            margin: const EdgeInsetsDirectional.symmetric(
                vertical: 10.0, horizontal: 20.0),
            child: InkWell(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      // QR Code screen
                                      QRPresentView(
                                          key: key,
                                          groupId: group.id,
                                          groupName: group.name),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_circle_outline,
                                size: 40, color: Color(0xFF4F378B))),
                      ],
                    ),
                  ),
                  if (group.isLeader)
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SendAlertView(preferences: preferences, group: group),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("SEND ALERT"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            margin: const EdgeInsetsDirectional.symmetric(
                vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            color: Colors.black,
                          ),
                          const Padding(
                              padding: EdgeInsetsDirectional.only(end: 8)),
                          Text(
                            "${unsafe.length} ${unsafe.length == 1 ? "Member" : "Members"} NOT OK",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 6, 16, 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    restorationId: 'unsafeList',
                    itemCount: unsafe.length, // Number of blank cards
                    // build all the group tiles dynamically using builder method
                    itemBuilder: (context, index) {
                      return _memberWidgetBuilder(context, index, unsafe);
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            margin: const EdgeInsetsDirectional.symmetric(
                vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.black,
                          ),
                          const Padding(
                              padding: EdgeInsetsDirectional.only(end: 8)),
                          Text(
                            "Waiting for ${noResponse.length} ${noResponse.length == 1 ? "Response" : "Responses"}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 6, 16, 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    restorationId: 'noResponseList',
                    itemCount: noResponse.length, // Number of blank cards
                    // build all the group tiles dynamically using builder method
                    itemBuilder: (context, index) {
                      return _memberWidgetBuilder(context, index, noResponse);
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            margin: const EdgeInsetsDirectional.symmetric(
                vertical: 10.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_outlined,
                            color: Colors.black,
                          ),
                          const Padding(
                              padding: EdgeInsetsDirectional.only(end: 8)),
                          Text(
                            "${safe.length} ${safe.length == 1 ? "Member" : "Members"} OK",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 6, 16, 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    restorationId: 'safeList',
                    itemCount: safe.length, // Number of blank cards
                    // build all the group tiles dynamically using builder method
                    itemBuilder: (context, index) {
                      return _memberWidgetBuilder(context, index, safe);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Member> getSafeResponses() {
    log("Querying for safe responses");

    return [
      Member("3", "Julius", "Caesar", "1", "1234567890", GroupResponse(true, 97, 10.0, 10.0)),
      Member("6", "Ramos", "Remus", "1", "1234567890", GroupResponse(true, 23, 10.0, 10.0)),
      Member(
          "1", "Albert", "Einstein", "1", "1234567890", GroupResponse(true, 73, 10.0, 10.0)),
      Member(
          "2", "Giorno", "Giovanna", "1", "1098765432", GroupResponse(true, 82, 10.0, 10.0))
    ];
  }

  List<Member> getUnsafeResponses() {
    log("Querying for unsafe responses");

    return [
      Member("4", "Brutus", "", "1", "1234567890", GroupResponse(false, 54, 10.0, 10.0))
    ];
  }

  List<Member> getNoResponses() {
    log("Querying for unsafe responses");

    return [Member("5", "Charlemagne", "III", "1", "1234567890", null)];
  }
}