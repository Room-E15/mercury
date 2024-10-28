import 'member.dart';

class Group {
  const Group(this.id, this.name, this.memberCount, this.responseCount,
      this.unsafe, this.isMember, this.members, this.leaders);

  final int id;
  final String name;
  final int memberCount;
  final int responseCount;
  final int unsafe;
  final bool isMember;
  final List<Member> members;
  final List<Member> leaders;
}

class Response {
  const Response(this.safe, this.battery, this.latitude, this.longitude);

  final bool safe;
  final int battery;
  final double latitude;
  final double longitude;
}

class GroupTestData {
  static const List<Group> groups = [
    Group(1, "Cal Poly Software", 36, 12, 0, false, MemberTestData.members,
        MemberTestData.leaders),
    Group(2, "Cal Poly Architecture", 36, 24, 0, false, MemberTestData.members,
        MemberTestData.leaders),
    Group(3, "U Chicago", 36, 36, 0, false, MemberTestData.members,
        MemberTestData.leaders),
    Group(4, "That Group", 36, 12, 1, true, MemberTestData.members,
        MemberTestData.leaders)
  ];
}
