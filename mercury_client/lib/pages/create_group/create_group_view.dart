import 'package:flutter/material.dart';

import 'package:mercury_client/models/requests/group_requests.dart';
import 'package:mercury_client/pages/home/home_view.dart';
import 'package:mercury_client/widgets/logo.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CreateGroupView extends StatelessWidget {
  final TextEditingController groupNameController = TextEditingController();
  final SharedPreferencesWithCache preferences;

  final formKey = GlobalKey<FormState>();

  CreateGroupView({super.key, required this.preferences});

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
              child: Text('Lets get a new group started!')),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                        return 'Please only use only alphanumeric characters';
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
                        GroupRequests.requestCreateGroup(
                            memberId, groupNameController.text);
                        Navigator.pushNamed(
                          // TODO change to pushNamed
                          context,
                          HomeView.routeName,
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
