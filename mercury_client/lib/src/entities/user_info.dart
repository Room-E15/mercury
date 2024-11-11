class UserInfo {
  final String firstName;
  final String lastName;
  final String countryCode;
  final String phoneNumber;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.countryCode,
    required this.phoneNumber,
  });
}

class RegisteredUserInfo extends UserInfo {
  final String id;

  RegisteredUserInfo({
    required this.id,
    required super.firstName,
    required super.lastName,
    required super.countryCode,
    required super.phoneNumber,
  });

  RegisteredUserInfo.fromUser(UserInfo user, this.id)
      : super(
          firstName: user.firstName,
          lastName: user.lastName,
          countryCode: user.countryCode,
          phoneNumber: user.phoneNumber,
        );
}