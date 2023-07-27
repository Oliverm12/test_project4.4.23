import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'fingerprint_page.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scanResult = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff388e3c),
          title: Text('PayeAlle'),
          titleTextStyle: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w500,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () {
                final auth = MockFirebaseAuth();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(auth: auth,)),
                );
              },
            ), //IconButton
          ],
          toolbarHeight: 65,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      //cutOutSize: scanArea
                    )
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text('Scan result: $scanResult'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isScanCompleted = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanCompleted) {
      setState(() {
        scanResult = scanData.code!;
        isScanCompleted = true;
      });
      _showScanResultDialog(); // Show the scan result in a pop-up dialog
    }
    });
  }

  void _showScanResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Scan Result'),
          content: Text(scanResult),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  isScanCompleted = false; // Allow scanning again
                });
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
