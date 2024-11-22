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
      required this.responseCount,
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

  // factory Group.fromMap(Map groupMap) {
  //   return Group(
  //     id: groupMap['id'],
  //     name: groupMap['name'],
  //     isLeader: groupMap['isLeader'],
  //     memberCount: groupMap['memberCount'],
  //     responseCount: groupMap['responseCount'],
  //     unsafe: groupMap['unsafe'],
  //     members: groupMap['members'],
  //     leaders: groupMap['leaders'],
  //   );
  // }
}

class GroupResponse {
  const GroupResponse(this.safe, this.battery, this.latitude, this.longitude);

  final bool safe;
  final int battery;
  final double latitude;
  final double longitude;
}