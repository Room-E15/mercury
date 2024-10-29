import 'dart:developer';

import 'package:mercury_client/src/loading/loading_view.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:mercury_client/src/home/home_view.dart';

import 'verification_view.dart';

class RegisterView extends StatelessWidget {
  static const routeName = '/register';

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final Widget logo;
  final String countryCode;
  final String phoneNumber;
  final Uuid id;

  RegisterView({
    super.key,
    required this.logo,
    required this.countryCode,
    required this.phoneNumber,
    required this.id,
  });

  Future<void> sendServerUserData() async {
    // TODO implement
    log('[INFO] Sending user data to server...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo,
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                  "Thanks for verifying! Please enter your name to get started.")),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Please only use only alphabetical characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                        return 'Please only use only alphabetical characters';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        final future = logUserInfo(RegisteredUserInfo(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            countryCode: countryCode,
                            phoneNumber: phoneNumber,
                            id: id));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingView(
                                future: future,
                                onFinish: (na) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      HomeView.routeName, (route) => false);
                                }),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
