import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/respond_alert_requests.dart';
import 'package:mercury_client/pages/register/start_view.dart';
import 'package:mercury_client/widgets/alert_widget.dart';

import 'package:mercury_client/widgets/render_groups.dart';
import 'package:mercury_client/widgets/loading_widget.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/models/requests/send_alert_requests.dart';
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
  final _alerts = Queue<Alert>();

  late String memberId;
  late Future<List<Group>> _futureGroups;

  String filterSearch = '';

  Future<List<Group>>? futureGroups;

  @override
  void initState() {
    super.initState();

    // Call the async function as the page is initialized
    memberId = widget.preferences.getString('id')!;
    _futureGroups = GroupRequests.fetchGroups(memberId);

    SendAlertRequests.backgroundFetchAlerts(
        preferences: widget.preferences,
        memberId: memberId,
        ignored: _alerts,
        onNewAlert: (alerts) async {
          setState(() => _alerts.addAll(alerts));
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
                }),
            TextButton(
                child: const Row(children: [
                  Icon(Icons.logout),
                  Padding(padding: EdgeInsetsDirectional.only(end: 10)),
                  Text('Logout')
                ]),
                onPressed: () {
                  // Clear user info, keep the user's theme
                  final theme = widget.preferences.getInt('themeMode');
                  widget.preferences.clear();
                  widget.preferences.setInt('themeMode', theme!);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    // TODO update when we implement servers
                    StartView.routeName, (route) => false,
                  );
                }),
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
          alertWidgetBuilder(
            alerts: _alerts,
            onSafe: () async {
              RespondAlertRequests.saveAlertResponse(
                memberId: memberId,
                alertId: _alerts.first.id,
                isSafe: true,
              ).then((alertId) {
                if (alertId != null) {
                  setState(() {
                    if (_alerts.first.id == alertId) {
                      _alerts.removeFirst();
                    }
                  });
                }
              });
            },
            onUnsafe: () async {
              RespondAlertRequests.saveAlertResponse(
                memberId: memberId,
                alertId: _alerts.first.id,
                isSafe: false,
              ).then((alertId) {
                if (alertId != null && _alerts.first.id == alertId) {
                  setState(() {
                    _alerts.removeFirst();
                  });
                  SendAlertRequests.fetchAlerts(memberId, _alerts)
                      .then((alerts) {
                    setState(() => _alerts.addAll(alerts));
                  });
                }
              });
            },
          ),
          // Search Filter Bar
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

          // Group Tiles and loading spinner
          Expanded(
            child: loadingWidgetBuilder(
                context: context,
                futureIcon: _futureGroups.then((groups) {
                  if (context.mounted) {
                    return getGroupWidgets(
                      widget.key,
                      context,
                      widget.preferences,
                      filterSearch,
                      groups,
                      () async => setState(() {
                        _futureGroups = GroupRequests.fetchGroups(memberId);
                      }),
                    );
                  } else {
                    return Container();
                  }
                })),
          ),
        ],
      ),
    );
  }
}
