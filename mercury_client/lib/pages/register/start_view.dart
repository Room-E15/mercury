import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mercury_client/models/data/carrier_tab_list.dart';
import 'package:mercury_client/models/requests/verification_requests.dart';
import 'package:mercury_client/models/responses/sms_dispatch_response.dart';
import 'package:mercury_client/pages/register/email_register_widget.dart';
import 'package:mercury_client/pages/register/sms_register_widget.dart';
import 'package:mercury_client/widgets/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mercury_client/pages/register/verification_view.dart';

class StartView extends StatefulWidget {
  static const routeName = '/start';
  final SharedPreferencesWithCache preferences;

  const StartView({super.key, required this.preferences});

  @override
  State<StatefulWidget> createState() => _StartViewState();
}

enum LoadingState {
  nothing,
  loading,
  success,
  failure,
}

class _StartViewState extends State<StartView> {
  final codeController = TextEditingController();
  List<(Tab, Widget)> tabs = [];

  @override
  void initState() {
    super.initState();

    VerificationRequests.requestCarrierLists().then((CarrierTabList? tabList) {
      if (tabList == null) {
        log("Failed to get carrier list");
        return;
      }
      tabList.forEach((type, name, carriers) {
        setState(() {
          try {
            tabs.add(
              (
                Tab(text: name),
                switch (type) {
                  'sms' => SmsRegisterWidget(
                      carriers: carriers,
                      countryCodes: [1, 39],
                      onSubmit: (BuildContext context,
                          Future<SMSDispatchResponse?> future) {
                        future.then((response) {
                          if (response != null &&
                              context.mounted &&
                              response.carrierFound) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerificationView(
                                  preferences: widget.preferences,
                                  verificationToken: response.token,
                                ),
                              ),
                            );
                          }
                        });
                      }),
                  'email' => EmailRegisterWidget(onSubmit:
                        (BuildContext context,
                            Future<SMSDispatchResponse?> future) {
                      future.then((response) {
                        if (response != null &&
                            context.mounted &&
                            response.carrierFound) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerificationView(
                                preferences: widget.preferences,
                                verificationToken: response.token,
                              ),
                            ),
                          );
                        }
                      });
                    }),
                  _ => throw Exception('Invalid type $type')
                }
              ),
            );
          } catch (e) {
            log(e.toString());
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: appLogo,
          bottom: TabBar(
            tabs: tabs.map((e) => e.$1).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((e) => e.$2).toList(),
        ),
      ),
    );
  }
}
