import 'package:mercury_client/models/data/user_info.dart';

class SMSVerifyResponse {
  final bool correctCode;
  final UserInfo? userInfo;

  SMSVerifyResponse({
    required this.correctCode,
    this.userInfo,
  });

  SMSVerifyResponse.fromJson(Map json)
      : correctCode= json['correctCode'],
        userInfo = (json['userInfo'] != null) ? 
        RegisteredUserInfo(
          id: json['userInfo']['id'],
          firstName: json['userInfo']['firstName'],
          lastName: json['userInfo']['lastName'],
          countryCode: json['userInfo']['countryCode'],
          phoneNumber: json['userInfo']['phoneNumber'],
        ) : null;
}
