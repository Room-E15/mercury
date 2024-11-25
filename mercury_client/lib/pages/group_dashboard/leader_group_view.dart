import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/widgets/group_widgets.dart';
import 'package:mercury_client/pages/settings/settings_view.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/pages/join_server_prompt/join_server_prompt_view.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';

class LeaderGroupView extends StatelessWidget {
  final Group group;
  final SharedPreferencesWithCache preferences;

  const LeaderGroupView({
    super.key,
    required this.group,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
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
                  Text('Settings')
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
                  Text('Leave Server')
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
      body: group.latestAlert != null
          ? groupWithAlertWidgetBuilder(context, group, key, preferences)
          : groupWithoutAlertWidgetBuilder(context, group),
    );
  }
}
