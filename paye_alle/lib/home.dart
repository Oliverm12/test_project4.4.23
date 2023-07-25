import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:paye_alle/login.dart';
import 'package:paye_alle/qrscanner.dart';

//import 'fingerprint_page.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({ Key? key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<HomePage1> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> imageUrls = []; // List to store image URLs

  @override
  void initState() {
    super.initState();
    // Call a function to fetch the image URLs from Firestore
    fetchImageUrls();
  }

  // Function to fetch image URLs from Firestore
  void fetchImageUrls() {
    _firestore.collection('images').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot docSnapshot) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        var imageUrl = data['url'];
        setState(() {
          imageUrls.add(imageUrl);
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
            onPressed: () {
              final auth = MockFirebaseAuth();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(auth: auth,)),
              );
            },
          ), //IconButton
        ],
        toolbarHeight: 65,
      ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                ),
                items: imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 150), // Add some space between the carousel and the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Button 1 - Redirect to a new page
                Container(
                  width: 100,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to a new page
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPage()),
                      );*/
                    },
                    child: Text('New Page'),
                  ),
                ),
                // Button 2 - Redirect to the scanning page
                Container(
                  width: 100,
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the scanning page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QrCodeScanner()),
                      );
                    },
                    child: Text('Scan'),
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