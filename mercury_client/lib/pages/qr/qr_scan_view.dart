import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// import 'package:mercury_client/src/home/dev_home_view.dart';  // TODO remove
import 'package:mercury_client/pages/home/home_view.dart';  
import 'package:mercury_client/widgets/loading_widget.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  static const routeName = '/qr_scan';

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

Future<String> requestRegistrationFromServer(String? groupCode) async {
  return Future.delayed(const Duration(seconds: 2), () {
    return 'success';
  });
}

class _QRScanViewState extends State<QRScanView> {
  Future<String>? loading;

  final MobileScannerController controller = MobileScannerController(
    cameraResolution: Size(480, 640),
    detectionSpeed: DetectionSpeed.unrestricted,
  );

  void _handleBarcode(BuildContext context, BarcodeCapture barcodes) {
    if (mounted) {
      controller.stop();
      var future =
          requestRegistrationFromServer(barcodes.barcodes.first.rawValue);
        setState(() { loading = future; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 480,
      height: 640,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (loading != null)
            LoadingWidget<String>(
              future: loading as Future<String>,
              childBuilder: (context, value) {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeView.routeName, (route) => false);
                }
                return SizedBox(height: 0, width: 0);
              },
            ),
          MobileScanner(
            fit: BoxFit.contain,
            scanWindow: scanWindow,
            controller: controller,
            onDetect: (barcodes) => _handleBarcode(context, barcodes),
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
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
