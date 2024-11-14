import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:mercury_client/src/home/dev_home_view.dart';  // TODO remove
import 'package:mercury_client/src/pages/home/home_view.dart';
import 'package:mercury_client/src/entities/requests/member_requests.dart';
import 'package:mercury_client/src/pages/register/loading_view.dart';
import 'package:mercury_client/src/entities/data/user_info.dart';
import 'package:mercury_client/src/utils/functions.dart';
import 'package:mercury_client/src/utils/widgets.dart';

class RegisterView extends StatelessWidget {
  static const routeName = '/register';

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final SharedPreferencesWithCache preferences;
  final String countryCode;
  final String phoneNumber;

  RegisterView({
    super.key,
    required this.preferences,
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appLogo,
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
                        final user = UserInfo(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            countryCode: countryCode,
                            phoneNumber: phoneNumber,
                          );

                        final future = MemberRequests.requestRegisterUser(user).then((userId) {
                          userId ??= 'spingis';  // TODO figure out what to do if the server fails
                          return logUserInfo(preferences, RegisteredUserInfo.fromUser(user, userId));
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingView(
                              future: future,
                              onFinish: (_) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  HomeView.routeName,
                                  (route) => false,
                                );
                              },
                            ),
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