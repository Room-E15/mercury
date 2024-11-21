import 'dart:collection';
import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:mercury_client/widgets/home_widgets.dart';
import 'package:mercury_client/widgets/loading.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/models/requests/alert_requests.dart';
import 'package:mercury_client/models/requests/group_requests.dart';
import 'package:mercury_client/pages/join_server_prompt/join_server_prompt_view.dart';
import 'package:mercury_client/pages/settings/settings_view.dart';
import 'package:mercury_client/models/data/alert.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.preferences});

  static const routeName = '/home';
  final SharedPreferencesWithCache preferences;

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  // Will call fetchServerAlert
  Queue<Alert> _alerts = Queue();
  late String memberId;
  late Future<List<Group>> _futureGroups;

  String filterSearch = "";

  Future<List<Group>>? futureGroups;

  @override
  void initState() {
    super.initState();

    // Call the async function as the page is initialized
    memberId = widget.preferences.getString('id')!;
    _futureGroups = GroupRequests.fetchGroups(memberId);
    // TODO also add getting an alert while the app is open, how do we do this?
    AlertRequests.fetchAlerts(memberId).then((value) {
      setState(() {
        _alerts = Queue.from(value); // Toggle between items
      });
    });
  }

  // TODO factor out widgets into separate files so it's not so damn long
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
                            AlertRequests.saveAlertResponse(isSafe: false)
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
                            AlertRequests.saveAlertResponse(isSafe: true)
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
            child: EasyRefresh(
              onRefresh: () async => setState(() {
                _futureGroups = GroupRequests.fetchGroups(memberId);
              }),
              header: ClassicHeader(
                dragText: "Pull down to refresh",
                armedText: "Release to refresh",
                readyText: "Refreshing...",
                processingText: "Loading groups...",
                failedText: "Refresh failed",
                noMoreText: "No more data",
              ),
              child: loadingWidgetBuilder(
                  context: context,
                  errorIcon: ListView(children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Center(child: Text('Error loading groups')))
                  ]),
                  futureIcon: _futureGroups.then((groups) {
                    if (context.mounted) {
                      return getGroupWidgets(
                        widget.key,
                        context,
                        widget.preferences,
                        filterSearch,
                        groups,
                      );
                    } else {
                      return Container();
                    }
                  })),
            ),
          ),
        ],
      ),
    );
  }
}
