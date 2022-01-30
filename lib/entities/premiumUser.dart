import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'instance.dart';
import 'plan.dart';

class PremiumUser {
  String name;
  String lcName;
  String id;
  String note;

  PremiumUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"],
        note = snapshot.data()!["note"] ?? "",
        lcName = snapshot.data()!["lcName"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value == null) throw Error();
    return jsonDecode(jsonEncode(value));
  }

  static CollectionReference<PremiumUser> get colRef =>
      FbUtil.fireStore.collection("premiumUsers").withConverter(
          fromFirestore: PremiumUser.fromFirestore,
          toFirestore: PremiumUser.toFirestore);

  /// Search Premium users by name case insentive.
  static Future<List<PremiumUser>> searchByName(String nameKeyword) async {
    final res = await PremiumUser.colRef
        .orderBy("lcName")
        .startAt([nameKeyword]).endAt([nameKeyword + '\uf8ff']).get();
    final docs = res.docs.map((x) => x.data()).toList();
    return docs;
  }

  static Future<PremiumUser> getFromUid(String uid) async {
    final snapshot = await PremiumUser.colRef.doc(uid).get();
    final data = snapshot.data();
    if (data == null) throw Error();
    return data;
  }

  Future<List<Plan>> getAllPlans() async {
    return await Plan.getFromOwnerUid(id);
  }
}
