import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';

import 'fingerprint_page.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<HomePage1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}