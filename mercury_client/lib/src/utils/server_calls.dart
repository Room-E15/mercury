import 'dart:developer';

import 'package:mercury_client/src/entities/user_info.dart';
import 'package:uuid/uuid.dart';

Future<bool> requestServerCheckCode(
    String code, String countryCode, String phoneNumber) async {
  // TODO implement, currently placeholder
  log('Asking server to check verification code: $code');

  return Future.delayed(const Duration(seconds: 2), () {
    return code == '1234';
  });
}

Future<void> requestServerSendCode(
    String countryCode, String phoneNumber, String carrier) async {
  // TODO implement
  log('Asking server to check verification code');
}

// if the user is registered, returns a FullUserInfo object,
// else returns a UserInfo object with the new user's ID
Future<UserInfo> fetchServerUserInfo() async {
  // TODO implement and make async
  log('Checking server for phone registration status...');
  log('Check complete, User is not registered.');

  return Future.delayed(const Duration(seconds: 2), () {
    return UserInfo(
      id: Uuid().v4(),
    );
    // return RegisteredUserInfo(
    //     id: Uuid().v4(),
    //     firstName: "Davide",
    //     lastName: "Falessi",
    //     countryCode: "39",
    //     phoneNumber: "1234567890");
  });
}

Future<void> sendServerUserData(RegisteredUserInfo user) async {
  // TODO implement
  log('[INFO] Sending user data to server...');
  return Future.delayed(const Duration(seconds: 2));
}
