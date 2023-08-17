import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
                //child: Text('Scan result: $scanResult'),
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

  void _showScanResultDialog() async {
    CollectionReference products = FirebaseFirestore.instance.collection('items');

    DocumentSnapshot snapshot = await products.doc(scanResult).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Product Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show product image
                Image.network(data['image'], height: 150, width: 150),

                // Show product name
                Text('Name: ${data['name']}'),

                // Show product price
                Text('Price: \$${data['price']}'),
              ],
            ),
            actions: [
              Row( // Wrap buttons in a Row
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Set the background color of the button
                      backgroundColor: Color(0xff388e3c),
                    ),
                    onPressed: () {
                      //_addToCart(data); // Call the method to add to cart
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        isScanCompleted = false; // Allow scanning again
                      });
                    },
                    child: Text('Add to Cart'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Set the background color of the button
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      setState(() {
                        isScanCompleted = false; // Allow scanning again
                      });
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      // Handle the case when the scanned ID doesn't match any product
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Product Not Found'),
            content: Text('No product found.'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Set the background color of the button
                  backgroundColor: Colors.red,
                ),
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
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
