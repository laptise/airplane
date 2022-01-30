import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'instance.dart';

///プラン
class Plan {
  String id;
  String owner;

  static CollectionReference<Plan> get colRef =>
      FbUtil.fireStore.collection("plans").withConverter(
          fromFirestore: Plan.fromFirestore, toFirestore: Plan.toFirestore);

  Plan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        owner = snapshot.data()!["owner"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value == null) throw Error();
    return jsonDecode(jsonEncode(value));
  }

  static Future<List<Plan>> getFromOwnerUid(String uid) async {
    final res = await Plan.colRef.where("owner", isEqualTo: uid).get();
    return res.docs.map((e) => e.data()).toList();
  }
}
