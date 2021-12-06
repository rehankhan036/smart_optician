import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';
import 'package:smart_optician/ui/checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> productList = [];
  List<String> productListPrice = [];
  List<String> productOwnerList = [];
  List<String> productIdList = [];

  int price = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Container(
        width: size.width,
        height: size.height * 0.7,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.1,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                    Text(
                      "My Cart",
                      style: GoogleFonts.cabin(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: size.width * 0.06,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.14,
                    ),
                  ],
                ),
              ),
              Container(
                  width: size.width,
                  height: size.height,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('cart')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length ?? 0,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: size.height * 0.2,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty
                                                .all<Color>(Colors.black),
                                            shape: CircleBorder(),
                                            value: productIdList.contains(
                                                snapshot.data.docs[index]
                                                    ['code']),
                                            onChanged: (value) {
                                              setState(() {
                                                if (value!) {
                                                  productIdList.add(snapshot
                                                      .data
                                                      .docs[index]['code']);
                                                  productListPrice.add(snapshot
                                                      .data
                                                      .docs[index]['price']);
                                                  productOwnerList.add(snapshot
                                                      .data
                                                      .docs[index]['ownerId']);
                                                } else {
                                                  productIdList.remove(snapshot
                                                      .data
                                                      .docs[index]['code']);
                                                  productListPrice.remove(
                                                      snapshot.data.docs[index]
                                                          ['price']);
                                                  productOwnerList.remove(
                                                      snapshot.data.docs[index]
                                                          ['ownerId']);
                                                }
                                              });
                                              price = 0;
                                              for (int i = 0;
                                                  i < productListPrice.length;
                                                  i++) {
                                                price = price +
                                                    int.parse(
                                                        productListPrice[i]);
                                              }
                                            }),
                                        Container(
                                          width: size.width * 0.25,
                                          height: size.height * 0.14,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data.docs[index]['image']),
                                          )),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "${snapshot.data.docs[index]['name']}",
                                                style: GoogleFonts.cabin(
                                                    color: Colors.grey.shade700,
                                                    fontSize:
                                                        size.width * 0.035,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Rs.${snapshot.data.docs[index]['price']}",
                                                style: GoogleFonts.cabin(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: size.width * 0.1),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    if (snapshot.data
                                                                .docs[index]
                                                            ['quantity'] >
                                                        1) {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection('cart')
                                                          .doc(snapshot.data
                                                              .docs[index].id)
                                                          .update({
                                                        'quantity': snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'] -
                                                            1
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove,
                                                    size: size.width * 0.04,
                                                  )),
                                              Text(
                                                  "${snapshot.data.docs[index]['quantity']}"),
                                              IconButton(
                                                  onPressed: () {
                                                    if (snapshot.data
                                                                .docs[index]
                                                            ['quantity'] >
                                                        0) {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .collection('cart')
                                                          .doc(snapshot.data
                                                              .docs[index].id)
                                                          .update({
                                                        'quantity': snapshot
                                                                    .data
                                                                    .docs[index]
                                                                ['quantity'] +
                                                            1
                                                      });
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: size.width * 0.04,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection('cart')
                                          .doc(snapshot.data.docs[index].id)
                                          .delete();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        return const Center();
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11.5),
        height: size.height * 0.16,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Subtotal :",
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.045,
                  ),
                ),
                Text(
                  "Rs. $price",
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.045,
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {
                if (productListPrice.length == 0) {
                  showSnackBarFailed(context, 'Please select product');
                  return;
                }
                screenPush(
                  context,
                  CheckOutScreen(
                    productIdList: productIdList,
                    productList: productList,
                    productListPrice: productListPrice,
                    productOwnerList: productOwnerList,
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: size.height * 0.023),
                alignment: Alignment.center,
                width: size.width * 0.8,
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Checkout',
                  style: GoogleFonts.cabin(
                      color: Colors.white, fontSize: size.width * 0.05),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
