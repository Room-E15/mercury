
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  static const routeName = '/qr_scan';

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  // final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Scan the QR code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Scan the QR code to join a server",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "QR Code",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // QRCodeDartScanView(
            //   scanInvertedQRCode: true, // enable scan invert qr code ( default = false)

            //   typeScan: TypeScan.live,
            //   onCapture: (Result result) {
            //     log('data: ${result.toString()}');
            //   }
            // ),
          ],
        ),
      ),
    );
  }
}
