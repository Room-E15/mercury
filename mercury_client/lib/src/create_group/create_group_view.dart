import 'package:flutter/material.dart';
import '../entities/group.dart';
import '../home/home_view.dart';

class CreateGroupView extends StatelessWidget {
  final TextEditingController groupNameController = TextEditingController();

  final Widget logo;
  final formKey = GlobalKey<FormState>();

  CreateGroupView({super.key, required this.logo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: logo,
      ),
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(40, 180, 40, 40),
              child: Text("Lets get a new group Started!")),
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
                      } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
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
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeView(
                                logo: logo,
                                groups: GroupTestData.groups,
                                isManager: true,
                              ),
                            ));
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