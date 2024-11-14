import 'member.dart';

class Group {
  final String id;
  final String name;
  final int memberCount;
  final int? responseCount;
  final int unsafe;
  final bool isLeader;
  final List<Member> members;
  final List<Member> leaders;

  const Group(
      {required this.name,
      required this.id,
      required this.isLeader,
      required this.memberCount,
      this.responseCount,
      required this.unsafe,
      required this.members,
      required this.leaders});

  // Factory constructor to create a Group instance from JSON
  factory Group.fromJson(dynamic json) {
    return Group(
      id: json['id'],
      name: json['name'],
      isLeader: json['isLeader'],
      memberCount: json['memberCount'],
      responseCount: json['responseCount'],
      unsafe: json['unsafe'],
      members: (json['members'] as List<dynamic>)
          .map((json) => Member.fromJson(json))
          .toList(),
      leaders: (json['leaders'] as List<dynamic>)
          .map((json) => Member.fromJson(json))
          .toList(),
    );
  }

  factory Group.fromMap(Map groupMap) {
    return Group(
      id: groupMap['id'],
      name: groupMap['name'],
      isLeader: groupMap['isLeader'],
      memberCount: groupMap['memberCount'],
      responseCount: groupMap['responseCount'],
      unsafe: groupMap['unsafe'],
      members: groupMap['members'],
      leaders: groupMap['leaders'],
    );
  }
}

class GroupResponse {
  const GroupResponse(this.safe, this.battery, this.latitude, this.longitude);

  final bool safe;
  final int battery;
  final double latitude;
  final double longitude;
}

class GroupTestData {
  static const List<Group> groups = [
    Group(
        id: "b74ccc08-9608-4db0-bbb2-17faa1fa0d0c",
        name: "Cal Poly Software",
        memberCount: 36,
        responseCount: 12,
        unsafe: 0,
        isLeader: true,
        members: MemberTestData.members,
        leaders: MemberTestData.leaders),
    Group(
        id: "39d4e389-805d-4384-9191-304a5031ad66",
        name: "Cal Poly Architecture",
        memberCount: 36,
        responseCount: 24,
        unsafe: 0,
        isLeader: false,
        members: MemberTestData.members,
        leaders: MemberTestData.leaders),
    Group(
        id: "73ed0ccc-11a7-451a-9f37-0f306c162050",
        name: "U Chicago",
        memberCount: 36,
        responseCount: 36,
        unsafe: 0,
        isLeader: true,
        members: MemberTestData.members,
        leaders: MemberTestData.leaders),
    Group(
        id: "ecaa9eef-05bd-44ab-a7a7-73dc8cac6a9c",
        name: "That Group",
        memberCount: 36,
        responseCount: 12,
        unsafe: 1,
        isLeader: true,
        members: MemberTestData.members,
        leaders: MemberTestData.leaders)
  ];
}
