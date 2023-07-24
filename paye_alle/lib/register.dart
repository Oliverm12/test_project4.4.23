import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  void _openLoginPage(BuildContext ctx) {
    final auth = MockFirebaseAuth();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(auth: auth,)),
    );
  }

  void registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorPopup('Please fill in all fields.');
      return;
    }

    if (!isEmailValid(email)) {
      _showErrorPopup('Invalid email format.');
      return;
    }

    if (!isPasswordValid(password)) {
      _showErrorPopup('Password must be at least 8 characters long.');
      return;
    }

    if (!doPasswordsMatch(password, confirmPassword)) {
      _showErrorPopup('Passwords do not match.');
      return;
    }

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Registration successful, navigate back to login page
      _openLoginPage(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'weak-password') {
        _showErrorPopup('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorPopup('The account already exists for that email.');
      } else {
        _showErrorPopup('An error occurred. Please try again later.');
      }
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
              child: Text('OK'),
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
        title: Text('Register Page'),
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    key: Key('password'),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    key: Key('confirmPassword'),
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff388e3c),
                  ),
                  onPressed: registerUser,
                  child: const Text('Register'),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    _openLoginPage(context);
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
