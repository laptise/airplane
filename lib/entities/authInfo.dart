import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'instance.dart';

class AuthInfo {
  String name;
  late String id;
  AuthInfo.name(this.name);

  static CollectionReference<AuthInfo> get colRef =>
      FbUtil.fireStore.collection("users").withConverter(
          fromFirestore: AuthInfo.fromFirestore,
          toFirestore: AuthInfo.toFirestore);

  AuthInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value == null) throw Error();
    return jsonDecode(jsonEncode(value));
  }

  static Future<AuthInfo> getFromUid(String uid) async {
    final snapshot = await AuthInfo.colRef.doc(uid).get();
    final userInfo = snapshot.data();
    if (userInfo == null) throw Error();
    return userInfo;
  }
}
