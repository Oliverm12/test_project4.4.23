import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PayPalScreen extends StatelessWidget {
  final double totalPrice;
  const PayPalScreen({Key? key, required this.totalPrice}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paypal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PayPal_Screen(title: 'Paypal'),
    );
  }
}

class PayPal_Screen extends StatefulWidget {
  const PayPal_Screen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PayPal_Screen> createState() => _PayPalScreen();
}

class _PayPalScreen extends State<PayPal_Screen> {
  @override
  Widget build(BuildContext context) {
    var totalPrice;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: TextButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId:
                        "ARujTAv63fufU2Cz-SIht-nwx2PBfWsldh1FiFXYxW42y59BUkta6MWy_e8c-bNMCnf2iQGTSQ4sm4qO",
                        secretKey:
                        "EBNpePr-hBx01-NrCPfmX1T8AOScuqwd4wzoGv2_eel46lIl2HANd4fqVYonmECRlugbM66fXF5xfuqP",
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: [
                          {
                            "amount": {
                              "total": totalPrice = totalPrice.toStringAsFixed(2),
                              "currency": "USD",
                              "details": {
                                "subtotal": totalPrice = totalPrice.toStringAsFixed(2),
                                "shipping": '0',
                                "shipping_discount": 0
                              }
                            },
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          print("onSuccess: $params");
                        },
                        onError: (error) {
                          print("onError: $error");
                        },
                        onCancel: (params) {
                          print('cancelled: $params');
                        }),
                  ),
                )
              },
              child: const Text("Make Payment")),
        )
    );
  }
}