import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:mercury_client/pages/qr/qr_scan_view.dart';
import 'package:mercury_client/pages/register/start_view.dart';
import 'package:mercury_client/utils/functions.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinServerPromptView extends StatelessWidget {
  static const routeName = '/join_server_prompt';

  final SharedPreferencesWithCache preferences;

  JoinServerPromptView({
    super.key,
    required this.preferences,
  });

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          title: appLogo,
          centerTitle: true,
          leading: (preferences.getBool('registered') == true)
              ? IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              : null,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Center(child: Text('Ciao Ragazzi', style: TextStyle(fontSize: 30))),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 150),
                ),
                const Text(
                  'Join a server to start',
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
                    onPressed: () async {
                      final serverAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRScanView(
                            barcodeType: BarcodeType.url,
                          ),
                        ),
                      );

                      if (serverAddress is Barcode &&
                          context.mounted &&
                          serverAddress.url != null) {
                        // Now that we have a new server, we can remove the old one
                        log('[SERVER URL] ${serverAddress.url?.url}');

                        preferences.setString(
                            'apiEndpoint', serverAddress.url!.url);
                        clearUserData(preferences);

                        Navigator.pushNamedAndRemoveUntil(
                            context, StartView.routeName, (route) => false);
                      } else {
                        // TODO do something on error
                      }
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
        ]));
  }
}
