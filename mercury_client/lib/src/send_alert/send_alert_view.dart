// Form widget from Flutter
import 'package:flutter/material.dart';
import '../profile/profile_view.dart';

class SendAlertView extends StatelessWidget {
  SendAlertView({
    super.key,
    required this.logo,
  });

  static const routeName = '/send_alert';

  final Widget logo;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: logo,
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
      body: Column(
        children: [
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              margin: const EdgeInsetsDirectional.symmetric(
                  vertical: 10.0, horizontal: 20.0),
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: const Color(0xFF4F378B),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 2, 2, 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.alarm,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                end: 8)),
                                        Text(
                                          "New Alert",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 16, 16, 10),
                                child: Row(
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        children: <Widget>[
                                          // Add TextFormFields and ElevatedButton here.
                                          SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Title',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                labelText:
                                                    'Description (Optional)',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Row(
                                            children: [
                                              Text("Location (Recommended)",
                                                  textAlign: TextAlign.left),
                                            ],
                                          ),
                                          const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Google Maps logic here
                                              Placeholder(
                                                color: Color(
                                                    0xFF4F378B), // Color of the cross
                                                strokeWidth:
                                                    2.0, // Thickness of the cross lines
                                                fallbackWidth:
                                                    280.0, // Width if not constrained
                                                fallbackHeight:
                                                    280.0, // Height if not constrained
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    16, 12, 16, 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: FilledButton(
                                          onPressed: () {
                                            // Validate returns true if the form is valid, or false otherwise.
                                            if (formKey.currentState!
                                                .validate()) {
                                              // If the form is valid, display a snackbar. In the real world,
                                              // you'd often call a server or save the information in a database.
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Processing Data')),
                                              );
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
