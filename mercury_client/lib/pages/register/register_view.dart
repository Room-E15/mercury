import 'package:flutter/material.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';
import 'package:mercury_client/models/responses/user_creation_response.dart';
import 'package:mercury_client/widgets/loading_icon.dart';
import 'package:mercury_client/widgets/loading_widget.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mercury_client/pages/home/home_view.dart';
import 'package:mercury_client/models/data/user_info.dart';
import 'package:mercury_client/utils/log_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  static const routeName = '/register';

  final SharedPreferencesWithCache preferences;
  final String verificationToken;

  const RegisterView({
    super.key,
    required this.preferences,
    required this.verificationToken,
  });

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  LoadingState _loadingIconState = LoadingState.nothing;

  RegisteredUserInfo? _user;

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
                    controller: _firstNameController,
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
                    controller: _lastNameController,
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
                          _loadingIconState = LoadingState.loading;
                        });
                        VerificationRequests.requestRegisterUser(
                                widget.verificationToken,
                                _firstNameController.text,
                                _lastNameController.text)
                            .then((ucr) {
                          if (ucr == null || ucr.user == null) {
                            setState(() {
                              _loadingIconState = LoadingState.failure;
                            });
                            return const Text('Failed to register on server!');
                          } else {
                            _user = ucr.user;
                            setState(() {
                              _loadingIconState = LoadingState.success;
                            });

                            if (context.mounted) {
                              logUserInfo(
                                widget.preferences,
                                ucr.user!,
                              ).then((_) {
                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeView.routeName,
                                    (route) => false,
                                  );
                                }
                              });

                              return Icon(Icons.check);
                            }
                          }
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: LoadingIcon(state: _loadingIconState, errorMessage: 'Could not register user')),
        ],
      ),
    );
  }
}
