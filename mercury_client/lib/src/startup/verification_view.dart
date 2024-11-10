import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/startup/loading_view.dart';
import 'package:mercury_client/src/entities/user_info.dart';
import 'package:mercury_client/src/startup/register_view.dart';
import 'package:mercury_client/src/utils/functions.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/src/home/home_view.dart';
import 'package:uuid/uuid.dart';

enum LoadingState {
  nothing,
  loading,
  success,
  failure,
}

class VerificationView extends StatefulWidget {
  static const routeName = '/verify';

  final codeController = TextEditingController();

  final SharedPreferencesWithCache preferences;
  final String countryCode;
  final String phoneNumber;
  final String carrier;

  VerificationView({
    super.key,
    required this.preferences,
    required this.countryCode,
    required this.phoneNumber,
    required this.carrier,
  });

  Future<void> requestServerSendCode() async {
    // TODO implement
    log('Asking server to check verification code');
  }

  Future<bool> requestServerCheckCode(String code) async {
    // TODO implement, currently placeholder
    log('Asking server to check verification code: $code');

    return Future.delayed(const Duration(seconds: 2), () {
      return code == '1234';
    });
  }

  // if the user is registered, returns a FullUserInfo object,
  // else returns a UserInfo object with the new user's ID
  Future<UserInfo> fetchServerUserInfo() async {
    // TODO implement and make async
    log('Checking server for phone registration status...');
    log('Check complete, User is not registered.');

    return Future.delayed(const Duration(seconds: 2), () {
      return UserInfo(
        id: Uuid(),
      );
      // return RegisteredUserInfo(
      //     id: Uuid(),
      //     firstName: "Davide",
      //     lastName: "Falessi",
      //     countryCode: "39",
      //     phoneNumber: "1234567890");
    });
  }

  @override
  VerificationViewState createState() => VerificationViewState();
}

class VerificationViewState extends State<VerificationView> {
  var _loadingIconState = LoadingState.nothing;

  Widget displayLoadingIcon(LoadingState state) {
    // TODO add nice animations for check (slowly fills in) and X (shakes widget)
    switch (state) {
      case LoadingState.nothing:
        return Container();
      case LoadingState.loading:
        return const CircularProgressIndicator();
      case LoadingState.success:
        return const Icon(Icons.check);
      case LoadingState.failure:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.close),
            Text('Invalid Verification Code'),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.requestServerSendCode();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: appLogo,
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
                controller: widget.codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // when you press the button, it should cause a loading symbol
                  setState(() {
                    _loadingIconState = LoadingState.loading;
                  });

                  // when the server responds, it should change to display a result symbol
                  widget
                      .requestServerCheckCode(widget.codeController.text)
                      .then((enteredCorrectCode) async {
                    setState(() {
                      _loadingIconState = enteredCorrectCode
                          ? LoadingState.success
                          : LoadingState.failure;
                    });

                    // sendServerUserInfo();  // TODO implement
                    // logUserInfo();  // TODO implement

                    if (enteredCorrectCode) {
                      final infoFuture = widget.fetchServerUserInfo();

                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context2) => LoadingView(
                                future: infoFuture,
                                onFinish: (info) {
                                  if (info is RegisteredUserInfo) {
                                    logUserInfo(info).then((_) {
                                      if (context2.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context2,
                                            HomeView.routeName,
                                            (route) => false);
                                      }
                                    });
                                  } else if (context2.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                        context2,
                                        MaterialPageRoute(
                                          builder: (context2) => RegisterView(
                                              preferences: widget.preferences,
                                              countryCode: widget.countryCode,
                                              phoneNumber: widget.phoneNumber,
                                              carrier: widget.carrier,
                                              id: info.id),
                                        ),
                                        (route) => false);
                                  }
                                },
                              ),
                            ),
                          );
                        }
                      });
                    }
                  });
                },
                child: const Text('Submit'),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: displayLoadingIcon(_loadingIconState)),
            Text("Hint: 1234"), // TODO remove, for debugging
          ],
        ));
  }
}
