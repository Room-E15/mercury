import 'package:flutter/material.dart';
import 'package:mercury_client/widgets/loading_widget.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/pages/home/home_view.dart';
import 'package:mercury_client/models/requests/member_requests.dart';
import 'package:mercury_client/models/data/user_info.dart';
import 'package:mercury_client/utils/log_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  static const routeName = '/register';

  final SharedPreferencesWithCache preferences;
  final String countryCode;
  final String phoneNumber;

  const RegisterView({
    super.key,
    required this.preferences,
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Future<String?>? _futureUserId;
  UserInfo? _user;

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
                        setState(() {
                          _user = UserInfo(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            countryCode: widget.countryCode,
                            phoneNumber: widget.phoneNumber,
                          );
                          _futureUserId = MemberRequests.requestRegisterUser(
                              _user as UserInfo);
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                // Loading icon and logic to move to next page
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _futureUserId == null
                      ? Container()
                      : loadingWidgetBuilder(
                          context: context,
                          futureIcon:
                              (_futureUserId as Future<String?>).then((userId) {
                            if (userId == null ) {
                              return const Text(
                                  'Failed to register on server!');
                            } else if (context.mounted && _user != null) {
                              logUserInfo(
                                  widget.preferences,
                                  RegisteredUserInfo.fromUser(
                                    _user as UserInfo,
                                    userId,
                                  ));

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeView.routeName,
                                (route) => false,
                              );
                              return Icon(Icons.check);
                            }
                          }),
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
