import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Push the QRScanView to get a new value
class QRScanView extends StatefulWidget {
  static const routeName = '/qr_scan';

  final RegExp? barcodeRegex;
  final BarcodeType? barcodeType;

  const QRScanView({
    super.key,
    this.barcodeRegex,
    this.barcodeType,
  });

  @override
  QRScanViewState createState() => QRScanViewState();
}

class QRScanViewState extends State<QRScanView> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size(480, 640),
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  StreamSubscription<Object?>? _subscription;
  bool _isProcessingBarcode = false; // Add this flag

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
        log('[QR SCANNER] App detached');
        return;
      case AppLifecycleState.hidden:
        log('[QR SCANNER] App hidden');
        return;
      case AppLifecycleState.paused:
        log('[QR SCANNER] App paused');
        return;
      case AppLifecycleState.resumed:
        log('[QR SCANNER] App resumed');
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription ??= controller.barcodes.listen(_handleBarcode);
        unawaited(controller.start());
        break;
      case AppLifecycleState.inactive:
        log('[QR SCANNER] App inactive');
        // Stop the scanner when the app is paused or inactive.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
        break;
    }
  }

  @override
  void initState() {
    log('[QR SCANNER] Initializing QR scanner');
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    log('[QR SCANNER] Disposing QR scanner');
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  void _handleBarcode(final BarcodeCapture barcodeCapture) {
    if (_isProcessingBarcode) return; // Check if already processing a barcode

    // QR validation checking
    if (barcodeCapture.barcodes.isEmpty ||
        barcodeCapture.barcodes.firstOrNull == null ||
        barcodeCapture.barcodes.first.rawValue == null) {
      log('[QR SCANNER] No barcode detected');
      return;
    }

    final rawValue = barcodeCapture.barcodes.first.rawValue as String;

    if (widget.barcodeRegex != null &&
        !(widget.barcodeRegex as RegExp).hasMatch(rawValue)) {
      log('[QR SCANNER] Barcode does not match regex: $rawValue');
      return;
    }

    if (widget.barcodeType != null &&
        barcodeCapture.barcodes.first.type != widget.barcodeType) {
      log('[QR SCANNER] Barcode type does not match: $rawValue');
      return;
    }

    log('[QR SCANNER] Barcode read successfully: $rawValue');
    _isProcessingBarcode = true; // Set the flag to true
    unawaited(controller.stop()); // Stop the scanner
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
    log('[QR SCANNER] Building QR scanner view');
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

