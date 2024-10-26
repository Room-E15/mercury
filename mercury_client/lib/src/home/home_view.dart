import 'package:flutter/material.dart';
import '../send_alert/send_alert_view.dart';
import '../settings/settings_view.dart';
import '../entities/group.dart';
import '../join_server_prompt/join_server_prompt_view.dart';
import '../profile/profile_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.groups = const [
      // Group(1, "Cal Poly Software", 36, 12, 0, false),
      Group(2, "Cal Poly Architecture", 36, 24, 0, false),
      Group(3, "U Chicago", 36, 36, 0, false),
      Group(4, "That Group", 36, 12, 1, false),
      Group(5, "Just A Member", 17, 0, 0, true),
    ], // TODO remove, get from server
    required this.logo,
  });

  static const routeName = '/';

  final List<Group> groups;
  final Widget logo;

  Widget _groupWidgetBuilder(context, index) {
    final group = groups[index];
    final progress = group.responseCount / group.memberCount;
    final anyUnsafe = group.unsafe > 0;

    double progressValue;
    Color progressColor;
    IconData statusIcon;
    String statusText;
    Color statusColor;
    double topPadding;

    if (anyUnsafe) {
      progressValue = 1;
      progressColor = Colors.red;
      statusIcon = Icons.error;
      statusText =
          "${group.unsafe} member${group.unsafe > 1 ? "s are" : " is"} not safe!";
    } else {
      progressValue = progress;
      progressColor = Colors.green;
      statusIcon = Icons.check;
      statusText = (group.responseCount == group.memberCount)
          ? "All members are safe"
          : "${group.responseCount} of ${group.memberCount} members are safe";
    }

    if (group.isMember) {
      progressValue = 1;
      progressColor = const Color(0xFF4F378B);
      statusIcon = Icons.group;
      statusText =
          "${group.memberCount} ${group.memberCount == 1 ? "member" : "members"}";

      statusColor = Colors.white;
      topPadding = 10;
    } else {
      statusColor = const Color.fromARGB(164, 0, 0, 0);
      topPadding = 20;
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      margin: const EdgeInsetsDirectional.symmetric(
          vertical: 10.0, horizontal: 20.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: const Color.fromARGB(255, 126, 126, 126),
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor)),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                  child: Row(
                    children: [
                      Icon(
                        statusIcon,
                        color: statusColor,
                      ),
                      const Padding(
                          padding: EdgeInsetsDirectional.only(end: 8)),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, topPadding, 16, 10),
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
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            if (!group.isMember)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendAlertView(logo: logo),
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
        leading: Builder(builder: (BuildContext context2) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context2).openDrawer();
              },
              icon: const Icon(Icons.menu));
        }),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Groups',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              restorationId: 'groupList',
              itemCount: groups.length, // Number of blank cards
              // build all the group tiles dynamically using builder method
              itemBuilder: _groupWidgetBuilder,
            ),
          ),
        ],
      ),
    );
  }
}
