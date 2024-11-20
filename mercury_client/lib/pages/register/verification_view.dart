import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mercury_client/pages/home/home_view.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/pages/register/log_user_info.dart';
import 'package:mercury_client/models/requests/sms_requests.dart';
import 'package:mercury_client/models/data/user_info.dart';
import 'package:mercury_client/pages/register/register_view.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum LoadingState {
  nothing,
  loading,
  success,
  failure,
}

class VerificationView extends StatefulWidget {
  static const routeName = '/verify';

  final SharedPreferencesWithCache preferences;
  final int countryCode;
  final String phoneNumber;
  final String carrier;

  const VerificationView({
    super.key,
    required this.preferences,
    required this.countryCode,
    required this.phoneNumber,
    required this.carrier,
  });

  @override
  VerificationViewState createState() => VerificationViewState();
}

class VerificationViewState extends State<VerificationView> {
  final codeController = TextEditingController();
  var _loadingIconState = LoadingState.nothing;
  var _verificationToken = "";

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
  void initState() {
    super.initState();
    SmsRequests.requestSendCode(
            widget.countryCode, widget.phoneNumber, widget.carrier)
        .then((response) {
      if (response != null && response.carrierFound) {
        setState(() {
          _verificationToken = response.token;
        });

        // TODO figure out what to do on this screen if you can't connect to the server
        // TODO SERIOUSLY SHOW AN ERROR HERE IT'S BAD
      }
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
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: (_verificationToken == "")
                    ? null
                    : () {
                        // when you press the button, it should cause a loading symbol
                        setState(() {
                          _loadingIconState = LoadingState.loading;
                        });

                        // when the server responds, it should change to display a result symbol

                        SmsRequests.requestCheckCode(
                                codeController.text, _verificationToken)
                            .then((response) async {
                          final codeIsCorrect = response.correctCode,
                              user = response.userInfo;

                          setState(() {
                            _loadingIconState = codeIsCorrect
                                ? LoadingState.success
                                : LoadingState.failure;
                          });

                          if (codeIsCorrect) {
                            // TODO currently have 2 second delay for "check" animation, make less jank
                            final animationDelay = 2;

                            // if the user is registered, log their info and send them to the homepage
                            if (user is RegisteredUserInfo) {
                              logUserInfo(widget.preferences, user)
                                  .then((future) {
                                Future.delayed(
                                    Duration(seconds: animationDelay), () {
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        HomeView.routeName, (route) => false);
                                  }
                                });
                              });

                              // otherwise, send them to the registration page
                            } else {
                              Future.delayed(Duration(seconds: animationDelay),
                                  () {
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context2) => RegisterView(
                                            preferences: widget.preferences,
                                            countryCode: widget.countryCode,
                                            phoneNumber: widget.phoneNumber),
                                      ),
                                      (route) => false);
                                }
                              });
                            }
                          } else {
                            // if the code is incorrect, reset the loading icon
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              _loadingIconState = LoadingState.nothing;
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
          ],
        ));
  }
}
