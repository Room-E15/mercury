import 'package:flutter/material.dart';
import 'package:mercury_client/pages/qr/qr_present_view.dart';
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

  Widget inviteButton(BuildContext context, String role) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: FilledButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  // QR Code screen
                  QRPresentView(
                      key: key, groupId: group.id, groupName: group.name),
            ),
          );
        },
        style: FilledButton.styleFrom(
            minimumSize: Size(10, 24),
            maximumSize: Size(200, 24),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
              child: Text(
                'Invite ${role}s',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            Icon(
              Icons.add,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

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
      body: Column(
        children: [
          groupTitleCard(context, group, key, preferences),
          group.latestAlert != null
              ? groupWithAlertWidgetBuilder(context, group, key, preferences)
              : groupWithoutAlertWidgetBuilder(
                  context, group, key, inviteButton),
          // Padding(
          //   padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 26),
          //   child: OutlinedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) =>
          //               // QR Code screen
          //               QRPresentView(
          //                   key: key, groupId: group.id, groupName: group.name),
          //         ),
          //       );
          //     },
          //     style: OutlinedButton.styleFrom(
          //         side: BorderSide(
          //           color: const Color(0xFF4F378B),
          //           width: 2,
          //         ),
          //         padding: EdgeInsets.symmetric(horizontal: 12)),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.fromLTRB(4, 0, 8, 0),
          //           child: Text(
          //             'Invite',
          //             style: TextStyle(
          //               fontSize: 16.0,
          //               color: const Color(0xFF4F378B),
          //             ),
          //           ),
          //         ),
          //         Icon(
          //           Icons.group_add,
          //           color: const Color(0xFF4F378B),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
