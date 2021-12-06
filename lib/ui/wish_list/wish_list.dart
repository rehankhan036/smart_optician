import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Wish list",
            style: GoogleFonts.rubik(color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('wishList')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(right: size.width * 0.03),
                                  width: size.width * 0.4,
                                  height: size.height * 0.12,
                                  child: Image.network(
                                      '${snapshot.data.docs[index]['image']}'),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Brand:  ${snapshot.data.docs[index]['brand']}'),
                                    Text(
                                        'Gender:  ${snapshot.data.docs[index]['gender']}'),
                                    Text(
                                        'Price:  ${snapshot.data.docs[index]['price']}')
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('wishList')
                                            .doc(snapshot.data.docs[index].id)
                                            .delete();
                                      },
                                    ),
                                    InkWell(
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('cart')
                                            .doc()
                                            .set({
                                          'image': snapshot.data.docs[index]
                                              ['image'],
                                          'brand': snapshot.data.docs[index]
                                              ['brand'],
                                          'price': snapshot.data.docs[index]
                                              ['price'],
                                          'gender': snapshot.data.docs[index]
                                              ['gender'],
                                          'quantity': snapshot.data.docs[index]
                                              ['quantity'],
                                          'productId': snapshot.data.docs[index]
                                              ['productId'],
                                          'ownerId': snapshot.data.docs[index]
                                              ['ownerId']
                                        }).whenComplete(() {
                                          showSnackBarSuccess(
                                              context, 'Product added to cart');
                                          goBackPreviousScreen(context);
                                        });
                                      },
                                      child: Text(
                                        "Add to cart",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
