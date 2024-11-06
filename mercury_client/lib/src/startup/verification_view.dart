import 'dart:math' as math;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/group.dart';
import 'package:mercury_client/src/loading/loading_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../home/home_view.dart';

class UserInfo {
  final Uuid id;

  UserInfo({
    required this.id,
  });
}

// TODO make it so you can't go back to SMS verify
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
  // TODO remove all annoying ass characters you can't tell the difference between
  static const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // TODO remove once server generates code
  static final _rnd = math.Random();

  final verificationCodeController = TextEditingController();

  final Widget logo;
  final SharedPreferencesWithCache preferences;
  final String countryCode;
  final String phoneNumber;
  final String carrier;

  // TODO figure out how to ask server to send SMS when page loads
  VerificationView({
    super.key,
    required this.logo,
    required this.preferences,
    required this.countryCode,
    required this.phoneNumber,
    required this.carrier,
  });

  Future<String> requestServerVerification() async {
    // TODO implement, currently placeholder
    final verificationCode = List.generate(
            6, (index) => availableChars[_rnd.nextInt(availableChars.length)])
        .join();

    log('Asking server to send verification code: $verificationCode');

    return Future.delayed(const Duration(seconds: 2), () {
      return verificationCode;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  if (verificationCodeController.text == verificationCode) {
                    // logUserInfo();  // TODO implement
                    // sendServerUserInfo();  // TODO implement

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(
                          groups: GroupTestData
                              .groups, // TODO remove groups passed in
                          logo: logo,
                          isManager: true,
                        ),
                      ),
                    );
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
            Text("Hint: $verificationCode"), // TODO remove, for debugging
          ],
        ));
  }
}
