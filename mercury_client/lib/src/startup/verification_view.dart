import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/group.dart';
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
        return Row(mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.close),
          Text('Invalid Verification Code'),
        ],) ;
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
                      .then((isVerified) async {
                    setState(() {
                      _loadingIconState = isVerified
                          ? LoadingState.success
                          : LoadingState.failure;
                    });

                    // sendServerUserInfo();  // TODO implement
                    // logUserInfo();  // TODO implement

                    if (isVerified) {
                      // TODO instead of future.delayed, change to an animation that executes lambda once finished
                      Future.delayed(const Duration(seconds: 1), () {
                          // Navigator.pushNamed(context, HomeView.routeName);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeView(
                                groups: GroupTestData.groups, // TODO remove
                                isManager: true, // TODO remove
                              ),
                            ),
                          );
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
