class Member {
  final String firstName;
  final String lastName;
  final int countryCode;
  final int phoneNumber;
  
  Member({
    required this.firstName, required this.lastName, required this.countryCode, required this.phoneNumber
  });

factory Member.fromMap(Map memberMap) {
  return Member(
    firstName: memberMap['firstName'],
    lastName: memberMap['lastName'],
    countryCode: memberMap['countryCode'],
    phoneNumber: memberMap['phoneNumber'],);
}
}