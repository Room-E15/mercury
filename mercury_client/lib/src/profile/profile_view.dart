import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.preferences,
  });

  static const routeName = '/profile';
  final SharedPreferencesWithCache preferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                '${preferences.getString('firstName')} ${preferences.getString('lastName')}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Phone Number',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
                '${preferences.getString('countryCode')} ${preferences.getString('phoneNumber')}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('QR Code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Center(
              child: QrImageView(
                  data: 'phone:${preferences.getString('id')}',
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: 200.0),
            ),
          ],
        ),
      ),
    );
  }
}
