import 'package:flutter/material.dart';
import 'fingerprint_page.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider<AppStateModel>(
      create: (_) => AppStateModel()..loadProducts(),
      child: PayeAlle(),
    ),
  );
  //runApp(PayeAlle());
}

class PayeAlle extends StatelessWidget {
  PayeAlle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayeAlle',
      debugShowCheckedModeBanner: false,
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
        MaterialPageRoute(builder: (context) => LoginPage()),
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
            /*Text(
              'PayeAlle',
              style: TextStyle(fontSize: 24),
            ),*/
          ],
        ),
      ),
    );
  }
}