import 'package:flutter/material.dart';

import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/widgets/member_widgets.dart';

class MemberGroupView extends StatelessWidget {
  const MemberGroupView({
    super.key,
    required this.group,
  });

  final Group group;

  // TODO should we get this from another file?
  Widget _leaderWidgetBuilder(BuildContext context, int index) {
    final leader = group.leaders[index];

    return Row(
      children: [
        Text(
          '${leader.firstName} ${leader.lastName}',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        Spacer(),
        Text('+${leader.countryCode} ${leader.phoneNumber}',
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
                ],
              ),
            ),
          ),
          // Leader view card!
          group.leaders.isEmpty
              ? Container()
              : Card(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 2, 2, 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.group,
                                  color: Colors.white,
                                ),
                                const Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 8)),
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
                          itemCount:
                              group.leaders.length, // Number of blank cards
                          // build all the group tiles dynamically using builder method
                          itemBuilder: _leaderWidgetBuilder,
                        ),
                      ),
                    ],
                  ),
                ),
          // Member view card!
          group.members.isEmpty
              ? Container()
              : Card(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 2, 2, 2),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.group,
                                  color: Colors.white,
                                ),
                                const Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(end: 8)),
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
                          itemCount:
                              group.members.length, // Number of blank cards
                          // build all the group tiles dynamically using builder method
                          itemBuilder: (context, index) {
                            final member = group.members[index];
                            return memberWidgetBuilder(context, member, group.isLeader);
                          },
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
