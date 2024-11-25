import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';

import 'package:mercury_client/pages/home/home_view.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/utils/log_user_info.dart';
import 'package:mercury_client/models/data/user.dart';
import 'package:mercury_client/pages/register/register_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mercury_client/widgets/loading_icon.dart';

class VerificationView extends StatefulWidget {
  static const routeName = '/verify';

  final SharedPreferencesWithCache preferences;
  final String verificationToken;

  const VerificationView({
    super.key,
    required this.preferences,
    required this.verificationToken,
  });

  @override
  VerificationViewState createState() => VerificationViewState();
}

class VerificationViewState extends State<VerificationView> {
  final codeController = TextEditingController();
  var _loadingIconState = LoadingState.nothing;

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
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                    'Enter the verification code sent to your phone number.')),
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
                onPressed:(widget.verificationToken == '')
                    ? null
                    : () {
                        // when you press the button, it should cause a loading symbol
                        setState(() {
                          _loadingIconState = LoadingState.loading;
                        });

                        // when the server responds, it should change to display a result symbol

                        VerificationRequests.requestVerifyCode(
                                codeController.text, widget.verificationToken)
                            .then((response) async {
                          final (codeIsCorrect, user) = response;

                          setState(() {
                            _loadingIconState = codeIsCorrect
                                ? LoadingState.success
                                : LoadingState.failure;
                          });

                          if (codeIsCorrect) {
                            // TODO convert to real animation, 2 second delay is for "check" animation,
                            final animationDelay = 2;

                            // if the user is registered, log their info and send them to the homepage
                            if (user is RegisteredUser) {
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
                                            verificationToken:
                                                widget.verificationToken),
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
                child: LoadingIcon(state: _loadingIconState, errorMessage: 'Invalid Verification Code')),
          ],
        ));
  }
}
