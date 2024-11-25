import 'package:mercury_client/models/data/user_info.dart';

class UserCreationResponse {
  final String status;
  final String? description;
  final RegisteredUserInfo? user;

  UserCreationResponse({
    required this.status,
    this.description,
    this.user,
  });

  factory UserCreationResponse.fromJson(Map json) {
    return UserCreationResponse(
      status: json['status'],
      description: json['description'],
      user: json['user'] == null
          ? null
          : RegisteredUserInfo.fromUser(
              UserInfo(
                firstName: json['user']['firstName'],
                lastName: json['user']['lastName'],
                countryCode: json['user']['countryCode'],
                phoneNumber: json['user']['phoneNumber'],
              ),
              json['user']['id'],
            ),
    );
  }
}
