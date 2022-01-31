import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'instance.dart';

///プラン
class Plan {
  late String id;
  String owner;
  String name;
  String note;
  int price;

  static CollectionReference<Plan> get colRef =>
      FbUtil.fireStore.collection("plans").withConverter(
          fromFirestore: Plan.fromFirestore, toFirestore: Plan.toFirestore);

  Plan(this.owner, this.name, this.note, this.price);

  Plan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"],
        note = snapshot.data()!["note"],
        price = snapshot.data()!["price"],
        owner = snapshot.data()!["owner"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value == null) throw Error();
    return jsonDecode(jsonEncode(value));
  }

  static Future<List<Plan>> getFromOwnerUid(String uid) async {
    final res = await Plan.colRef.where("owner", isEqualTo: uid).get();
    return res.docs.map((e) => e.data()).toList();
  }

  static Future<void> makeNewPlan(Plan plan) async {
    await Plan.colRef.add(plan);
  }
}
