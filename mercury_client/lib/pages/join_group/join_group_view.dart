import 'package:flutter/material.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/models/requests/group_requests.dart';
import 'package:mercury_client/pages/home/home_view.dart';

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
              child: Text('Manually enter a join code')),
          Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: groupIdController,
                    decoration: const InputDecoration(
                      labelText: 'Join Code',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter some text';
                      } else if (!RegExp(r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}').hasMatch(value)) {
                        return 'Please enter in format 8-4-4-4-12';
                        //7756e438-109f-47c7-8eb8-82f67d3fb69d
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
