import 'package:cloud_firestore/cloud_firestore.dart';

import 'instance.dart';

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
        createdAt = FromFS.updatedAt(snapshot),
        updatedAt = FromFS.createdAt(snapshot);

  static Map<String, Object?> toFirestore(UserDoc value, SetOptions? options) {
    return {
      "name": value.name,
      "lcName": value.lcName,
      "note": value.note,
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
}

class Premiums {
  UserDoc user;
  Premiums(this.user);
}

// class AuthInfo {
//   String name;
//   String id;
//   AuthInfo(this.id, this.name);
//   PremiumUser? premiumUserInfo;

//   static CollectionReference<AuthInfo> get colRef =>
//       FbUtil.fireStore.collection("users").withConverter(
//           fromFirestore: AuthInfo.fromFirestore,
//           toFirestore: AuthInfo.toFirestore);

//   static CollectionReference<AuthInfo> get premiumsRef =>
//       FbUtil.fireStore.collection("premiumUsers").withConverter(
//           fromFirestore: AuthInfo.fromFirestore,
//           toFirestore: AuthInfo.toFirestore);

//   AuthInfo.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   )   : id = snapshot.id,
//         name = snapshot.data()!["name"];

//   static Map<String, Object?> toFirestore(
//       AuthInfo? value, SetOptions? options) {
//     if (value == null) throw Error();
//     return {"name": value.name};
//   }

  // static Future<AuthInfo> getFromUid(String uid) async {
  //   final snapshot = await AuthInfo.colRef.doc(uid).get();
  //   final userInfo = snapshot.data();
  //   if (userInfo == null) throw Error();
  //   return userInfo;
  // }

//   static Future<AuthInfo> getFromPremiumUsers(String uid) async {
//     final snapshot = await AuthInfo.premiumsRef.doc(uid).get();
//     final userInfo = snapshot.data();
//     if (userInfo == null) throw Error();
//     userInfo.premiumUserInfo = await PremiumUser.getFromUid(uid);
//     return userInfo;
//   }

//   static Future<void> insertNewUser(AuthInfo ref) async {
//     await AuthInfo.colRef.doc(ref.id).set(ref);
//   }
// }
