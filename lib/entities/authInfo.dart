import 'dart:convert';

import 'package:airplane/http/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'instance.dart';
import 'package:http/http.dart' as http;

class FromFS {
  static updatedAt(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      (snapshot.data()!["updatedAt"] as Timestamp).toDate();
  static createdAt(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      (snapshot.data()!["createdAt"] as Timestamp).toDate();
}

class ToFs {
  static updatedAt(dynamic value) => Timestamp.fromDate(value);

  static createdAt(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      (snapshot.data()!["createdAt"] as Timestamp).toDate();
}

class UserDoc {
  String id;
  String name;
  String lcName;
  String note;
  bool isPremium = false;
  DateTime createdAt;
  DateTime updatedAt;
  String? profileImg;
  String? paymentId;

  UserDoc.createNew(this.id, this.name, this.note)
      : lcName = name.toLowerCase(),
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  static final CollectionReference<UserDoc> colRef = FbUtil.fireStore
      .collection("users")
      .withConverter(
          fromFirestore: UserDoc.fromFirestore,
          toFirestore: UserDoc.toFirestore);

  UserDoc.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"],
        lcName = snapshot.data()!["lcName"],
        note = snapshot.data()!["note"],
        isPremium = snapshot.data()!["isPremium"],
        paymentId = snapshot.data()?["paymentId"],
        createdAt = FromFS.updatedAt(snapshot),
        updatedAt = FromFS.createdAt(snapshot);

  static Map<String, Object?> toFirestore(UserDoc value, SetOptions? options) {
    return {
      "name": value.name,
      "lcName": value.lcName,
      "note": value.note,
      "paymentId": value.paymentId,
      "createdAt": Timestamp.fromDate(value.createdAt),
      "updatedAt": Timestamp.fromDate(value.updatedAt),
      "isPremium": value.isPremium
    };
  }

  Future<UserDoc> upsert() async {
    await UserDoc.colRef.doc(id).set(this);
    return this;
  }

  static Future<UserDoc> getFromUid(String uid) async {
    final snapshot = await UserDoc.colRef.doc(uid).get();
    final userInfo = snapshot.data();
    if (userInfo == null) throw Error();
    return userInfo;
  }

  /// Search Premium users by name case insentive.
  static Future<List<UserDoc>> searchByName(String nameKeyword) async {
    final res = await UserDoc.colRef
        .where("isPremium", isEqualTo: true)
        .orderBy("lcName")
        .startAt([nameKeyword]).endAt([nameKeyword + '\uf8ff']).get();
    final docs = res.docs.map((x) => x.data()).toList();
    return docs;
  }

  static Stream<DocumentSnapshot<UserDoc>> getStreamFromUid(String uid) {
    return UserDoc.colRef.doc(uid).snapshots();
  }

  Premiums? get premiums => isPremium ? Premiums(this) : null;

  String get _aPaymentsToken {
    final str = "$id:$paymentId";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(str);
  }

  Future<dynamic> getStripeInfo() async {
    final res = await http.get(
        Uri.parse(Req.targetUrl + 'api/v3/customer/info'),
        headers: {"A-Payments": _aPaymentsToken});
    final decoded = jsonDecode(res.body);
    return decoded;
  }

  Future<void> updateCard(CardFieldInputDetails card) async {
    final res = await http.post(
        Uri.parse(Req.targetUrl + 'api/v3/customer/info'),
        body: jsonEncode(card),
        headers: {"A-Payments": _aPaymentsToken});
  }
}

class Premiums {
  UserDoc user;
  Premiums(this.user);
}
