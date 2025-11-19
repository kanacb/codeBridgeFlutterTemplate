import 'dart:io';
import 'package:aims/Widgets/MemTickets/SelectedMemMachine.dart';
import 'package:aims/Widgets/RaiseTicket/SelectedMachine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../App/Dash/DashMain.dart';
import '../../Utils/Globals.dart';
import '../ExternalTickets/SelectedExternalMachine.dart';
import '../IncomingMachineTickets/SelectedIncomingMachine.dart';

class QrCodeScanner extends StatefulWidget {
  final String companyType;

  const QrCodeScanner({
    super.key,
    required this.companyType,
  });

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  CameraFacing? _cameraFacing;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String serialNumber = "";
  bool scannerState = true;
  bool showKeyboard = false;
  bool? _isFlashOn;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _loadCameraInfo();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Future<void> _loadFlashStatus() async {
    final flashStatus = await controller?.getFlashStatus();
    if (!mounted) return;
    setState(() {
      _isFlashOn = flashStatus;
    });
  }

  Future<void> _toggleFlash() async {
    await controller?.toggleFlash();
    await _loadFlashStatus();
  }

  Future<void> _loadCameraInfo() async {
    final info = await controller?.getCameraInfo();
    if (!mounted || info == null) return;
    setState(() {
      _cameraFacing = info;
    });
  }

  Future<void> _flipCamera() async {
    if (_isFlashOn == true) {
      await _toggleFlash();
    }

    await controller?.flipCamera();
    await _loadCameraInfo(); // reload camera info after flip
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Scanner'),
        backgroundColor: Colors.white,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      'Type: ${(result!.format)}   Serial No.: ${result!.code}',
                    )
                  else
                    const Text('Scan the serial number'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: _cameraFacing == CameraFacing.back ? _toggleFlash : null,
                          child: _isFlashOn == null
                              ? const Icon(Icons.flash_off)
                              : _isFlashOn!
                                  ? const Icon(Icons.flash_on_outlined)
                                  : const Icon(Icons.flash_off),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            scannerState = !scannerState;
                            if (!scannerState) {
                              await controller?.pauseCamera();
                            } else {
                              await controller?.resumeCamera();
                            }
                            setState(() {});
                          },
                          child:
                              scannerState
                                  ? Icon(Icons.pause_circle_filled_outlined)
                                  : Icon(Icons.play_arrow_rounded),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: _flipCamera,
                          child: _cameraFacing == null
                              ? const Text('loading')
                              : _cameraFacing == CameraFacing.back
                                  ? const Icon(Icons.camera_rear_outlined)
                                  : const Icon(Icons.camera_front_outlined),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            showKeyboard = !showKeyboard;
                            await controller?.pauseCamera();
                            _navigateToSelectedMachine();
                          },
                          child:
                              showKeyboard
                                  ? Icon(Icons.qr_code_2_rounded)
                                  : Icon(Icons.keyboard_alt_rounded),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay ascordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 200.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      formatsAllowed: [
        BarcodeFormat.qrcode,
        BarcodeFormat.codabar,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.code128,
        BarcodeFormat.rss14,
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    _loadCameraInfo();

    controller.scannedDataStream.listen((scanData) {
      if (_navigated) return; // ignore further scans
      _navigated = true;

      _navigateToSelectedMachine(scanData: scanData);
      controller.stopCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    logger.i('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  void _navigateToSelectedMachine({Barcode? scanData}) {
    if (widget.companyType == "atlas") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SelectedMachine(
            result: scanData,
            companyType: widget.companyType,
          ),
        ),
      );
    } else if (widget.companyType == "irms") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SelectedIncomingMachine(
            result: scanData,
            companyType: widget.companyType,
          ),
        ),
      );
    } else if (widget.companyType == "etika") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SelectedMemMachine(
            result: scanData,
            companyType: widget.companyType,
          ),
        ),
      );
    }
    else if (widget.companyType == "external" || widget.companyType == "External") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SelectedExternalMachine(
            result: scanData,
            companyType: widget.companyType,
          ),
        ),
      );
    }
  }
}
