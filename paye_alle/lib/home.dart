import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';
//import 'package:paye_alle/qrscanner.dart';
//import 'package:paye_alle/webscreen.dart';
import 'package:paye_alle/wishlist.dart';

import 'invoice.dart';

//import 'fingerprint_page.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<HomePage1> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> imageUrls = [];
  List<String> captions = [];

  @override
  void initState() {
    super.initState();
    // Call a function to fetch the image URLs from Firestore
    fetchImageUrls();
  }

  void fetchImageUrls() {
    _firestore.collection('images').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        var imageUrl = data['url'];
        var caption = data['caption'];
        setState(() {
          imageUrls.add(imageUrl);
          captions.add(caption);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
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
                // Handle sign out error if needed
              }
            },
          ), //IconButton
        ],
        toolbarHeight: 65,
      ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
                items: imageUrls.asMap().entries.map((entry) {
                  int index = entry.key;
                  String url = entry.value;
                  String caption = captions[index]; // Get the corresponding caption

                  return Builder(
                    builder: (BuildContext context) {
                      return //Column(
                          ListView(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 200,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10.0), // Add some spacing between the image and caption

                            Text(
                            caption,
                              textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0, // You can adjust the font size
                              fontWeight: FontWeight.bold, // You can adjust the font weight
                            ),
                          ),

                          SizedBox(height: 25.0),
                        ],
                      //)
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 125,
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff009688),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InvoiceListScreen()
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined, // Add your desired icon
                          size: 32,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text('Transactions', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 125,
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff009688),
                    ),
                    onPressed: () {
                      // Navigate to the scanning page
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WishlistScreen())
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.format_list_bulleted, // Add your desired icon
                          size: 32,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Text('Wish list', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],

            ),
          ],
        ),
      )
    );
  }
}