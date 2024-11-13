import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/requests/alert_requests.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import 'dart:collection';
import '../create_group/create_group_view.dart';
import '../send_alert/send_alert_view.dart';
import '../settings/settings_view.dart';
import '../entities/data/alert.dart';
import '../entities/data/group.dart';
import '../group_dashboard/leader_group_view.dart';
import '../group_dashboard/member_group_view.dart';
import '../join_server_prompt/join_server_prompt_view.dart';
import '../profile/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.isManager,
    required this.preferences,
  });

  static const routeName = '/home';

  final List<Group> groups = GroupTestData.groups; // TODO get from server call
  final bool isManager;
  final SharedPreferencesWithCache preferences;

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  // Will call fetchServerAlert
  Queue<Alert> _alerts = Queue();
  String filterSearch = "";

  @override
  void initState() {
    super.initState();
    AlertRequests.fetchAlerts().then((value) => setState(() {
          _alerts = Queue.from(AlertTestData.alerts); // Toggle between items
        }));
  }

  Widget _groupWidgetBuilder(context, index) {
    final group = widget.groups[index];
    final progress = group.responseCount != null
        ? group.responseCount! / group.memberCount
        : 1.0;
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

    if (!group.isLeader) {
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
        onTap: () {
          if (!group.isLeader) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MemberGroupView(key: widget.key, group: group),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LeaderGroupView(key: widget.key, group: group, preferences: widget.preferences),
              ),
            );
          }
        },
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
            if (group.isLeader)
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
                              builder: (context) => SendAlertView(preferences: widget.preferences, group: group),
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
          _alerts.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Alert icon
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF4F378B), // Purple background color
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16), // Space between icon and text

                      // Alert text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _alerts.first.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _alerts.first.description,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 16), // Space between text and buttons

                      // Red dismiss button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          // BAD BUTTON
                          icon: Icon(Icons.close, color: Colors.black),
                          iconSize: 24,
                          onPressed: () async {
                            AlertRequests.saveResponse(isSafe: false)
                                .then((value) => setState(() {
                                      _alerts
                                          .removeFirst(); // Toggle between items
                                    }));
                          },
                        ),
                      ),
                      SizedBox(width: 8), // Space between buttons

                      // Green confirm button
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          // GOOD BUTTON
                          icon: Icon(Icons.check, color: Colors.black),
                          iconSize: 24,
                          onPressed: () async {
                            AlertRequests.saveResponse(isSafe: true)
                                .then((value) => setState(() {
                                      _alerts
                                          .removeFirst(); // Toggle between items
                                    }));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filterSearch = value;
                });
                log(filterSearch);
              },
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
                itemCount: widget.groups.length + 1, // Number of blank cards
                // build all the group tiles dynamically using builder method
                itemBuilder: (context, index) {
                  if (index < widget.groups.length) {
                    if (filterSearch == "" ||
                        widget.groups[index].name
                            .toLowerCase()
                            .contains(filterSearch.toLowerCase())) {
                      return _groupWidgetBuilder(context, index);
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    return IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateGroupView(
                                  key: widget.key,
                                  preferences: widget.preferences),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline,
                            size: 40, color: Color(0xFF4F378B)));
                  }
                }),
          ),
        ],
      ),
    );
  }
}
