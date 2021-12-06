import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';
import 'package:smart_optician/ui/cart_screen/cart_screen.dart';
import 'package:smart_optician/ui/chat_screen/chat_screen.dart';
import 'package:smart_optician/ui/home_screen/component/web_view_screen.dart';

import 'in_app_browser.dart';

class ProductViewScreen extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String desc;
  final String productId;
  final String ownerId;
  final String brandName;
  final String gender;
  const ProductViewScreen(
      {Key? key,
      required this.imageUrl,
      required this.name,
      required this.price,
      required this.desc,
      required this.productId,
      required this.ownerId,
      required this.brandName,
      required this.gender})
      : super(key: key);

  @override
  _ProductViewScreenState createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  int quantity = 0;
  bool isLiked = false;

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
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.brandName,
                    style: GoogleFonts.cabin(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: size.width * 0.06,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            screenPush(
                                context,
                                ChatScreenWithUser(
                                  receiverName: 'Owner',
                                  receiverId: widget.ownerId,
                                ));
                          },
                          icon: const Icon(Icons.message)),
                      IconButton(
                          onPressed: () async {
                            screenPush(context, WebViewScreen());
                            // InAppBrowser.openWithSystemBrowser(
                            //   url: Uri.parse(
                            //       "https://jeeliz.com/demos/jeelizWidgetGitPublicDemo/"),
                            // );
                            // await MyInAppBrowser.openUrlRequest(
                            //     urlRequest:
                            //     URLRequest(url: Uri.parse("https://flutter.dev")),
                            //     options: InAppBrowserClassOptions(
                            //         inAppWebViewGroupOptions: InAppWebViewGroupOptions(
                            //             crossPlatform: InAppWebViewOptions(
                            //               useShouldOverrideUrlLoading: true,
                            //               useOnLoadResource: true,
                            //             ))));
                          },
                          icon: const Icon(Icons.threed_rotation)),
                    ],
                  )
                ],
              ),
              Container(
                alignment: Alignment.topRight,
                width: size.width,
                height: size.height * 0.5,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: size.width * 0.065,
                          ),
                        ),
                        Text(
                          widget.gender,
                          style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: size.width * 0.06,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs.${widget.price}',
                          style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: size.width * 0.045,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                            addToWishList(context);
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width,
                      height: size.height * 0.17,
                      child: Text(
                        widget.desc,
                        style: GoogleFonts.cabin(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('cart')
                .add({
              'brand': widget.brandName,
              'gender': widget.gender,
              'image': widget.imageUrl,
              'ownerId': widget.ownerId,
              'code': widget.productId,
              'quantity': 1,
              'name': widget.name,
              'price': widget.price,
            }).whenComplete(() {
              showSnackBarSuccess(context, 'Added to cart');
              Navigator.pop(context);
            });
          },
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.07,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: 5),
            child: Text(
              'Add to cart',
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

  addToWishList(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishList')
        .doc()
        .set({
      'image': widget.imageUrl,
      'brand': widget.brandName,
      'price': widget.price,
      'gender': widget.gender,
      'quantity': 1,
      'productId': widget.productId,
      'ownerId': widget.ownerId,
      'code': widget.productId,
      'name': widget.name,
    }).whenComplete(() {
      showSnackBarSuccess(context, 'Product added to wishlist');
      setState(() {
        isLiked != isLiked;
      });
    });
  }
}
