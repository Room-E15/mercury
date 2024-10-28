import 'dart:developer';

import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import '../send_alert/send_alert_view.dart';
import '../entities/group.dart';
import '../entities/member.dart';
import '../join_server_prompt/join_server_prompt_view.dart';
import '../profile/profile_view.dart';

class LeaderGroupView extends StatelessWidget {
  const LeaderGroupView({
    super.key,
    required this.group,
    required this.logo,
  });

  final Group group;
  final Widget logo;

  Widget _memberWidgetBuilder(context, index, memberList) {
    final member = memberList[index];

    return Row(
      children: [
        Text(
          member.name,
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
                child: logo),
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
        title: logo,
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
                      ],
                    ),
                  ),
                  if (!group.isMember)
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
                                        SendAlertView(logo: logo),
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
      Member(3, "Julius Caesar", 1, 1234567890, Response(true, 97, 10.0, 10.0)),
      Member(6, "Ramos Remus", 1, 1234567890, Response(true, 23, 10.0, 10.0)),
      Member(
          1, "Albert Einstein", 1, 1234567890, Response(true, 73, 10.0, 10.0)),
      Member(
          2, "Giorno Giovanna", 1, 1098765432, Response(true, 82, 10.0, 10.0))
    ];
  }

  List<Member> getUnsafeResponses() {
    log("Querying for unsafe responses");

    return [
      Member(4, "Brutus", 1, 1234567890, Response(false, 54, 10.0, 10.0))
    ];
  }

  List<Member> getNoResponses() {
    log("Querying for unsafe responses");

    return [Member(5, "Charlemagne", 1, 1234567890, null)];
  }
}
