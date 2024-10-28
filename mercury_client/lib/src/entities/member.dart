class Member {
  const Member(
      this.id, this.name, this.countryCode, this.phoneNumber, this.response);

  final int id;
  final String name;
  final int countryCode;
  final int phoneNumber;
  final bool? response;
}

class MemberTestData {
  static const List<Member> members = [
    Member(3, "Julius Caesar", 1, 1234567890, true),
    Member(4, "Brutus", 1, 1234567890, false),
    Member(5, "Charlemagne", 1, 1234567890, true),
    Member(6, "Ramos Remus", 1, 1234567890, true)
  ];
  static const List<Member> leaders = [
    Member(1, "Albert Einstein", 1, 1234567890, true),
    Member(2, "Giorno Giovanna", 1, 1098765432, false),
  ];
}
