import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';
import 'package:smart_optician/model/stripe_model.dart';
import 'package:smart_optician/ui/checkout/stripe_service.dart';

import 'credit_card.dart';

class CheckOutScreen extends StatefulWidget {
  final List<String> productList;
  final List<String> productListPrice;
  final List<String> productOwnerList;
  final List<String> productIdList;

  const CheckOutScreen(
      {Key? key,
      required this.productList,
      required this.productListPrice,
      required this.productOwnerList,
      required this.productIdList})
      : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerPhoneNum = TextEditingController();
  String address = '';
  String phoneNumber = '';
  bool isCashOnDelivery = true;

  int price = 0;
  String? deliveryMethod;
  @override
  void initState() {
    super.initState();
    StripeService.init();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      _controllerAddress.text = value.get('address');
      _controllerPhoneNum.text = value.get('phoneNum');
    }).whenComplete(() {
      setState(() {});
    });
    for (int i = 0; i < widget.productListPrice.length; i++) {
      price = int.parse(widget.productListPrice[i]) + price;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.95),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
                    "Checkout",
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
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery address",
                      style: GoogleFonts.cabin(
                        color: Colors.black,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                height: size.height * 0.1,
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerAddress,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "your delivery address"),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerPhoneNum,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Phone number"),
                ),
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.only(left: 13, top: 15),
                child: Text(
                  "Billing information",
                  style: GoogleFonts.cabin(
                    color: Colors.black,
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: size.height * 0.1,
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Column(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "Delivery fee",
                    //         style: GoogleFonts.cabin(
                    //             color: Colors.grey.shade500,
                    //             fontSize: size.width * 0.035,
                    //             fontWeight: FontWeight.w600),
                    //       ),
                    //       Text(
                    //         "Rs.500",
                    //         style: GoogleFonts.cabin(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.w900,
                    //           fontSize: size.width * 0.035,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "Subtotal:",
                    //         style: GoogleFonts.cabin(
                    //             color: Colors.grey.shade500,
                    //             fontSize: size.width * 0.035,
                    //             fontWeight: FontWeight.w600),
                    //       ),
                    //       Text(
                    //         "Rs.700",
                    //         style: GoogleFonts.cabin(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.w900,
                    //           fontSize: size.width * 0.035,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: GoogleFonts.cabin(
                                color: Colors.grey.shade500,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Rs.$price",
                            style: GoogleFonts.cabin(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: size.width * 0.035,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.only(left: 13, top: 15, bottom: 10),
                child: Text(
                  "Billing information",
                  style: GoogleFonts.cabin(
                    color: Colors.black,
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: size.height * 0.07,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Radio(
                        value: true,
                        groupValue: isCashOnDelivery,
                        onChanged: (value) {
                          setState(() {
                            isCashOnDelivery = true;
                          });
                        }),
                    Text(
                      "Cash on delivery",
                      style: GoogleFonts.cabin(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.05),
                    )
                  ],
                ),
              ),
              Container(
                width: size.width,
                height: size.height * 0.07,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Radio(
                        value: false,
                        groupValue: isCashOnDelivery,
                        onChanged: (value) {
                          setState(() {
                            isCashOnDelivery = false;
                          });
                        }),
                    Text(
                      "Stripe",
                      style: GoogleFonts.cabin(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.05),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () async {
            if (_controllerPhoneNum.text.length <= 10) {
              showSnackBarFailed(context, 'Please enter correct phone number');
            } else if (_controllerAddress.text.length <= 6) {
              showSnackBarFailed(context, 'Please enter correct address');
            } else if (isCashOnDelivery == null) {
              showSnackBarFailed(context, 'Please select delivery method');
            } else {
              if (isCashOnDelivery) {
                orderBooked(context);
                Navigator.pop(context);
                Navigator.pop(context);
                showSnackBarSuccess(context, 'Order booked successfully');
              } else {
                final stripeTransactionResponse =
                    await StripeService.payWithNewCard(
                        amount: '$price', currency: 'USD');

                if (stripeTransactionResponse.success ?? false) {
                  orderBooked(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  showSnackBarSuccess(
                      context, '${stripeTransactionResponse.message}');
                  showSnackBarSuccess(context, 'Order booked successfully');
                } else {
                  showSnackBarSuccess(
                      context, '${stripeTransactionResponse.message}');
                }
              }
            }
          },
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.07,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: 5),
            child: Text(
              'Proceed',
              style: GoogleFonts.cabin(
                color: Colors.white,
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  orderBooked(BuildContext context) async {
    for (int i = 0; i < widget.productOwnerList.length; i++) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('orders')
          .doc(widget.productIdList[i])
          .set({
        'status': 'pending',
        'address': _controllerAddress.text,
        'phone': _controllerPhoneNum.text,
        'deliveryMethod': isCashOnDelivery ? 'cashOnDelivery' : 'Stripe',
        "productId": widget.productIdList,
        'price': price,
        'customerId': FirebaseAuth.instance.currentUser!.uid,
        'ownerId': widget.productOwnerList[i]
      }).whenComplete(() async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.productOwnerList[i])
            .collection('bookingOrders')
            .doc(widget.productIdList[i])
            .set({
          'status': 'pending',
          'address': _controllerAddress.text,
          'phone': _controllerPhoneNum.text,
          'deliveryMethod': isCashOnDelivery ? 'cashOnDelivery' : 'Stripe',
          "productId": widget.productIdList,
          'price': price,
          'customerId': FirebaseAuth.instance.currentUser!.uid,
          'ownerId': widget.productOwnerList[i]
        });
      }).whenComplete(() {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('cart')
            .doc(widget.productIdList[i])
            .delete();
      });
    }
  }
}
