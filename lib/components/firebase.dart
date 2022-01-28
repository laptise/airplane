import 'dart:convert';

import 'package:airplane/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

class FsRefs {
  static CollectionReference<Sender> get senderColRef =>
      FbUtil.fireStore.collection("senders").withConverter(
          fromFirestore: Sender.fromFirestore, toFirestore: Sender.toFirestore);
}

class Sender {
  String name;
  Sender(this.name);
  Sender.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) : name = snapshot.data()!["name"];
  static Map<String, Object?> toFirestore(Object? value, SetOptions? options) {
    if (value != null) {
      return jsonDecode(jsonEncode(value));
    } else {
      return {};
    }
  }
}

var test = {"fromFirestore": 2};

typedef FromFirestore<T> = T Function(
  DocumentSnapshot<Map<String, dynamic>> snapshot,
  SnapshotOptions? options,
);
typedef ToFirestore<T> = Map<String, Object?> Function(
  T value,
  SetOptions? options,
);
