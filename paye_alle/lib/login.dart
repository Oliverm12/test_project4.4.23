import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/src/firebase_auth_mocks_base.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required MockFirebaseAuth auth});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _openUserReg (BuildContext ctx) {
    showModalBottomSheet(context: ctx, isScrollControlled: false, builder: (_) {
      return const UserReg();
    },);
  }

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color(0xff388e3c),
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Color(0xff388e3c),
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
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

              // email text_field_
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child:TextField(
                key: Key('email'),
                controller: emailController,
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),),),

              const SizedBox(height: 25),

              // password text_field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child:TextField(
                obscureText: true,
                key: Key('password'),
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),),),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // sign in button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // login button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Set the background color of the button
                      backgroundColor: Color(0xff388e3c),
                    ),
                    child: const Text('Login'),
                    onPressed: () {
                      signUserIn();
                    },
                  ),

                  // add some spacing between the buttons
                  SizedBox(width: 20),

                  // register button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Set the background color of the button
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Register'),
                    onPressed: () => _openUserReg( (context),
                  ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),),
    );
  }
}