// Form widget from Flutter
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mercury_client/src/entities/group.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile/profile_view.dart';
import 'package:http/http.dart' as http;
import '../services/globals.dart';
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SendAlertView extends StatelessWidget {
  SendAlertView({
    super.key,
    required this.preferences,
    required this.group,
  });

  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final SharedPreferencesWithCache preferences;
  final Group group;

  Future<void> _submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Process data.
      final title = titleController.text;
      final description = descriptionController.text;

      var data = {
        'memberId': preferences.getString('id'),
        'groupId': group.id,
        'title': title,
        'description': description,
      };

      var url = Uri.parse('$baseURL/alert/send');
      final response = await http.post(
        url,
        body: data,
      ).onError((error, stackTrace) {
        return http.Response('', 500);
      });

      if (response.statusCode == 200) {
        log('Cool to submit form!');
      } else {
        log('Failed to submit form to server $hostname!');
      }
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: appLogo,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(context, ProfileView.routeName);
              },
              icon: const Icon(Icons.person_rounded))
        ],
      ),
      body: ListView(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            margin: const EdgeInsetsDirectional.symmetric(
                vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFF4F378B),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            color: Color(0xFFFFFFFF),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 8),
                          ),
                          Text(
                            "New Alert",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFFFFF)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 10),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Add TextFormFields and ElevatedButton here.
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description (Optional)',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: FilledButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                _submitForm(context);
                            },
                            child: const Text('SEND ALERT'),
                          ),
                        ),
                      ),
                    ],
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
