import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Push the QRScanView to get a new value
class QRScanView extends StatelessWidget {
  static const routeName = '/qr_scan';

  static final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size(480, 640),
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  final BuildContext callerContext;
  final RegExp? barcodeRegex;
  final BarcodeType? barcodeType;

  const QRScanView({
    super.key,
    this.barcodeRegex,
    this.barcodeType,
    required this.callerContext,
  });

  void _onDetect(
      final BuildContext context, final BarcodeCapture barcodeCapture) {
    // QR validation checking
    if (barcodeCapture.barcodes.isEmpty ||
        barcodeCapture.barcodes.firstOrNull == null ||
        barcodeCapture.barcodes.first.rawValue == null) {
      log('[QR SCANNER] No barcode detected');
      Navigator.pop(context);
      return;
    }

    final rawValue = barcodeCapture.barcodes.first.rawValue as String;

    if (barcodeRegex != null && !(barcodeRegex as RegExp).hasMatch(rawValue)) {
      log('[QR SCANNER] Barcode does not match regex: $rawValue');
      Navigator.pop(context);
      return;
    }

    if (barcodeType != null &&
        barcodeCapture.barcodes.first.type != barcodeType) {
      log('[QR SCANNER] Barcode type does not match: $rawValue');
      Navigator.pop(context);
      return;
    }

    Navigator.pop(context, barcodeCapture.barcodes.first);
  }

  Rect _buildScanWindow(BuildContext context) {
    final Size layoutSize = MediaQuery.sizeOf(context);
    final double scanWindowWidth = layoutSize.width / 3;
    final double scanWindowHeight = layoutSize.height / 2;
    return Rect.fromCenter(
      center: layoutSize.center(Offset.zero),
      width: scanWindowWidth,
      height: scanWindowHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.contain,
            scanWindow: _buildScanWindow(context),
            controller: controller,
            onDetect: (barcode) => _onDetect(context, barcode),
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
        ],
      ),
    );
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// class ScannedBarcodeLabel extends StatelessWidget {
//   const ScannedBarcodeLabel({
//     super.key,
//     required this.barcodes,
//   });

//   final Stream<BarcodeCapture> barcodes;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: barcodes,
//       builder: (context, snapshot) {
//         final scannedBarcodes = snapshot.data?.barcodes ?? [];

//         if (scannedBarcodes.isEmpty) {
//           return const Text(
//             'Scan something!',
//             overflow: TextOverflow.fade,
//             style: TextStyle(color: Colors.white),
//           );
//         }

//         return Text(
//           scannedBarcodes.first.displayValue ?? 'No display value.',
//           overflow: TextOverflow.fade,
//           style: const TextStyle(color: Colors.white),
//         );
//       },
//     );
//   }
// }

