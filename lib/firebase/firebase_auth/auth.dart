import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';
import 'package:smart_optician/firebase/fire_store/firestore_auth.dart';
import 'package:smart_optician/ui/authentication_screen/login_screen.dart';
import 'package:smart_optician/ui/home_screen/home_screen.dart';

class AuthOperations {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUp(
      {required BuildContext context,
      required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String address,
      required String phoneNum}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        User? user = _auth.currentUser;
        Map<String, dynamic> map = {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'phoneNum': phoneNum,
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png',
        };
        FireStoreAuthData().storeSignUpData(map);
        if (user != null && !user.emailVerified) {
          showSnackBarSuccess(context, 'Please verify your email first.');
          await user.sendEmailVerification();
          screenPushRep(context, const LoginScreen());
          return;
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Something is wrong.', backgroundColor: Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBarFailed(context, 'The password provided is too weak.');

        Fluttertoast.showToast(msg: '', backgroundColor: Colors.red);
      } else if (e.code == 'email-already-in-use') {
        showSnackBarFailed(
            context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null && !user.emailVerified) {
          showSnackBarFailed(context, 'Please verify your email');
          await user.sendEmailVerification();
          return true;
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((value) {
            screenPushRep(context, const HomeScreen());
            return true;
          });
          return true;
        }
      } else {
        showSnackBarFailed(context, 'Something is wrong');
        return true;
      }
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        showSnackBarFailed(context, 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        showSnackBarFailed(context, 'Password is wrong');
      }
      return true;
    }
  }

  forgotPassword(BuildContext context, String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      showSnackBarSuccess(context, 'Please check your email ($email)');
      Navigator.pop(context);
    });
  }
}
