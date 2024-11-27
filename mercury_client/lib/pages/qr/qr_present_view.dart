import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPresentView extends StatelessWidget {
  const QRPresentView({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groupName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'QR Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 50, 16, 16),
              child: Center(
                child: QrImageView(
                  data: groupId,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  size: 300.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 40, 16, 16),
              child: Center(
                child: FilledButton(
                  onPressed: () {
                    // Download website link logic here
                  },
                  child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.copy_outlined,
                            size: 20, color: Color(0xFFFFFFFF)),
                        SizedBox(width: 8),
                        Text('Copy Link', style: TextStyle(fontSize: 14))
                      ])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
