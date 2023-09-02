//import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'login.dart';

class Invoice {
  final DateTime date;
  final List<Product> products;
  final double total;
  final String userEmail;
  //final String imageUrl;

  Invoice({
    required this.date,
    required this.products,
    required this.total,
    required this.userEmail,
    //required this.imageUrl,
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

    //final imageUrl = doc['imageUrl'];
    final invoice = Invoice(
      date: doc['date'].toDate(),
      products: products,
      total: doc['total'].toDouble(),
      userEmail: doc['userEmail'],
      //imageUrl: imageUrl,
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
          invoices.sort((a, b) => b.date.compareTo(a.date));
          //SizedBox(height: 50);
          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              Invoice invoice = invoices[index];
              return ListTile(
                title: Text(
                  'Date: ${invoice.date.toString()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make the title bold
                    fontSize: 16, // Adjust the font size
                  ),
                ),
                subtitle: Text(
                  'Total: \$${invoice.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey, // Customize subtitle text color
                  ),
                ),
                onTap: () {
                  _showInvoiceDetailsDialog(context, invoice);
                },
                tileColor: Colors.white, // Set the background color of the ListTile
                contentPadding: EdgeInsets.all(16), // Add padding around the content
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Add rounded corners
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.5), // Add a border
                    width: 1,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

void _showInvoiceDetailsDialog(BuildContext context, Invoice invoice) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Invoice Details',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Apply bold font weight to title
            fontSize: 18, // Customize font size
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User: ${invoice.userEmail}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16, // Customize font size
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Products:',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Apply bold font weight to section title
                fontSize: 16, // Customize font size
              ),
            ),
            Column(
              children: invoice.products.map((product) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 25),
            Text(
              'Total: \$${invoice.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          )
        ],
      );
    },
  );
}


class InvoiceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff388e3c),
          title: Text('Transactions'),
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
          /*actions: <Widget>[
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
          ],*/
          toolbarHeight: 65,
        ),
        body: InvoiceListWidget(),
      //),
    );
  }
}
