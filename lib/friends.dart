import 'package:airplane/components/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsTop extends StatelessWidget {
  const FriendsTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: const [ProfileBadge()]));
  }
}

class ProfileBadge extends StatelessWidget {
  const ProfileBadge({Key? key}) : super(key: key);

  Future<void> getName() async {
    final users = FbUtil.fireStore.collection("user");
    final doc = await users.doc(FbUtil.currentUser.uid).get();
    print(doc);
    return;
  }

  @override
  Widget build(BuildContext context) {
    getName();
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.1, color: Color.fromRGBO(0, 0, 0, 0.8)))),
        padding: const EdgeInsets.all(8.0),
        child: Text(FirebaseAuth.instance.currentUser?.email ?? ""));
  }
}
