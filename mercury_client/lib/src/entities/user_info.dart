import 'package:uuid/uuid.dart';

class UserInfo {
  final Uuid id;

  UserInfo({
    required this.id,
  });
}

class RegisteredUserInfo extends UserInfo {
  final String firstName;
  final String lastName;
  final String countryCode;
  final String phoneNumber;

  RegisteredUserInfo({
    required super.id,
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phoneNumber,
  });
}

