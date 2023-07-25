import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _openLoginPage(BuildContext ctx) {
    final auth = MockFirebaseAuth();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(auth: auth,)),
    );
  }

  void resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      _showErrorPopup('Please enter your email.');
      return;
    }

    if (!isEmailValid(email)) {
      _showErrorPopup('Incorrect email.');
      return;
    }

    // Show loading circle
   /*showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );*/

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessPopup('A password reset link has been sent to your email.');
      //_openLoginPage(context);
    } catch (e) {
      _showErrorPopup('Failed to send password reset email. Please try again.');
    }
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff388e3c),
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(''),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessPopup(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff388e3c),
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(''),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff388e3c),
        title: Text('Forgot Password'),
        titleTextStyle: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Image.asset('./icon/letter_p.png', width: 150),
                SizedBox(height: 20),
                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    key: Key('email'),
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff388e3c),
                  ),
                  onPressed: resetPassword,
                  child: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
