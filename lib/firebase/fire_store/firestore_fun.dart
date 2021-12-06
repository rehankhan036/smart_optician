import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDatabase {
  String usersCollection = 'users';

  void changeState(String userId, int userState) {
    FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(userId)
        .update({'userState': userState});
  }
}
