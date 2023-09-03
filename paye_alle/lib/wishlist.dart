import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff388e3c),
        title: Text('Wish list'),
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
        toolbarHeight: 65,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wish')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('List is empty'));
          }

          final wishes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: wishes.length,
            itemBuilder: (context, index) {
              final wish = wishes[index];
              final wishData = wish.data() as Map<String, dynamic>;
              return Dismissible(
                key: Key(wish.id), // Unique key for each item
                onDismissed: (direction) {
                  _removeWish(wish.id); // Remove the wish by its ID
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted from list.'),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red, // Background color when swiping
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  /*child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),*/
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Text(
                        (index + 1).toString()+".",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    title: Text(
                      wishData['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddWishDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff388e3c),
      ),
    );
  }

  void _showAddWishDialog(BuildContext context) {
    String itemName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add to Wish List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Item'),
                onChanged: (value) {
                  itemName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {

                if (itemName.isNotEmpty) {
                  _addWish(itemName);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Add',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),

          ],
        )
        ;
      },
    );
  }

  void _addWish(String itemName) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('wish').add({
      'name': itemName,
      'userId': userId,
    });
  }

  void _removeWish(String wishId) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('wish')
        .where('userId', isEqualTo: userId)
        .where(FieldPath.documentId, isEqualTo: wishId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });
  }
}
