// Form widget from Flutter
import 'package:flutter/material.dart';
import 'package:mercury_client/src/utils/widgets.dart';
import '../profile/profile_view.dart';
import 'package:http/http.dart' as http;
import '../services/globals.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class SendAlertView extends StatelessWidget {
  SendAlertView({
    super.key,
  });

  static const routeName = '/send_alert';

  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;

      final uri = Uri.parse('$baseURL/sendAlert');
      final response = await http.post(
        uri,
        body: {
          'title': title,
          'description': description,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Failed to submit form!')),
        );
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
                        const Row(
                          children: [
                            Text("Location (Recommended)",
                                textAlign: TextAlign.left),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Maps logic here
                            Placeholder(
                              color: Color(0xFF4F378B), // Color of the cross
                              strokeWidth: 2.0, // Thickness of the cross lines
                              fallbackWidth: 280.0, // Width if not constrained
                              // fallbackHeight:
                              //     280.0, // Height if not constrained
                            ),
                          ],
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
                              if (formKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sending Alert')),
                                );
                                _submitForm();
                              }
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
