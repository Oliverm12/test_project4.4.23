import 'package:flutter/material.dart';
import 'fingerprint_page.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(PayeAlle());
}

class PayeAlle extends StatelessWidget {
  PayeAlle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayeAlle',
      home: SplashScreen(),
    );
  }
}
final bool debugShowCheckedModeBanner = false;
class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FingerprintPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('./icon/letter_p.png', width: 200),
            SizedBox(height: 20),
            Text(
              'PayeAlle',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}