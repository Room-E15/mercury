import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/pages/create_group/create_group_view.dart';
import 'package:mercury_client/pages/group_dashboard/leader_group_view.dart';
import 'package:mercury_client/pages/group_dashboard/member_group_view.dart';
import 'package:mercury_client/pages/join_group/join_group_view.dart';
import 'package:mercury_client/pages/send_alert/send_alert_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget groupWidgetBuilder(Key? widgetKey, BuildContext context,
    SharedPreferencesWithCache preferences, int index, List<Group> groups) {
  final group = groups[index];
  final progress = group.responseCount / group.memberCount;
  final unsafe = group.unsafeMembers.isNotEmpty;

  double progressValue;
  Color progressColor;
  IconData statusIcon;
  String statusText;
  Color statusColor;

  if (unsafe) {
    progressValue = 1;
    progressColor = Colors.red;
    statusIcon = Icons.error;
    statusText =
        "${group.unsafeMembers.length} member${group.unsafeMembers.length > 1 ? "s are" : " is"} not safe!";
  } else {
    progressValue = progress;
    progressColor = Colors.green;
    statusIcon = Icons.check;
    statusText = (group.responseCount == group.memberCount)
        ? 'All members are safe'
        : '${group.responseCount} of ${group.memberCount} members are safe';
  }

  if (!group.isLeader || group.latestAlert == null) {
    progressValue = 1;
    progressColor = const Color(0xFF4F378B);
    statusIcon = Icons.group;
    statusText =
        "${group.memberCount} ${group.memberCount == 1 ? "member" : "members"}";

    statusColor = Colors.white;
  } else {
    statusColor = const Color.fromARGB(164, 0, 0, 0);
  }

  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))),
    margin:
        const EdgeInsetsDirectional.symmetric(vertical: 10.0, horizontal: 20.0),
    child: InkWell(
      onTap: () {
        if (!group.isLeader) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MemberGroupView(key: widgetKey, group: group),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeaderGroupView(
                key: widgetKey,
                group: group,
                preferences: preferences,
              ),
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
                    const Padding(padding: EdgeInsetsDirectional.only(end: 8)),
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
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
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
                            builder: (context) => SendAlertView(
                              preferences: preferences,
                              group: group,
                            ),
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

showModal(BuildContext context, Key? widgetKey,
    SharedPreferencesWithCache preferences) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
    builder: (BuildContext context) {
      return Container(
        height: 96,
        padding: EdgeInsets.all(16),
        child: Column(children: [
          SizedBox(
            width: 40.0,
            height: 4.0,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest, //Colors.white54,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateGroupView(
                          key: widgetKey, preferences: preferences),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Text('CREATE GROUP'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(1, 2, 0, 2),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinGroupView(
                          key: widgetKey, preferences: preferences),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(11, 2, 11, 2),
                  child: Text('JOIN GROUP'),
                ),
              )
            ],
          )
        ]),
      );
    },
  );
}

Future<Widget> getGroupWidgets(
  Key? widgetKey,
  BuildContext context,
  SharedPreferencesWithCache preferences,
  String filterSearch,
  List<Group> groups,
  Future<void> Function() onRefresh,
) async {
  return EasyRefresh(
      onRefresh: onRefresh,
      header: ClassicHeader(
        dragText: 'Pull down to refresh',
        armedText: 'Release to refresh',
        readyText: 'Refreshing...',
        processingText: 'Loading groups...',
        failedText: 'Refresh failed',
        noMoreText: 'No more data',
      ),
      child: ListView.builder(
        restorationId: 'groupList',
        itemCount: groups.length + 1, // Extra item for the "Add Group" button
        itemBuilder: (context, index) {
          if (index < groups.length) {
            // normal group tile
            if (filterSearch == '' ||
                groups[index]
                    .name
                    .toLowerCase()
                    .contains(filterSearch.toLowerCase())) {
              return groupWidgetBuilder(
                  widgetKey, context, preferences, index, groups);
            } else {
              return SizedBox.shrink();
            }
          } else {
            // plus icon tile TODO refactor to take out separete widgets
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 26),
                  child: OutlinedButton(
                    onPressed: () => showModal(context, widgetKey, preferences),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: const Color(0xFF4F378B),
                          width: 2,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: Text(
                            'Add Group',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: const Color(0xFF4F378B),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.add,
                          color: const Color(0xFF4F378B),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ));
}
