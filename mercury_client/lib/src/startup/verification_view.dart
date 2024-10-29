import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:mercury_client/src/home/home_view.dart';
import 'package:mercury_client/src/loading/loading_view.dart';
import 'package:mercury_client/src/startup/register_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class VerificationView extends StatelessWidget {
  static const routeName = '/verify';
  static const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final _rnd = Random();

  final TextEditingController verificationCodeController =
      TextEditingController();
  final String verificationCode = generateRandomString(6);

  final Widget logo;
  final String countryCode;
  final String phoneNumber;
  final String carrier;

  static String generateRandomString(int length) {
    return List.generate(length,
        (index) => availableChars[_rnd.nextInt(availableChars.length)]).join();
  }

  VerificationView({
    super.key,
    required this.logo,
    required this.countryCode,
    required this.phoneNumber,
    required this.carrier,
  });

  Future<void> askServerToSendVerificationCode() async {
    // TODO implement
    dev.log('Asking server to send verification code: $verificationCode');
  }

  // if the user is registered, returns a FullUserInfo object,
  // else returns a UserInfo object with the new user's ID
  Future<UserInfo> getServerUserInfo() async {
    // TODO implement and make async
    dev.log('Checking server for phone registration status...');
    dev.log('Check complete, User is not registered.');
    return UserInfo(id: Uuid());
  }

  @override
  Widget build(BuildContext context) {
    askServerToSendVerificationCode();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: logo,
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    "Enter the verification code sent to your phone number.")),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: verificationCodeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Fetch info from server to decide which page to load
                  if (verificationCodeController.text == verificationCode) {
                    final infoFuture = getServerUserInfo().then((userInfo) {
                      if (userInfo is RegisteredUserInfo) {
                        logUserInfo(userInfo).then((future) {
                          if (context.mounted) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, HomeView.routeName, (route) => false);
                          }
                        });
                      } else if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RegisterView(
                              logo: logo,
                              countryCode: countryCode,
                              phoneNumber: phoneNumber,
                              id: userInfo.id,
                            );
                          }),
                        );
                      }
                    });

                    // push a loading page to wait for user info from server
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LoadingView(future: infoFuture);
                    }));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Invalid Verification Code'),
                          content: const Text(
                              'The verification code you entered is invalid. Please try again.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            Text("Hint: $verificationCode"),  // TODO remove, for debugging
          ],
        ));
  }
}

Future<void> logUserInfo(RegisteredUserInfo user) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('registered', true);
  await prefs.setString('id', user.id.toString());
  await prefs.setString('firstName', user.firstName);
  await prefs.setString('lastName', user.lastName);
  await prefs.setString('countryCode', user.countryCode);
  await prefs.setString('phoneNumber', user.phoneNumber);
}
