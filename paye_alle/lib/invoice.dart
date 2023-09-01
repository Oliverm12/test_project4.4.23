import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class Invoice {
  final DateTime date;
  final List<Product> products;
  final double total;
  final String userEmail;

  Invoice({
    required this.date,
    required this.products,
    required this.total,
    required this.userEmail,
  });
}

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

Future<List<Invoice>> fetchInvoices() async {
  final firestore = FirebaseFirestore.instance;
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  await firestore.collection('invoices').get();

  List<Invoice> invoices = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
    final List<dynamic> productsList = doc['products'];
    final List<Product> products = productsList.map((product) {
      return Product(
        name: product['name'],
        price: product['price'].toDouble(),
      );
    }).toList();

    final invoice = Invoice(
      date: doc['date'].toDate(),
      products: products,
      total: doc['total'].toDouble(),
      userEmail: doc['userEmail'],
    );

    invoices.add(invoice);
  }

  return invoices;
}

class InvoiceListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Invoice>>(
      future: fetchInvoices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No invoices found.'));
        } else {
          List<Invoice> invoices = snapshot.data!;

          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              Invoice invoice = invoices[index];
              return ListTile(
                title: Text('Date: ${invoice.date.toString()}'),
                subtitle: Text('Total: \$${invoice.total.toStringAsFixed(2)}'),
                // You can display other invoice details here
              );
            },
          );
        }
      },
    );
  }
}

class InvoiceListScreen extends StatelessWidget {
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
        body: InvoiceListWidget(),
      ),
    );
  }
}
