import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/group.dart';

import '../home/home_view.dart';

class VerificationView extends StatelessWidget {
  static const routeName = '/verify';
  static const availableChars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final _rnd = Random();

  final TextEditingController verificationCodeController =
      TextEditingController();
  final String verificationCode = generateRandomString(6);

  final Widget logo;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  static String generateRandomString(int length) {
    return List.generate(length,
        (index) => availableChars[_rnd.nextInt(availableChars.length)]).join();
  }
  // TODO figure out how to ask server to send SMS when page loads
  VerificationView({
    super.key,
    required this.logo,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back)),
          title: logo,
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    "Welcome, $firstName $lastName! Enter the verification code sent to your phone number.")),
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
                          groups: GroupTestData.groups,
                          logo: logo,
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
            Text("Hint: $verificationCode"),  // TODO remove, for debugging
          ],
        ));
  }
}
