import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreAuthData{
  storeSignUpData(Map<String,dynamic> data){
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(data).whenComplete((){
      print("Auth data is stored");
    });
  }
}