import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';

//import 'fingerprint_page.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Auth _auth = Auth();

  Future<List<QueryDocumentSnapshot>> getCartItems() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return querySnapshot.docs;
    } else {
      return []; // Return an empty list if the user is not logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff388e3c),
          title: Text('PayeAlle'),
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log out',
              onPressed: () async {
                final auth = MockFirebaseAuth();
                try {
                  await auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage(auth: auth)),
                  );
                } catch (e) {
                  print("Error during sign out: $e");
                  // Handle sign-out error if needed
                }
              },
            ), //IconButton
          ],
          toolbarHeight: 65,
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading cart items'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data!.every((cartItem) => cartItem['status'] == 0)) {
              return Center(child: Text('Your cart is empty'));
            } else {
              final cartItems = snapshot.data!;
              final Items =
              cartItems.where((cartItem) => cartItem['status'] == 1).toList();

                //final cartItems = snapshot.data!;
                return ListView.builder(
                  itemCount: Items.length,
                  itemBuilder: (context, index) {
                    final cartItem = Items[index];
                    final productName = cartItem['name'];
                    final productPrice = cartItem['price'];
                    final imageUrl = cartItem["image"];
                    final cartItemId = cartItem.id;

                    String scanResult = cartItem['scanResult'];

                    return ListTile(
                      leading: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
                      title: Text(productName),
                      subtitle: Text('Price: \$${productPrice.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () async {
                          try {
                            String userId = FirebaseAuth.instance.currentUser!.uid;

                            await _firestore
                                .collection('users')
                                .doc(userId)
                                .collection('cart')
                                .doc(cartItemId)
                                .update({'status': 0});

                            await _firestore
                                .collection('items')
                                .doc(scanResult)
                                .update({'status': 1});

                            /* QuerySnapshot itemSnapshot = await _firestore
                                .collection('items')
                                .where('id', isEqualTo: scanResult)
                                .get();

                            if (itemSnapshot.docs.isNotEmpty) {
                              await itemSnapshot.docs.first.reference.update({'status': 1});
                            }*/

                            // Refresh the cart list
                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Product removed from cart')),
                            );
                          } catch (e) {
                            print('Error removing product from cart: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error removing product from cart: $e')),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Method to get the current authenticated user
  User? get currentUser => _firebaseAuth.currentUser;
}