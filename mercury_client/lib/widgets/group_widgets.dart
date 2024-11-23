import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:mercury_client/pages/qr/qr_present_view.dart';
import 'package:mercury_client/pages/send_alert/send_alert_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget memberWidgetBuilder(context, RegisteredUser member) {
  return Row(
    children: [
      Text(
        '${member.firstName} ${member.lastName}',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      Spacer(),
    ],
  );
}

Widget leaderWidgetBuilder(context, RegisteredUser leader) {
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

Widget groupWithAlertWidgetBuilder(
  BuildContext context,
  Group group,
  Key? key,
  SharedPreferencesWithCache preferences,
) {
  return Column(
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
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // QR Code screen
                                  QRPresentView(
                                      key: key,
                                      groupId: group.id,
                                      groupName: group.name),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline,
                            size: 40, color: Color(0xFF4F378B))),
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
      ),
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
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
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
                itemCount: group.unsafeMembers.length, // Number of blank cards
                // build all the group tiles dynamically using builder method
                itemBuilder: (context, index) {
                  final member = group.unsafeMembers[index];

                  return memberWidgetBuilder(context, member);
                },
              ),
            ),
          ],
        ),
      ),
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
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
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
                itemCount:
                    group.noResponseMembers.length, // Number of blank cards
                // build all the group tiles dynamically using builder method
                itemBuilder: (context, index) {
                  final member = group.noResponseMembers[index];

                  return memberWidgetBuilder(context, member);
                },
              ),
            ),
          ],
        ),
      ),
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
                    color: Colors.green,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
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
                itemCount: group.safeMembers.length, // Number of blank cards
                // build all the group tiles dynamically using builder method
                itemBuilder: (context, index) {
                  final member = group.safeMembers[index];

                  return memberWidgetBuilder(context, member);
                },
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget groupWithoutAlertWidgetBuilder(context, Group group) {
  return Column(
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
                        return memberWidgetBuilder(context, member);
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
