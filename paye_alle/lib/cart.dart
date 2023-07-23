import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';

//import 'fingerprint_page.dart';

class Cart extends StatefulWidget {
  const Cart({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Cart> {

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
      ),
    );
  }
}
