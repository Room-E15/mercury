import 'package:flutter/material.dart';
import '../settings/settings_view.dart';
import '../send_alert/send_alert_view.dart';
import '../entities/group.dart';
import '../join_server_prompt/join_server_prompt_view.dart';
import '../profile/profile_view.dart';

class GroupView extends StatelessWidget {
  const GroupView({
    super.key,
    required this.group,
    required this.logo,
  });

  final Group group;
  final Widget logo;

  String get routeName => "/${group.name}";

  Widget _memberWidgetBuilder(context, index) {
    final member = group.members[index];

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
      ],
    );
  }

  Widget _leaderWidgetBuilder(context, index) {
    final member = group.members[index];

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
          // Leader view card!
          // Member view card!
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
                        color: const Color(0xFF4F378B),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                          const Padding(
                              padding: EdgeInsetsDirectional.only(end: 8)),
                          Text(
                            "${group.leaders.length} ${group.leaders.length == 1 ? "leader" : "leaders"}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
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
                    restorationId: 'leaderList',
                    itemCount: group.leaders.length, // Number of blank cards
                    // build all the group tiles dynamically using builder method
                    itemBuilder: _leaderWidgetBuilder,
                  ),
                ),
              ],
            ),
          ),
          // Member view card!
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
                        color: const Color(0xFF4F378B),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                          const Padding(
                              padding: EdgeInsetsDirectional.only(end: 8)),
                          Text(
                            "${group.members.length} ${group.members.length == 1 ? "member" : "members"}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
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
                    restorationId: 'memberList',
                    itemCount: group.members.length, // Number of blank cards
                    // build all the group tiles dynamically using builder method
                    itemBuilder: _memberWidgetBuilder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
