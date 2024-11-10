import 'package:flutter/material.dart';
import 'package:mercury_client/src/startup/loading_view.dart';
import 'package:mercury_client/src/entities/user_info.dart';
import 'package:mercury_client/src/startup/register_view.dart';
import 'package:mercury_client/src/utils/functions.dart';
import 'package:mercury_client/src/utils/server_calls.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/src/home/home_view.dart';

enum LoadingState {
  nothing,
  loading,
  success,
  failure,
}

class VerificationView extends StatefulWidget {
  static const routeName = '/verify';

  final SharedPreferencesWithCache preferences;
  final String countryCode;
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
    requestServerSendCode(
        widget.countryCode, widget.phoneNumber, widget.carrier);

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

                  requestServerCheckCode(codeController.text,
                          widget.countryCode, widget.phoneNumber)
                      .then((codeIsCorrect) async {
                    setState(() {
                      _loadingIconState = codeIsCorrect
                          ? LoadingState.success
                          : LoadingState.failure;
                    });

                    if (codeIsCorrect) {
                      final infoFuture = fetchServerUserInfo();

                      Future.delayed(const Duration(seconds: 1), () {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context2) => LoadingView(
                                future: infoFuture,
                                onFinish: (info) {
                                  // if the user is registered, log their info and send them to the homepage
                                  if (info is RegisteredUserInfo) {
                                    logUserInfo(widget.preferences, info)
                                        .then((_) {
                                      if (context2.mounted) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context2,
                                            HomeView.routeName,
                                            (route) => false);
                                      }
                                    });
                                    // otherwise, send them to the registration page
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
