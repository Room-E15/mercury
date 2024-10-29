import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  static const routeName = '/profile';

  late final SharedPreferences _prefs;
  late final String profileName;
  late final String profilePhone;

  ProfileView({super.key}) {
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    _prefs = await SharedPreferences.getInstance();
    profileName =
        "${_prefs.getString('firstName') ?? 'No name'} ${_prefs.getString('lastName') ?? ''}";
    profilePhone =
        "${_prefs.getString('countryCode') ?? 'No phone number'} ${_prefs.getString('phoneNumber') ?? ''}";
  }

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    _loadUserInfo().then((context) {
      widget = Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      profileName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Phone Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                profilePhone,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "QR Code",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Center(
                child: QrImageView(
                  data: 'phone:$profilePhone',
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: 200.0,
                ),
              ),
            ],
          ),
        ),
      );
    }).catchError((error) {
      widget = Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Center(
          child: Text(
            'Error loading profile information.',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    });

    return widget;
  }
}
