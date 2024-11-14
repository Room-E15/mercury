import 'dart:collection';
import 'dart:developer';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:mercury_client/src/join_server_prompt/join_server_prompt_view.dart';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:mercury_client/src/utils/server_calls.dart';
import 'package:mercury_client/src/create_group/create_group_view.dart';
import 'package:mercury_client/src/join_group/join_group_view.dart';
import 'package:mercury_client/src/send_alert/send_alert_view.dart';
import 'package:mercury_client/src/settings/settings_view.dart';
import 'package:mercury_client/src/entities/alert.dart';
import 'package:mercury_client/src/entities/group.dart';
import 'package:mercury_client/src/group_dashboard/leader_group_view.dart';
import 'package:mercury_client/src/group_dashboard/member_group_view.dart';
import 'package:mercury_client/src/profile/profile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.isManager,
    required this.preferences,
    required this.dummyValues,
  });

  static const routeName = '/home';

  final bool isManager;
  final SharedPreferencesWithCache preferences;
  final bool dummyValues;

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  // Will call fetchServerAlert
  Queue<Alert> _alerts = Queue.from(AlertTestData.alerts);
  String filterSearch = "";

  List<Group> groups = List.empty();
  Future<List<Group>>? futureGroups;

  // TODO: Use easy-refresh package to refresh async fetch
  @override
  void initState() {
    super.initState();

    String memberId = widget.preferences.getString('id')!;

    // If dummyValues is enabled, create dummy classes
    if (widget.dummyValues) {
      for (final group in GroupTestData.groups) {
        requestServerCreateGroup(memberId, group.name);
      }
    }

    // Call the async function as the page is initialized
    futureGroups = fetchServerGroups(memberId);
  }

  // TODO make async
  void fetchServerAlert() {
    log("Fetching alerts");

    setState(() {
      _alerts = Queue.from(AlertTestData.alerts); // Toggle between items
    });
  }

  // TODO make async
  void respondToAlert() {
    log("Alert response sent");
    setState(() {
      _alerts.removeFirst(); // Toggle between items
    });
  }

  Widget _groupWidgetBuilder(context, index, groups) {
    final group = groups[index];
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

    if (!group.isLeader || group.responseCount == null) {
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
                    LeaderGroupView(key: widget.key, group: group),
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
                              builder: (context) => SendAlertView(),
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

  Widget _waitForGroupPopulation(BuildContext context, String filterSearch) {
    return FutureBuilder<List<Group>>(
      future: futureGroups,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the future to complete
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show an error message if the future completes with an error
          return Center(child: Text("Error: ${snapshot.error}"));
        } else {
          log("Snapshot: ${snapshot.data!}");
          // When future completes successfully, show the list of groups
          final groups = snapshot.data!;
          String memberId = widget.preferences.getString('id')!;

          return EasyRefresh(
              onRefresh: () async {
                futureGroups = fetchServerGroups(memberId);
                setState(() {
                   // Toggle between items
                });
              },
              header: ClassicHeader(
                dragText: "Pull down to refresh",
                armedText: "Release to refresh",
                readyText: "Refreshing...",
                processingText: "Loading groups...",
                failedText: "Refresh failed",
                noMoreText: "No more data",
              ),
              child: ListView.builder(
                restorationId: 'groupList',
                itemCount:
                    groups.length + 1, // Extra item for the "Add Group" button
                itemBuilder: (context, index) {
                  if (index < groups.length) {
                    if (filterSearch == "" ||
                        groups[index]
                            .name
                            .toLowerCase()
                            .contains(filterSearch.toLowerCase())) {
                      return _groupWidgetBuilder(context, index, groups);
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    return IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0))),
                          builder: (BuildContext context) {
                            return Container(
                              width: 360,
                              height: 90,
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 5),
                              child: Column(children: [
                                SizedBox(
                                  width: 40.0,
                                  height: 4.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white54,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                Row(
                                  children: [
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateGroupView(
                                                    key: widget.key,
                                                    preferences:
                                                        widget.preferences),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Text("CREATE GROUP"),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JoinGroupView(
                                                key: widget.key,
                                                preferences:
                                                    widget.preferences),
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text("JOIN GROUP"),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 40,
                        color: Color(0xFF4F378B),
                      ),
                    );
                  }
                },
              ));
        }
      },
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
                          icon: Icon(Icons.close, color: Colors.black),
                          iconSize: 24,
                          onPressed: () {
                            setState(() {
                              respondToAlert(); // Toggle between items
                            });
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
                          icon: Icon(Icons.check, color: Colors.black),
                          iconSize: 24,
                          onPressed: () {
                            setState(() {
                              respondToAlert(); // Toggle between items
                            });
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
            child: _waitForGroupPopulation(context, filterSearch),
          ),
        ],
      ),
    );
  }
}
