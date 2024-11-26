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
