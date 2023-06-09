import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'fingerprint_page.dart';

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanResult = scanData.code!;

      });
      //showModal(scanResult);
    });
  }
    void showModal(String scanResult) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Text(scanResult),
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
