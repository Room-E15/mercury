import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Push the QRScanView to get a new value
class QRScanView extends StatelessWidget {
  final RegExp? barcodeRegex;
  final BarcodeType? barcodeType;

  QRScanView({
    super.key,
    this.barcodeRegex,
    this.barcodeType,
  });

  static const routeName = '/qr_scan';


  final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size(480, 640),
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 480,
      height: 640,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            fit: BoxFit.contain,
            scanWindow: scanWindow,
            controller: controller,
            onDetect: (barcodeCapture) {
              // QR validation checking
              if (barcodeCapture.barcodes.isEmpty 
              || barcodeCapture.barcodes.firstOrNull == null
              || barcodeCapture.barcodes.first.rawValue == null) {
                throw Error();
              } 

              final rawValue = barcodeCapture.barcodes.first.rawValue as String; 

              if (barcodeRegex != null &&  (barcodeRegex as RegExp).hasMatch(rawValue)) {
                throw Error();
              }

              if (barcodeType != null && barcodeCapture.barcodes.first.type != barcodeType) {
                throw Error();
              }

              Navigator.pop(context, barcodeCapture.barcodes.first);
            },
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

