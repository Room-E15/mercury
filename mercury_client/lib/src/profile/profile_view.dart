import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.profileName,
    required this.profilePhone,
  });

  static const routeName = '/profile';
  final String profileName;
  final String profilePhone;

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: profileName);

    return Scaffold(
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
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter your name",
                    ),
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
  }
}
