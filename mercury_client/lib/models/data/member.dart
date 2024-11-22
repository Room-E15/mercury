import 'group.dart';

class Member {
  final String id;
  final String firstName;
  final String lastName;
  final int countryCode;
  final String phoneNumber;
  final GroupResponse? response;

  const Member(this.id, this.firstName, this.lastName, this.countryCode,
      this.phoneNumber, {this.response});

  // TODO bandaid solution, make sure this works
  const Member.softInit(
      {required this.firstName,
      required this.lastName,
      required this.countryCode,
      required this.phoneNumber})
      : id = "",
        response = null;

  // Factory constructor to create a Group instance from JSON
  factory Member.fromJson(dynamic json) {
    return Member(
      json['id'],
      json['firstName'],
      json['lastName'],
      json['countryCode'],
      json['phoneNumber'],
      json['response'],
    );
  }

  // TODO ported from merge, make sure this works
  factory Member.fromMap(Map memberMap) {
    return Member.softInit(
      firstName: memberMap['firstName'],
      lastName: memberMap['lastName'],
      countryCode: memberMap['countryCode'],
      phoneNumber: memberMap['phoneNumber'],
    );
  }
}

// class MemberTestData {
//   static const List<Member> members = [
//     Member("3", "Julius", "Caesar", 1, "1234567890",
//         GroupResponse(true, 97, 10.0, 10.0)),
//     Member("4", "Brutus", "", 1, "1234567890",
//         GroupResponse(false, 54, 10.0, 10.0)),
//     Member("5", "Charlemagne", "III", 1, "1234567890", null),
//     Member("6", "Ramos", "Remus", 1, "1234567890",
//         GroupResponse(true, 23, 10.0, 10.0))
//   ];
//   static const List<Member> leaders = [
//     Member("1", "Albert", "Einstein", 1, "1234567890",
//         GroupResponse(true, 73, 10.0, 10.0)),
//     Member("2", "Giorno", "Giovanna", 1, "1098765432",
//         GroupResponse(true, 82, 10.0, 10.0)),
//   ];
// }
