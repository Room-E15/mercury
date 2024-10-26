// Form widget from Flutter
import 'package:flutter/material.dart';
import 'package:mercury_client/src/qr_scan/qr_scan_view.dart';

class JoinServerPromptView extends StatelessWidget {
  JoinServerPromptView({
    super.key,
    required this.logo,
  });

  static const routeName = '/join_server_prompt';

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
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Center(child: Text("Hi, Albert Alertstein")),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 150),
                ),
                const Text(
                  "Join a server to start",
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 30),
                ),
                IconButton.filled(
                    iconSize: 40,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4F378B),
                      foregroundColor: const Color(0xFFFFFFFF),
                    ),
                    onPressed: () {
                      Navigator.restorablePushNamed(
                          context, QRScanView.routeName);
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
        ]));
  }
}
