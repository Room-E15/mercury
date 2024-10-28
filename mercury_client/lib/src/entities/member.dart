import 'group.dart';

class Member {
  const Member(
      this.id, this.name, this.countryCode, this.phoneNumber, this.response);

  final int id;
  final String name;
  final int countryCode;
  final int phoneNumber;
  final Response? response;
}

class MemberTestData {
  static const List<Member> members = [
    Member(3, "Julius Caesar", 1, 1234567890, Response(true, 97, 10.0, 10.0)),
    Member(4, "Brutus", 1, 1234567890, Response(false, 54, 10.0, 10.0)),
    Member(5, "Charlemagne", 1, 1234567890, null),
    Member(6, "Ramos Remus", 1, 1234567890, Response(true, 23, 10.0, 10.0))
  ];
  static const List<Member> leaders = [
    Member(1, "Albert Einstein", 1, 1234567890, Response(true, 73, 10.0, 10.0)),
    Member(2, "Giorno Giovanna", 1, 1098765432, Response(true, 82, 10.0, 10.0)),
  ];
}
