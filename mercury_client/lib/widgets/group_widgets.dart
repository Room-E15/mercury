import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/pages/qr/qr_present_view.dart';
import 'package:mercury_client/pages/send_alert/send_alert_view.dart';
import 'package:mercury_client/widgets/member_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

final clipBehavior = Clip.antiAliasWithSaveLayer;
final shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)));
final margin =
    const EdgeInsetsDirectional.symmetric(vertical: 10.0, horizontal: 20.0);

Widget groupTitleCard(BuildContext context, Group group, Key? key,
    SharedPreferencesWithCache preferences) {
  return Card(
    clipBehavior: clipBehavior,
    shape: shape,
    margin: margin,
    child: InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ),
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
                            builder: (context) => SendAlertView(
                                preferences: preferences, group: group),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('SEND ALERT'),
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

// TODO refactor, this has code that can be factored out as a funciton
Widget groupWithAlertWidgetBuilder(
  BuildContext context,
  Group group,
  Key? key,
  SharedPreferencesWithCache preferences,
) {
  return Column(
    children: [
      group.latestAlert == null
          ? Container()
          : Card(
              margin: margin,
              clipBehavior: clipBehavior,
              shape: shape,
              child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16), // Space between icon and text

                      // Alert text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.latestAlert?.title ?? 'Title Missing',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              group.latestAlert?.description ?? '',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
      group.unsafeMembers.isEmpty
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
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                            ),
                            const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8)),
                            Text(
                              "${group.unsafeMembers.length} ${group.unsafeMembers.length == 1 ? "Member" : "Members"} NOT OK",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
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
                      restorationId: 'unsafeList',
                      itemCount:
                          group.unsafeMembers.length, // Number of blank cards
                      // build all the group tiles dynamically using builder method
                      itemBuilder: (context, index) {
                        final member = group.unsafeMembers[index];

                        return memberWithInfoWidgetBuilder(context, member);
                      },
                    ),
                  ),
                ],
              ),
            ),
      group.noResponseMembers.isEmpty
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
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.black,
                            ),
                            const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8)),
                            Text(
                              "Waiting for ${group.noResponseMembers.length} ${group.noResponseMembers.length == 1 ? "Response" : "Responses"}",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
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
                      restorationId: 'noResponseList',
                      itemCount: group
                          .noResponseMembers.length, // Number of blank cards
                      // build all the group tiles dynamically using builder method
                      itemBuilder: (context, index) {
                        final member = group.noResponseMembers[index];

                        return memberWithInfoWidgetBuilder(context, member);
                      },
                    ),
                  ),
                ],
              ),
            ),
      group.safeMembers.isEmpty
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
                          color: Colors.green,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_outlined,
                              color: Colors.black,
                            ),
                            const Padding(
                                padding: EdgeInsetsDirectional.only(end: 8)),
                            Text(
                              "${group.safeMembers.length} ${group.safeMembers.length == 1 ? "Member" : "Members"} OK",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
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
                      restorationId: 'safeList',
                      itemCount:
                          group.safeMembers.length, // Number of blank cards
                      // build all the group tiles dynamically using builder method
                      itemBuilder: (context, index) {
                        final member = group.safeMembers[index];

                        return memberWithInfoWidgetBuilder(context, member);
                      },
                    ),
                  ),
                ],
              ),
            ),
    ],
  );
}

Widget groupWithoutAlertWidgetBuilder(
    BuildContext context, Group group, Key? key, Widget Function(BuildContext, String) barWidget) {
  return Column(
    children: [
      // Leader view card!
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
                      Spacer(),
                      barWidget(context, 'Leader'),
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
                itemBuilder: (context, index) {
                  final leader = group.leaders[index];

                  return leaderWidgetBuilder(context, leader);
                },
              ),
            ),
          ],
        ),
      ),
      // Member view card!
      group.members.isNotEmpty
          ? Card(
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
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
                            Spacer(),
                            barWidget(context, 'Member'),
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
                      itemBuilder: (context, index) {
                        final member = group.members[index];
                        return memberWidgetBuilder(
                            context, member, group.isLeader);
                      },
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    ],
  );
}
