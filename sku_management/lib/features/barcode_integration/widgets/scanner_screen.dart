import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.onDetect,
    required this.isScanningQr,
  });
  final Function(String) onDetect;
  final bool isScanningQr;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
            onDetect: (barcodeCapture) async {

              if (isProcessing) return; // Prevent multiple detections
              isProcessing = true; // Set processing flag

              print(widget.isScanningQr);
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                final BarcodeFormat format = barcode.format;
                print(
                  'format: $format -------------------------------------------',
                );
                if (code != null) {
                  // Filter based on scanning mode
                  if (widget.isScanningQr && format == BarcodeFormat.qrCode) {
                    print(
                      'QR Code detected: $code -------------------------------------------',
                    );
                    print('popping scanner screen----------------------------');
                    if (mounted) {
                      Navigator.pop(context);
                      widget.onDetect(code); // Call your handler
                    }
                  } else if (!widget.isScanningQr &&
                      format == BarcodeFormat.code128) {
                    print(
                      'Barcode detected: $code -------------------------------------------',
                    );
                    print('popping scanner screen----------------------------');
                    if (mounted) {
                      Navigator.pop(context);
                      widget.onDetect(code); // Call your handler
                    }
                  }
                }
              }
            },
          ),

          // Dark overlay with transparent square
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Optional white border for scan window
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Back button or label
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
