import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FbUtil {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get fireStore => FirebaseFirestore.instance;
  static User get currentUser {
    final user = FbUtil.auth.currentUser;
    if (user != null) {
      return user;
    } else {
      throw Error();
    }
  }
}
