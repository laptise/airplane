import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreField {
  final String type;
  const FirestoreField(this.type);
}

class Plan {
  String? id;
  String owner;
  String name;
  String note;
  int price;
  DateTime createdAt;
  DateTime updatedAt;

  static final CollectionReference<Plan> colRef = FirebaseFirestore.instance
      .collection("plans")
      .withConverter(
          fromFirestore: Plan.fromFirestore, toFirestore: Plan.toFirestore);

  Plan(this.owner, this.name, this.note, this.price, this.createdAt,
      this.updatedAt);

  Plan.createNew(this.owner, this.name, this.note, this.price)
      : updatedAt = DateTime.now(),
        createdAt = DateTime.now();

  Plan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        name = snapshot.data()!["name"],
        note = snapshot.data()!["note"],
        price = snapshot.data()!["price"],
        createdAt = (snapshot.data()!["createdAt"] as Timestamp).toDate(),
        updatedAt = (snapshot.data()!["updatedAt"] as Timestamp).toDate(),
        owner = snapshot.data()!["owner"];

  static Map<String, Object?> toFirestore(Plan value, SetOptions? options) {
    return {
      "name": value.name,
      "note": value.note,
      "price": value.price,
      "owner": value.owner,
      "createdAt": Timestamp.fromDate(value.createdAt),
      "updatedAt": Timestamp.fromDate(value.updatedAt)
    };
  }

  static Future<Plan?> getFromId(String id) async {
    final snapshot = await Plan.colRef.doc(id).get();
    return snapshot.data();
  }

  static Future<List<Plan>> getListFromOwnerUid(String uid) async {
    final res = await Plan.colRef.where("owner", isEqualTo: uid).get();
    return res.docs.map((e) => e.data()).toList();
  }

  static Stream<QuerySnapshot<Plan>> getListStreamFromOwnerUid(String uid) {
    return Plan.colRef.where("owner", isEqualTo: uid).snapshots();
  }

  Future<Plan> upsert() async {
    await Plan.colRef.doc(id).set(this);
    return this;
  }

  Future<Plan> delete() async {
    await Plan.colRef.doc(id).delete();
    return this;
  }
}
