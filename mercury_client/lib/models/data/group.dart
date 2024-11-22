import 'member.dart';

class Group {
  final String id;
  final String name;
  final List<Member> members;
  final List<Member> leaders;
  final bool isLeader;

  late int memberCount;
  late int responseCount;
  late bool safe;
  Group({
    required this.id,
    required this.name,
    required this.isLeader,
    required this.members,
    required this.leaders,
  }) {
    memberCount = members.length + leaders.length;
    responseCount = 0;
    safe = true;
    for (final member in members) {
      if (member.response != null) {
        responseCount++;
      }
      if (!member.safe) {
        safe = false;
      }
    }

    for (final member in leaders) {
      if (member.response != null) {
        responseCount++;
      }
      if (!member.safe) {
        safe = false;
      }
    }
  }

  // Factory constructor to create a Group instance from JSON
  factory Group.fromJson(dynamic json) {
    return Group(
      id: json['id'],
      name: json['name'],
      isLeader: json['isLeader'],
      members: (json['members'] as List<dynamic>)
          .map((json) => Member.fromJson(json))
          .toList(),
      leaders: (json['leaders'] as List<dynamic>)
          .map((json) => Member.fromJson(json))
          .toList(),
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
