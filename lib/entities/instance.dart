import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FbUtil {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get fireStore => FirebaseFirestore.instance;
}

class EntityTemplate {
  String id;
  String param;

  static final CollectionReference<EntityTemplate> colRef =
      FirebaseFirestore.instance.collection("premiumUsers").withConverter(
          fromFirestore: EntityTemplate.fromFirestore,
          toFirestore: EntityTemplate.toFirestore);

  EntityTemplate.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        param = snapshot.data()!["param"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    throw "実装してください";
  }
}
