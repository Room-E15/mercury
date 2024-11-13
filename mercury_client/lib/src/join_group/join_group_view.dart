import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/src/entities/requests/group_requests.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:mercury_client/src/home/home_view.dart';

class JoinGroupView extends StatelessWidget {
  final TextEditingController groupIdController = TextEditingController();
  final SharedPreferencesWithCache preferences;

  final formKey = GlobalKey<FormState>();

  JoinGroupView({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    final String memberId = preferences.getString('id')!;

    return Scaffold(
      appBar: AppBar(
        title: appLogo,
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40, 180, 40, 40),
              child: Text("Lets join a group!")),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: groupIdController,
                    decoration: const InputDecoration(
                      labelText: 'Group Id',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Please only use only numeric characters';
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
                      if (formKey.currentState!.validate()) {
                        GroupRequests.requestJoinGroup(
                            memberId, groupIdController.text);
                        Navigator.pushNamed(context, HomeView.routeName);
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
