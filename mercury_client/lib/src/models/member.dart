class Member {
  final String firstName;
  final String lastName;
  final int areaCode;
  final int phoneNumber;
  
  Member({
    required this.firstName, required this.lastName, required this.areaCode, required this.phoneNumber
  });

factory Member.fromMap(Map memberMap) {
  return Member(
    firstName: memberMap['firstName'],
    lastName: memberMap['lastName'],
    areaCode: memberMap['areaCode'],
    phoneNumber: memberMap['phoneNumber'],);
}
}