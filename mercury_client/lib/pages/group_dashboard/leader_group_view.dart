import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/widgets/group_widgets.dart';
import 'package:mercury_client/pages/settings/settings_view.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/models/data/member.dart';
import 'package:mercury_client/pages/join_server_prompt/join_server_prompt_view.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';

class LeaderGroupView extends StatelessWidget {
  const LeaderGroupView({
    super.key,
    required this.group,
    required this.preferences,
  });

  final Group group;

  final SharedPreferencesWithCache preferences;

  @override
  Widget build(BuildContext context) {
    // TODO update
    final List<Member> unsafe = group.members;
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
      body: group.responseCount != null || group.responseCount == 0
          ? groupWithAlertWidgetBuilder(
              context, group, key, preferences, unsafe, noResponse, safe)
          : groupWithoutAlertWidgetBuilder(context, group),
    );
  }

  // List<Member> getSafeResponses() {
  //   log("Querying for safe responses");

  //   return [
  //     Member("3", "Julius", "Caesar", 1, "1234567890",
  //         GroupResponse(true, 97, 10.0, 10.0)),
  //     Member("6", "Ramos", "Remus", 1, "1234567890",
  //         GroupResponse(true, 23, 10.0, 10.0)),
  //     Member("1", "Albert", "Einstein", 1, "1234567890",
  //         GroupResponse(true, 73, 10.0, 10.0)),
  //     Member("2", "Giorno", "Giovanna", 1, "1098765432",
  //         GroupResponse(true, 82, 10.0, 10.0))
  //   ];
  // }

  // List<Member> getUnsafeResponses() {
  //   log("Querying for unsafe responses");

  //   return [
  //     Member("4", "Brutus", "", 1, "1234567890",
  //         GroupResponse(false, 54, 10.0, 10.0))
  //   ];
  // }

  // List<Member> getNoResponses() {
  //   log("Querying for unsafe responses");

  //   return [Member("5", "Charlemagne", "III", 1, "1234567890", null)];
  // }
}
