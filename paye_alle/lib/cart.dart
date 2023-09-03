import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:paye_alle/login.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class Invoice {
  final List<Product> products;
  final double total;
  final DateTime date;
  final String userEmail;

  Invoice({
    required this.products,
    required this.total,
    required this.date,
    required this.userEmail,
  });
}

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

  double _calculateTotalPrice(List<QueryDocumentSnapshot> items) {
    double totalPrice = 0;

    for (var cartItem in items) {
      if (cartItem['status'] == 1) {
        totalPrice += cartItem['price'];
      }
    }

    return totalPrice;
  }

  Future<void> storeInvoice(Invoice invoice) async {
    try {
      final CollectionReference invoicesCollection = FirebaseFirestore.instance.collection('invoices');
      await invoicesCollection.add({
        'products': invoice.products.map((product) => {
          'name': product.name,
          'price': product.price,
        }).toList(),
        'total': invoice.total,
        'date': invoice.date,
        'userEmail': invoice.userEmail,
      });

      print('Invoice stored successfully');
    } catch (e) {
      print('Error storing invoice: $e');
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
        body:
        Container(
          color: Colors.grey[300],
          child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: getCartItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading cart items'));
              } else if (!snapshot.hasData ||
                  snapshot.data!.isEmpty ||
                  snapshot.data!.every((cartItem) => cartItem['status'] == 0)) {
                return Center(child: Text('Your cart is empty'));
              } else {
                final cartItems = snapshot.data!;
                final Items =
                cartItems.where((cartItem) => cartItem['status'] == 1).toList();

                double totalPrice = _calculateTotalPrice(Items);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
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
                            subtitle:
                            Text('Price: \$${productPrice.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              color:Colors.red,
                              onPressed: () async {
                                try {
                                  String userId =
                                      FirebaseAuth.instance.currentUser!.uid;

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

                                  setState(() {});

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Product removed from cart')),
                                  );
                                } catch (e) {
                                  print('Error removing product from cart: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error removing product from cart: $e')),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      //textStyle: TextStyle(fontSize: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff0000a7),
                          textStyle: TextStyle(fontSize: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => UsePaypal(
                                  sandboxMode: true,
                                  clientId:
                                  "Ab-ti52HlWgStItZPojaBjIbGJzOPm-gzwQixGDMNJz8n9YyiWiPdCi4DBnZeP4UUKPocbuQTR4uOI1C",
                                  secretKey:
                                  "EKYOg5nydC4BmijYh9IB15aicfQmPPGWDjnumiDR1yTR6ycpTmj0qoFrYcHcH8fcBkslqH7eSxjjspda",
                                  returnURL: "https://samplesite.com/return",
                                  cancelURL: "https://samplesite.com/cancel",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total": totalPrice.toStringAsFixed(2),
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": totalPrice.toStringAsFixed(2),
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                    }
                                  ],
                                  note: "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    print("onSuccess: $params");

                                    try {
                                      String userId = FirebaseAuth.instance.currentUser!.uid;

                                      // Retrieve the cart items
                                      List<QueryDocumentSnapshot> cartItems = await _firestore
                                          .collection('users')
                                          .doc(userId)
                                          .collection('cart').where('status', isEqualTo: 1)
                                          .get()
                                          .then((querySnapshot) => querySnapshot.docs);

                                      for (var cartItem in cartItems) {
                                        await _firestore
                                            .collection('users')
                                            .doc(userId)
                                            .collection('cart')
                                            .doc(cartItem.id)
                                            .update({'status': 0});
                                      }
                                      double totalPrice = _calculateTotalPrice(cartItems);

                                      Invoice invoice = Invoice(
                                        products: cartItems.map((cartItem) {
                                          final productName = cartItem['name'];
                                          final productPrice = cartItem['price'];
                                          return Product(
                                            name: productName,
                                            price: productPrice,
                                          );
                                        }).toList(),
                                        total: totalPrice,
                                        date: DateTime.now(),
                                        userEmail: FirebaseAuth
                                            .instance.currentUser!.email!,
                                      );

                                      storeInvoice(invoice);

                                      print("Cart items updated successfully");
                                      setState(() {});

                                    } catch (e) {
                                      print("Error updating cart items: $e");
                                    }
                                  },

                                  onError: (error) {
                                    print("onError: $error");
                                  },
                                  onCancel: (params) {
                                    print('cancelled: $params');
                                  }),

                              //builder: (BuildContext context) => PayPalScreen(totalPrice: totalPrice), // Pass the total price here
                            ),
                          );
                        },
                        child: Text('PAY: \$ ${totalPrice.toStringAsFixed(2)}'),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        ),
    );
  }
}

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
