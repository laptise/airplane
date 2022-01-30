import 'dart:convert';

import 'package:airplane/entities/premiumUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'instance.dart';

class AuthInfo {
  String name;
  String id;
  AuthInfo(this.id, this.name);
  PremiumUser? premiumUserInfo;

  static CollectionReference<AuthInfo> get colRef =>
      FbUtil.fireStore.collection("users").withConverter(
          fromFirestore: AuthInfo.fromFirestore,
          toFirestore: AuthInfo.toFirestore);

  static CollectionReference<AuthInfo> get premiumsRef =>
      FbUtil.fireStore.collection("premiumUsers").withConverter(
          fromFirestore: AuthInfo.fromFirestore,
          toFirestore: AuthInfo.toFirestore);

  AuthInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"];

  static Map<String, Object?> toFirestore(
      AuthInfo? value, SetOptions? options) {
    if (value == null) throw Error();
    return {"name": value.name};
  }

  static Future<AuthInfo> getFromUid(String uid) async {
    final snapshot = await AuthInfo.colRef.doc(uid).get();
    final userInfo = snapshot.data();
    if (userInfo == null) throw Error();
    return userInfo;
  }

  static Future<AuthInfo> getFromPremiumUsers(String uid) async {
    final snapshot = await AuthInfo.premiumsRef.doc(uid).get();
    final userInfo = snapshot.data();
    if (userInfo == null) throw Error();
    userInfo.premiumUserInfo = await PremiumUser.getFromUid(uid);
    return userInfo;
  }

  static Future<void> insertNewUser(AuthInfo ref) async {
    await AuthInfo.colRef.doc(ref.id).set(ref);
  }
}
