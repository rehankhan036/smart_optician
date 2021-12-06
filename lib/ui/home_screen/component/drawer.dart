import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/ui/authentication_screen/login_screen.dart';
import 'package:smart_optician/ui/cart_screen/cart_screen.dart';
import 'package:smart_optician/ui/chat_screen/list_of_chat_users.dart';
import 'package:smart_optician/ui/my_orders/my_orders.dart';
import 'package:smart_optician/ui/profile/profile_screen.dart';
import 'package:smart_optician/ui/wish_list/wish_list.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      height: size.height,
      decoration: BoxDecoration(color: Colors.grey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.7,
            height: size.height * 0.22,
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return InkWell(
                          onTap: () {
                            print(snapshot.data['phoneNum']);
                          },
                          child: Container(
                            width: size.width * .28,
                            height: size.width * 0.28,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        NetworkImage(snapshot.data['image']))),
                          ),
                        );
                      } else {
                        return Container(
                          width: size.width * .28,
                          height: size.width * 0.28,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        );
                      }
                    }),
                Container(
                  margin: EdgeInsets.only(top: 7, left: 10),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data['firstName']}",
                                style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.width * 0.045),
                              ),
                              Text(
                                "${FirebaseAuth.instance.currentUser?.email}",
                                style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.width * 0.035),
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      }),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          drawerTile(
              size: size,
              text: 'Wishlist ',
              voidCallback: () {
                goBackPreviousScreen(context);
                screenPush(context, WishList());
              }),
          drawerTile(
              size: size,
              text: 'My orders',
              voidCallback: () {
                goBackPreviousScreen(context);
                screenPush(context, MyOrders());
              }),
          drawerTile(
              size: size,
              text: 'Cart',
              voidCallback: () {
                goBackPreviousScreen(context);
                screenPush(context, CartScreen());
              }),
          drawerTile(
              size: size,
              text: 'Messages',
              voidCallback: () {
                goBackPreviousScreen(context);
                screenPush(
                    context,
                    ListOfChatUsers(
                      color: Colors.black,
                    ));
              }),
          drawerTile(
              size: size,
              text: 'Profile',
              voidCallback: () {
                goBackPreviousScreen(context);
                screenPush(context, ProfileScreen());
              }),
          drawerTile(
              size: size,
              text: 'LogOut',
              voidCallback: () {
                FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.pop(context);
                  screenPushRep(context, const LoginScreen());
                });
              }),
        ],
      ),
    );
  }

  drawerTile(
      {required String text,
      required VoidCallback voidCallback,
      required Size size}) {
    return InkWell(
        onTap: voidCallback,
        child: Container(
          margin:
              EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.07),
          child: Text(
            '$text',
            style: GoogleFonts.cabin(
                color: Colors.white, fontSize: size.width * 0.06),
          ),
        ));
  }
}
