import 'dart:convert';

import 'package:airplane/entities/instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInfo {
  String id;
  DateTime startedAt;
  String planId;
  String consumerUid;
  DateTime? renewAt;
  DateTime? expiredAt;
  String? extendedPayment;

  static CollectionReference<PaymentInfo> get colRef =>
      FbUtil.fireStore.collection("payments").withConverter(
          fromFirestore: PaymentInfo.fromFirestore,
          toFirestore: PaymentInfo.toFirestore);

  PaymentInfo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  )   : id = snapshot.id,
        startedAt = snapshot.data()!["startedAt"],
        planId = snapshot.data()!["planId"],
        consumerUid = snapshot.data()!["consumerUid"],
        renewAt = snapshot.data()!["renewAt"];

  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value == null) throw Error();
    return jsonDecode(jsonEncode(value));
  }

  static Future<List<PaymentInfo>> getValidPaymentsFromPlanId(
      String planId) async {
    final snapshot = await PaymentInfo.colRef
        .where("planId", isEqualTo: planId)
        .where("expired", isNull: true)
        .get();
    return snapshot.docs.map((e) => e.data()).toList();
  }
}
