import 'package:flutter/material.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/models/data/group.dart';
import 'package:mercury_client/models/requests/send_alert_requests.dart';
import 'package:mercury_client/pages/profile/profile_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SendAlertView extends StatelessWidget {
  static const routeName = '/send_alert';

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
                            'New Alert',
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
                        child: FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                SendAlertRequests.saveAlert(
                                        preferences.getString('id') ?? '',
                                        group.id,
                                        titleController.text,
                                        descriptionController.text)
                                    .then((value) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('SEND ALERT'),
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
