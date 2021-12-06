import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/ui/my_orders/dialog_box.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    super.initState();
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "My order",
          style: GoogleFonts.rubik(color: Colors.white),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('orders')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        width: size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        height: size.height * 0.34,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                spreadRadius: 2),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(" Order # ${index + 1}"),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Container(
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Address:",
                                        style: TextStyle(
                                            fontSize: size.width * 0.05,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Container(
                                        width: size.width * 0.65,
                                        child: Text(
                                          " ${snapshot.data.docs[index]['address']}",
                                          style: TextStyle(
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Price:",
                                        style: TextStyle(
                                            fontSize: size.width * 0.04,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        " ${snapshot.data.docs[index]['price']}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Phone number:",
                                          style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          " ${snapshot.data.docs[index]['phone']}",
                                          style: TextStyle(
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Product count:",
                                        style: TextStyle(
                                            fontSize: size.width * 0.04,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        " ${snapshot.data.docs[index]['productId'].length}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Product status:",
                                          style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          " ${snapshot.data.docs[index]['status']}",
                                          style: TextStyle(
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  child: snapshot.data.docs[index]['status'] ==
                                          'completed'
                                      ? IconButton(
                                          onPressed: () {
                                            showDialogBox(context, '');
                                          },
                                          icon: const Icon(Icons.star))
                                      : Container(),
                                )
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('orders')
                                      .doc(snapshot.data.docs[index].id)
                                      .delete();
                                },
                                icon: const Icon(Icons.delete))
                          ],
                        ));
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    ));
  }

  showDialogBox(BuildContext context, String? placeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: CustomDialogBox(
            placeId: placeId,
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
